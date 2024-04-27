---
title:  "QEMU Monitor 使用"
layout:  post
date:    2022-05-23
categories: jekyll update
tags:    tech qemu
---

# QEMU Monitor 使用

(从本人简书同步过来)

> 本文作为QEMU周边开发者的角度写的，不适用于一般用户。

## 问题

从命令行启动qemu之后，按键 Ctrl-a c 可以进入monitor，之后可以执行很多有用的命令。具体可以参考 https://qemu.readthedocs.io/en/latest/system/monitor.html 。但是文档没有提到的是其他进入monitor的方式，尤其是想要同时有consel 和 monitor的情况。

查询手册的执行参数一章可以看到参数 -monitor dev 可以指定monitor使用什么字符设备输出。但是用法没给，而且必须使用字符设备也比较难用。

继续查询，这个回答很有帮助，提到如何开启网络端口做monitor： https://unix.stackexchange.com/questions/426652/connect-to-running-qemu-instance-with-qemu-monitor

## 问题解决

再查阅手册，问题已经明白了。 dev设备 可以是很多形式，在执行参数 -serial dev 里面讲的很全面。https://qemu.readthedocs.io/en/latest/system/invocation.html 。

而且这种灵活的使用方式不仅适用于monitor，也适用于 serial， 也就是能够很方便的把guest os的consel重定向到各种形式的接口上（包括 虚拟控制台，tty，网络，管道，文件等）。

QEMU的强大令人惊叹，回头看看这块源码怎么实现的。

## 使用方法

### Telnet 方法（过时，不推荐）

这里给出具体参数，省去查找的麻烦：
`qemu-system-aarch64 ... -monitor telnet:127.0.0.1:55555,server,nowait`

使用telnet即可监听端口：`telnet 127.0.0.1 55555 `

### UNIX 套接字（推荐）

UNIX套接字为简单高效建立本地进程间通信的一种机制，接口和网络套接字一致，但是内部去掉了TCP/IP协议栈的繁琐流程，提高通信效率。相关说明：https://akaedu.github.io/book/ch37s04.html

QEMU参数为： `-monitor unix:qemu-monitor-socket,server,nowait`， qemu-monitor-socket为套接字名称，可以自定义。

使用socat连接：`socat - unix-connext:qemu-monitor-socket`。 socat连接效果比telnet效果好。

socat工具十分强大，使用参考：http://brieflyx.me/2015/linux-tools/socat-introduction/ 和 https://www.jianshu.com/p/54005e3095f3。
