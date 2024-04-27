---
title:  "OpenWRT 挂载 F2FS 延长SD卡寿命"
layout:  post
date:    2021-07-14
categories: jekyll update
tags:    tech openwrt f2fs
---

# OpenWRT 挂载 F2FS 延长SD卡寿命

（同步自简书账户）

## 问题描述
在家使用树莓派安装OpenWRT系统做单臂路由，同时还做了下载服务器（下载的数据放在外挂硬盘中），7x24小时运行，结果大约用了2-3个月就挂了。几轮测试下来，我认为估计是SD卡挂了。

然后决定重新搭建服务，不过这次要吸取教训，要注意保护SD卡了。

## 解决过程
网上查了一下，常见的解决方法是使用tmpfs的内存盘挂载到系统经常会写的地方， 如 /var/tmp、/var/log 等地方，缺点是log会丢。 
后来深入了解查询之后，了解到LFS类文件系统，以及对SD卡会很友好的f2fs文件系统。 于是决定将 /var 整个挂载为f2fs文件系统。

> [参考：延长SD卡寿命](https://www.boydwang.com/2014/02/raspberry-pi-extending-the-life-of-the-sd-card/)
> [参考：LFS文件系统](https://zhuanlan.zhihu.com/p/41358013)

决定挂载新的文件系统后，发现OpenWRT的挂载系统跟常规Linux相差太大，完全不是改fstab能搞定的，修改 /etc/config/fstab 也搞不定（uci 也是修改这个文件），估计原因是 /var 以及投入使用之后 再读取的 /etc/config/fstab，导致挂载失败（没有去确认log，懒得确认了）。

查看 /etc/config/fstab 能发现一个问题，就是 / /boot /tmp 等挂载的文件系统，却不在这个文件里面，完全不明白怎么挂载进去的。

后来去找了 [OpenWRT Boot Sequence](https://openwrt.org/docs/techref/preinit_mount) , 梳理了一下这个完全不同的boot流程，最后找到一个觉得最恰当方法，添加文件 /lib/preinit/77_mount_var， 内容如下：

```sh
$ cat /lib/preinit/77_mount_var
# Copyright (C) 2015 OpenWrt.org

mount_var_fs() {
    mount -t f2fs -o noatime /dev/mmcblk0p5 /var
}

boot_hook_add preinit_mount_root mount_var_fs
```

参考 80_mount_root 的内容可知， 这个函数会在root文件系统mount之后就执行，应该没有问题。

在重启之前，或者添加上面的preinit脚本之前，就得把对应的分区准备好，把/var的内容copy过去，copy的时候注意保持文件目录的权限不变（可以使用cp -a）。

reboot重启之后，系统顺利启动了，查看mount的情况，也符合预期。（之前测试各种修改fstab的方案都启动不起来 -_- ）

## 结果确认

reboot 重启运行一段之间之后，查看磁盘IO：
```sh
$ iostat -p                    
Linux 5.4.128 (OpenWrt) 	07/14/21 	_aarch64_	(4 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.39    0.07    0.49    0.10    0.00   98.96

Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
mmcblk0           3.15        80.08         8.71         5.39     214698      23352      14440
mmcblk0p1         0.03         0.41         0.00         0.00       1098          0          0
mmcblk0p2         1.92        71.58         0.56         0.00     191919       1496          0
mmcblk0p3         0.02         0.02         0.00         0.00         66          0          0
mmcblk0p5         1.16         7.74         8.15         5.39      20745      21856      14440
```
可以看到90+%的写操作都转移了， mmcblk0p5分配了16GB容量，根据f2fs文件系统特性，应该不用愁了，且看能用多久把。

