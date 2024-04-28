---
title:  "从鲲鹏920聊聊自研核"
layout:  post
date:    2022-03-15
categories: jekyll update
tags:    tach uarch modeling
---

# 从鲲鹏920聊聊自研核

(自简书账户同步)

就是瞎聊，也希望更多人了解到这个CPU而写的。

## 背景

  华为自研处理器已经有很多年了，但是直到鲲鹏920面世才广为人知。鲲鹏920处理器采用ARM指令集架构，自主研发处理器微架构（类似Apple A15处理器和ARM架构的关系）。

### 自研核的性能

  包含自研核的处理器——鲲鹏920，其性能可以对标intel高性能服务器（xeon-8180），虽然单核性能还是略低于skylake，但是得益于更优秀的能效比和更多的核心，服务器整机性能比intel对标产品要好。

  鲲鹏920的处理器核 是超标量乱序多发射处理器，其发射带宽、执行单元数量、乱序深度这些硬指标都是业界第一梯队的（不得不提依然落后于Apple，但是远超ARM公版）。

[参考：鲲鹏开发重点4--ARM 性能优化](https://bbs.huaweicloud.com/blogs/280561)
[参考：华为鲲鹏920与英特尔至强8180对比](https://bbs.huaweicloud.com/blogs/185122)

鲲鹏920 SoC框图
![kunpeng-920-soc.png](https://upload-images.jianshu.io/upload_images/3934566-02d0e15f97ffe8b0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 乱序处理器的性能

  这里可以简单讲讲 乱序超标量处理器的核心性能衡量方法：
 * 发射带宽（有时候是decode带宽）是处理器的最高IPC（每cycle执行指令的数量），根据执行单元的配比决定了处理器的理论最高性能。 如 发射带宽为6，执行单元 4ALU + 2Load-Store，那么每cycle最多执行6条指令，其中4个ALU+2个Load-Store。
 * 乱序深度。一般程序没有那么理想，每cycle都能给出不相关的6条指令可以执行，往往因为数据依赖或者指令配比不同（如6条指令全是Load），导致没法同时执行6条指令，这时乱序执行就很重要了。通常理解程序的指令都是按顺序执行的（程序员视角），但是硬件为了提升性能，将当前要执行指令之后的N条指令都考虑进来，如果当前的6条指令没法同时执行，就从这N条指令里面去找能够提前执行的指令，凑齐6条一起执行。这可考虑的范围就是乱序深度，比如Apple M1处理器就达到惊人的630条（[参考Anandtech](https://www.anandtech.com/show/16226/apple-silicon-m1-a14-deep-dive/2)）。
 * 在以上两项都考虑周全之后，就要考虑前端送指令的速度能不能达到（喂饱）理论发射值了（每cycle 6条指令），因为程序指令并非按照其在内存中的顺序连续执行，而是会有各种跳转，所以需要分支（跳转）预测来预测指令流会跳到哪去，并赶快从跳转地址开始取指令送到后面的执行单元（这里简化了一下），保证输送不断流；如果预测错了，还得废弃之前输送的指令重新取。所以预测的正确性就很重要了。
 * 此外，指令也好，指令要操作的数据也好，都保存在内存（RAM）中，但是内存速度相比CPU就太慢了，于是有层层Cache将常用数据放到最近最快的地方以提升性能。 而且，硬件也会去尝试猜测程序将要访问什么数据，并提前放到最近的Cache里面。现代处理器中这部分已经可以说是影响性能最大的部分了。

提升（或者说限制）性能的地方有很多，这里只是略微讲讲。（如 发射带宽可能受制于取指带宽、执行带宽、提交带宽；乱序深度受制于寄存器数量、执行队列深度、Cache的MSHR数量等）

对于以上描述一头雾水但是又感兴趣的朋友，可以找找大话处理器或者超标量处理器设计之类的书籍学习学习。

Apple A14 微架构框图
![Apple-A14-firestorm.png](https://upload-images.jianshu.io/upload_images/3934566-9bc177ac47a9edf0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



## 提升性能

  要提升性能首先要选择目标，就是要提升什么程序的性能。可以像DSP一样就是提升某种数据处理场景的性能，但是CPU的性能提升一般选择有代表性的BenchMark，如 GeekBench 和 SPEC2000 这样的测试基准程序。

  然后，就是分析这些程序的指令模式，找出处理器的短板，并进行改良。例如，处理器在运行SPEC程序时，发现大部分时间都没法做到每cycle执行6条指令，原因是SPEC程序cache命中率低，处理器等待数据从RAM送过来，所以我们可以加大Cache容量来保存更多的数据以提升性能，或者提高cache利用率（将更有用的数据保存在cache），或者想办法提前把要用的数据搬运到cache中去，等等。

  提升性能就是反复的分析现状、找到问题、给出改善方法，如此一步步、一点点提升处理器的性能。这里讲的都很简单笼统，真实情况往往要复杂的多。（此外，提升性能的一个重要方法就是提升频率，这又是另一个故事了）

### 提升性能的重要工具

  如上所示的过程中，提升性能需要用到很多工具，其中一个重要工具就是处理器的模型。

  因为现实中不可能做到等CPU都生产出来了，再去分析程序行为找出短板，然后再生产一个处理器，然后分析短板。这种代价没有哪个公司能够承受得了。（设计生产一个处理器需要至少一年的时间和至少几亿元的金钱，当然量产之后会摊平这个成本）

  于是能够在处理器设计生产之前就进行性能分析改善非常有必要，但是这时候没有产品怎么进行分析呢？于是就做一个处理器的模型，这个模型要能够足够精确的反映最终产品的性能，然后分析程序行为、处理器短板的过程就在这个模型上进行。等到这个模型所反映的性能达到目标了，就按照这个模型来设计处理器，并最终生产出性能达标的产品。

  学术界常用的处理器性能模型有Gem5，是开源的，感兴趣的朋友可以找来玩一玩，探索探索现代处理器的性能。
  这种模型不光有反映性能的模型，也有反映功耗的，反映成本的，等等。

不过也别忘了：“All models are wrong, but some are useful.”
![all-models-are-wrong.jpg](https://upload-images.jianshu.io/upload_images/3934566-88eccb81c3033c12.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 小结

  这里从鲲鹏920开始，聊到自研处理器，聊到处理器性能，又聊了聊怎么提升处理器的性能，以及提升性能用到的重要工具。
