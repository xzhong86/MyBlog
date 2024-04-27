---
title:  "用户态读写磁盘镜像"
layout:  post
date:    2022-05-18
categories: jekyll update
tags:    tech qemu disk-image
---

# 用户态读写磁盘镜像

（从简书账号手动同步来）

## 问题

用户态读写虚拟机磁盘镜像文件一直都是困扰我的问题，因为工作以及各种尝试需要，偶尔需要创建读写虚拟机镜像文件，个人可以使用sudo搞定一切，但是在服务器环境下就不好轻易使用sudo了，不安全，也不一定有权限。

## 解决方法

解决方法有：fakeroot， libguestfs-tools, udisks2, archivemount。后面三个都在这个问题的回答中提到的：https://unix.stackexchange.com/questions/32008/how-to-mount-an-image-file-without-root-permission

### fakeroot

我之前制作initramfs的时候用过：
```shell
$ fakeroot
# mkdir tmp && cd tmp
# tar xf ../linaro-image-minimal-genericarmv8-20150618-754.rootfs.tar.gz
# find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > ../initramfs.cpio.gz
# exit
```

### libguestfs-tools

这个是看了一圈之后最为完善的解决方案。该工具组包含多个工具，其中两个：
  * guestmount： https://libguestfs.org/guestmount.1.html。用户态mount镜像文件。
  * guestfish： https://libguestfs.org/guestfish.1.html。用户态mount，并且提供一个shell，做一些需要root权限的操作。

安装libguestfs-tools：Debian/Ubuntu `sudo apt-get install libguestfs-tools`  , Redhat/Centos/Fedora `sudo yum install libguestfs-tools`

具体用法可以参考我另一篇文章： [Guestfish 工具使用](https://www.jianshu.com/p/417d7e05f312)

### udisks2

这个页面有简单使用说明（还包括其他数个工具）： https://wiki.debian.org/ManipulatingISOs

## 其他
Alpine Linux：https://zh.wikipedia.org/zh-tw/Alpine_Linux 。 轻量级Linux发行版。
Open Embedded： https://zh.m.wikipedia.org/zh/OpenEmbedded 。 嵌入式Linux发行版。
其他：buildroot， OpenWRT，
