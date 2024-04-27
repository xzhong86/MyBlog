---
title:  "CAML 设想"
layout:  post
date:    2022-06-16 20:15:26 -0400
categories: jekyll update
tags: geek modeling
hidden:  true
---

# CAML 设想

CAML：Cycle Accurate Modeling Language，cycle级时序建模语言。一种针对 Cycle Model 建模工作设计的 DSL（Domain Specific Language 特定领域语言）。

## Why need CAML

为什么要使用CAML？
 * 让写模型的人更专注建模逻辑，不被C++特性困扰、束缚。
 * 让模型代码简介有张力，尽量只呈现业务逻辑，避免多余的代码分散注意力。

使用DSL可以隔离模型业务逻辑和模型具体实现，同时也给模型具体实现留出了优化空间。
比如，直接用C++写模型代码之后，想要调整一些组件或者基础代码的实现，就要修改很多业务代码。
如果使用DSL的话，只需要修改底层代码生成器就能达成目的，不用修改业务逻辑。

DSL的其他好处：
 * 屏蔽编程语言的底层特性，避免使用不安全的操作
 * 随时可以根据需要调整生成代码的过程，还不影响建模代码


### 代码示例

一个简单模块的语法示意：

```c++
MODULE(Dec) {

    PARAM() {
        bool sta_uop_split;
    }

    INPUT() {
        SimQueue<Inst> ifu_dec_insts_q;
        SimLatch<FlushInfo> alu_flush_l;
    }
    OUTPUT() {
        SimQueue<Uop> dec_ren_uops_q;
    }

    MEMBERS() {
        SimFlipFlop<Inst> insts_d1;
        SimBuffer<Inst> buf(PARAM.buf_size);
    }
    STATS(instance=stats) {
        Counter inst_cnt;
    }

    WHEN_VALID(ooo_flush_l) {
        auto info = ooo_flush_l.peek();
        doFlush(info->rid);
    }

    void doFlush(rid) {
        ;
    }

    EACH_CYCLE() {
        ;
    }
}
```

基本原则：
 * 基于C++语言，但是只使用C++语法的子集，屏蔽C++的复杂性。
 * 尽量避免使用C++底层特性，复杂特性，以及指针。（对于特性开发者）
 * 建模只能使用给定的 建模组件，不建议直接使用c++容器、库、组件等。

以MODULE声明定级块，module块内可以有：
 * PARAM 块， 声明此module可以配置的参数
    * 可能的参数： PARAM(alias=P)
 * INPUT块， 声明此module的输入接口
    * 相同名字的信号会自动连接，接口结构实体在output里面创建，input指向结构实体
 * OUTPUT块，声明输出
    * 所有输出信号都有至少一拍的延迟
 * MEMBERS块， 声明内部使用的信号、成员，数据结构
 * STATS块，声明统计数据结构
 * WHEN_VALID块，当信号有效时执行，时机在CYCLE开始之前
 * EACH_CYCLE块，每CYCLE执行的过程
    * 可以接受参数来指定执行优先级
 * SUB_MODULE块，声明当前module要使用的sub module。

Module的各个块可以定义在不同的文件，最终生成在同一个c++ class里面。
一个module里面的语法块可以定义多次（如 分散的INPUT声明），最终生成时会合并到一起。

平台自动生成代码去做的事情：
 * 信号自动初始化、自动互联，所有信号都配置有名字，并且有挂靠关系
 * 自动生成层次化访问所需的代码。比如 `SimGet<Counter>("top.cores.core0.dec.inst_cnt")` 可以得到对应的counter。

自动生成平台同时会检查模型业务逻辑是否有问题
 * 如，同一个cycle内，是否存在对一个flipflop信号的 写后读 操作
 * 在实践过程中可以新增各种检查逻辑，排除错误用法。

理论上生成的代码可以结合不同的仿真平台，如SystemC，Gem5，自研C++。甚至生成不同的语言，如JAVA代码（越接近C++生成会越简单）。

## 独立的Plugin接口

Plugin API，允许使用c++给模型编写插件，获取内部信息，于是需要一个稳定的插件API。

插件可以实现获取模型内的信号、计数器等信息，用于debug、pipeview、或者转换出波形。

实现大型module的方法：定义拆分（最终会合并成一个大的class）；使用SubModle拆分成子module。

## 其他

结构数组转置： （对于压缩空间，遍历结构成员有利，对于bool可以压缩成bit，bit运算能提升效率）
```c++
// 声明的等效转换
struct { bool a; int b; } vec[N];  =>  struct { bool a[N]; int b[N]; } vec;

// 使用、计算的转换
vec[i].a  =>  vec.a[i]; // 任何表达式中不能存在单纯的 vec[i]
for (i in 0..N) { vec[i].a && vec[i].c } => vec.a & vec.c

// 可能的声明方式
VecStruct(NAME, LEN) { bool a; int b; };
NAME instance;
```
