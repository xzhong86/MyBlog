---
title:  "GPerfTools 简单教程"
layout:  post
date:    2024-04-03
categories: jekyll post tech profiling
---

# GPerfTools 简单教程

这里只介绍了基本使用方法，深入使用请查看参考链接和官方手册。

(此文亦发布在简书)

## 编译GPerfTools

- 获取源码：[github: gperftools](https://github.com/gperftools/gperftools) , 从release下载源码包。
- 解压编译源码：`./configure --prefix=$HOME/opt/gperftools && make -j && make install`。
   - 忽略的解压步骤就不赘述了。

## 运行需求

- 需要绘图的话需要工具：‘graphviz’。画图相关功能都会用到dot工具。
   - 各Linux环境怎么安装就不在这赘述了（例如ubuntu可以直接`apt install graphviz`）。


## 运行分析

- 编译时链接库：`g++ xxx.cpp $HOME/opt/gperftools/lib/libprofiler.so` , 或者加入到构建文件中。
   - 或者配置预加载库环境变量：`export LD_PRELOAD=$HOME/opt/gperftools/lib/libprofiler.so` 以加载库
    （这样就不需要编译时做什么改变）。

- 运行时需要配置环境变量 `export CPUPROFILE=./test.prof`
   - 配置该环境变量即可开启profiling，同时也是指定了采样存储文件。
   - 环境变量 `export CPUPROFILE_FREQUENCY=200` 可以修改采样频率（默认100Hz）

  > 不能再shell环境变量中同时配置了LD_PRELOAD 和 CPUPROFILE，相当于当前shell的所有程序都进行profile。
    可以写一个脚本，在脚本内配置这些环境变量，并执行想要分析的程序。

- 生成分析报告
   - `pprof binary.file test.prof` , 互交模式
   - `pprof --text binary.file test.prof`, 直接输出，每行一个数据，默认以函数为单位。
   - `pprof --web binary.file test.prof`, 生成svg文件（在临时目录），并用浏览器打开。
      - 鉴于某些垃圾环境，用默认浏览器打开后，反应慢，操作不便，建议保存svg文件，用别的工具打开。
   - `pprof --svg binary.file test.prof > profile.svg`, 生成svg文件。
      - 可以使用eog命令（Eye Of Gnome）打开（先`ma eog/3.xx`）。(顺便发现了一个Geeqie的工具还挺厉害)


### 报告格式

命令 `pprof --text binary.file text.prof` 的输出样例：
```text
Total: 12475 samples
     5239  42.0%  42.0%     5239  42.0% ?? /usr/src/.../unix/syscall-template.S:78
     4127  33.1%  75.1%     6647  53.3% sysmalloc
     2520  20.2%  95.3%     2520  20.2% __GI___mmap64
      305   2.4%  97.7%     7011  56.2% __GI___libc_malloc
```

一行数据各列说明：
1. 采样数量，落在当前函数内的。
1. 采样占比，第一列数量占整体采样数量的比例。
1. 累计占比，逐行累计的采样占比，第三行的数据就是前三个的累计值。
1. 采样数量，当前函数及其子函数的合计数量。
1. 采样占比，上一列数值占整体采样数量的比例。
1. 函数名字，Symbol name。


## 对比Oprofile工具

Oprofile也是一个强大的性能分析工具。 参考[StackOverflow的回答](https://stackoverflow.com/questions/1550615/which-profiler-is-more-accurate-oprofile-or-google-performance-tools)
可知，gperftools的采样频率不如oprofile（或者perf），故精度不如oprofile。
另外oprofile可以输出xml格式的原始数据文件，可以方便用其他工具进行分析处理。


## 参考链接

- [官方手册](https://gperftools.github.io/gperftools/cpuprofile.html)，比较简洁，包含简单的使用和说明。
- [知乎文章](https://zhuanlan.zhihu.com/p/558677729) , 包含使用示例。

