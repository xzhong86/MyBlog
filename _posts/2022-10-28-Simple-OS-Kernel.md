---
title:  "简单OS-Kernel设想"
layout:  post
date:    2022-10-28 20:41:42 +0800
categories: jekyll update
tags: idea geek
---


# 简单OS-Kernel设想

设计一个简单的OS Kernel的想法。

## 初步目标
初步目标：能启动busybox-static
    先不支持网络，busybox最好不做修改

为什么选择这样的目标呢？ 这涉及到OS Kernel到底是什么。 简单来说， 就是想Linux Kernel那样的东西， 运行在内核态，提供一组标准系统调用给用户态程序； 管理硬件，提供给用户程序一组操作硬件的接口； 以及，提供更复杂的服务 如虚拟文件系统、网络协议栈等。

### 其他说明
一个简单的OS可以比这个目标更简单，就像嵌入式OS、实时操作系统等，但是这样就没有一个“操作系统”的感觉，更像是具备操作系统特性的程序。

这个目标需要实现要更复杂一些，要把busybox启动起来，至少需要支持若干系统调用，如文件读写、目录访问，这就需要支持一个文件系统才行了；busybox实现的shell应该是使用的console，所以linux的tty操作也需要支持。
为简化目标，不支持网络、设备管理等， 同时完全使用linux兼容的系统调用，即 该busybox可以直接跑在linux内核的系统上。
为简化目标，OSK基于ARM64来实现，硬件设备为树莓派-2-v1.2之后的64位产品。 选择理由是 ARM64我比较熟悉，比x86简单，硬件设备也很好买到。

为简化编码，代码使用C/C++混合形式，主要是我已经使用C++多年，完全不使用C++会感觉束手束脚，但是也不会太多C++特性，内核编程环境也不允许。

实现过程中必然还会出现意料之外的问题、需求， 那些到时候再说吧。

## 预计需要支持：
内核特性：
1. 页管理，内存管理
1. 串口设备管理，映射为console设备

用户层接口：
1. 简单文件系统（FAT32？），以支持基本的系统调用
1. 支持必要的console机能，tty，ioctl

## 实现步骤
 1. 基本环境搭建
    1. 树莓派裸机程序启动（带串口输出）
    1. QEMU 环境准备，之后大部分开发调试都只是用QEMU进行。
 1. 实现基本硬件控制代码
    1. 布局基本代码结构
    1. 实现中断控制器相关代码
    1. 实现MMU相关代码
    1. 实现串口控制代码
 1. 实现内核线程
    1. 实现内核线程基础代码，可以进行线程切换
    1. 实现线程控制代码，可以让渡、终止线程
 1. 实现页管理、内存管理、线程通信
    1. 实现页管理代码， 参考伙伴系统
    1. 实现内存管理（kmalloc），内核态使用的
    1. 实现必要的线程通信功能
 1. 实现简单文件系统访问
    1. 提前准qemu环境下的SD卡设备，SD卡镜像，简单程序（static，hello world）
    1. 实现基本文件系统访问所需的代码
    1. 从文件系统加载一个elf程序(建立内存映射，不执行)
 1. 实现简单系统调用 和 用户程序执行
    1. 实现基本的 open write close， 以支持 hello world 程序
    1. 实现 hello world 所需的其他调用
 1. 启动busybox
    1. 根据情况，实现所需的其他调用
 
 1. 【待选】代码整理
    1. 实现内核代码模块化
 


