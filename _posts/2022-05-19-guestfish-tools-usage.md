---
title:  "Guestfish 工具使用"
layout:  post
date:    2022-05-19
categories: jekyll update
tags:    tech qemu disk-image
---

# Guestfish 工具使用

(从简书账户同步)

guestfish工具是libguestfs-tools 工具箱内的一个互交式工具，可以操作管理虚拟机磁盘镜像，而且不需要管理员权限。

在使用guestfish的过程中，发现需要kvm权限（加入kvm用户组），需要访问host linux kernel (vmlinuz)，以及开启调试之后能看到kernel启动的信息，故这个工具是启动了一个虚拟机来做这些事情的。（开启调试信息 `export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1`）

guestfish官方手册：https://libguestfs.org/guestfish.1.html 。

> 如果遇到无法读取 /boot/vmlinux-xxx 的情况，是系统取消了内核文件读权限，可以手动添加上：`chmod o+r /boot/vmlinux-*`，或者参考 https://bugs.launchpad.net/fuel/+bug/1467579 里面的 `dpkg-statoverride --update --add root root 0644 /boot/vmlinux-xxx`，我不知道两者有啥区别。
> 如果遇到 “error: cannot find any suitable libguestfs supermin”， 说是当前系统发行版没有移植supermin，无解。

## QEMU qcow2 磁盘镜像

* 使用qemu-img命令创建 `qemu-img create -f qcow2 test-disk.qcow2 4G` 
  * 或者 使用guestfish创建 `guestfish disk-create test-3.qcow2 qcow2 4G`
* 初始化磁盘分区：
  * 挂载磁盘  `guestfish -a test-disk.qcow2` ，挂载后执行 `run`。
    * 执行  `list-devices`  可以查看设备列表 （如：看到 /dev/sda）
    * 初始化分区表 `part-init /dev/sda gpt`，添加分区 `part-add /dev/sda primary 1024 8388574`。 或者执行 `part-disk /dev/sda gpt` 初始化分区表并创建唯一主分区。
  * 格式化分区  `mkfs ext4 /dev/sda1` 。`list-partitions` 和 `list-filesystems` 可以查看创建的分区
  * 挂载磁盘分区 `mount /dev/sda1 /` 可以挂载到根目录。
* 复制（解压）系统文件
  * 在挂载磁盘分区之后执行 `tar-in ./linaro-image-minimal-genericarmv8-20150618-754.rootfs.tar.gz / compress:gzip`
* 测试磁盘镜像
  * 这里使用qemu虚拟的aarch64环境来测试，启动qemu看能否进入linux shell。
 ```shell
 qemu-system-aarch64 -M virt -cpu cortex-a57 -smp 8 -m 4G -nographic \
 	-kernel ./Image -drive file=test-disk.qcow2 \
 	-append 'console=ttyAMA0 root=/dev/vda1 rw earlycon'
 ```



## RAW 磁盘镜像

* 流程和qcow2格式基本一致，在某些地方需要指出磁盘格式。
* 使用dd命令创建原始文件  `dd if=/dev/zero of=test-raw.ext4 bs=1K count=1M` 或者使用guestfish：`guestfish disk-create test-raw.ext4 raw 1G`
* 初始化磁盘分区
  * 挂载磁盘 `guestfish --format=raw -a test-raw.ext4` 然后执行 `run`。
  * 初始化分区表并创建唯一主分区：`part-disk /dev/sda gpt`
* 格式化分区 `mkfs ext4 /dev/sda1`，挂载分区到根目录 `mount /dev/sda1 /`
* 解压操作系统文件： `tar-in linaro-image-minimal.rootfs.tar.gz  / compress:gzip`
* 启动QEMU测试磁盘镜像：

```shell
qemu-system-aarch64 -M virt -cpu cortex-a57 -smp 8 -m 4G -nographic \
    -kernel ./Image \
    -drive file=test-raw.ext4,format=raw  \
    -append 'console=ttyAMA0 root=/dev/vda1 rw earlycon'
```



## Guestfish Tips:

* 命令 `ls /dir`， `ll /dir`， `llz /dir`， 可以查看目录内容，路径必须是绝对路径。
* 命令 `upload` ， `download` 可以上传下载文件。

