---
title:  "Systemd 服务简明教程"
layout:  post
date:    2024-04-28
categories: jekyll update
tags:    tech linux systemd
---

# Systemd 服务简明教程

systemd 是Linux下新的init系统，用于代替老式的 SysV Init。

有一些特征可以区分两者：
说明         | SysV Init            | Systemd
-----------|----------------------|-----------------------
主要命令     | service dummy status | systemctl status dummy
配置文件目录 | /etc/rc.d/init.d/    | /etc/systemd/system/
关机命令     | poweroff             | systemctl poweroff


## 简单的配置文件

我在github gists 里面写了两个简单的例子，也是我会用到的了。

```ini
[Unit]
Description=Enable Wake-up on LAN

[Service]
Type=oneshot
ExecStart=/sbin/ethtool -s eno1 wol g

[Install]
WantedBy=basic.target
```

以上是一个开启网卡WOL功能的Service文件，最关键的就是oneshot类型，表示程序（ExecStart部分）只需要执行一下即可，执行完正常退出就算服务正常启动了。


```ini
[Unit]
Description=qBittorrent Downloader
After=network-online.service

[Service]
Type=simple
User=xxxx
ExecStart=/usr/bin/qbittorrent-nox

[Install]
WantedBy=multi-user.target
```

以上是我把qbittorrent当作服务来启动的配置文件，其中类型为simple，就是这个程序只要运行着就可以了，程序退出了就说明服务出现了问题。
另外我还要指定程序要以什么用户的身份来执行。 以及指定了启动顺序（After），要在网络好了之后启动（个人理解）。

- 创建服务可以
   1. 直接编辑 '/etc/systemd/system/xxx.service' 来创建
   1. 也可以通过命令创建 `systemctl edit --force --full xxx.service` (推荐)

- 创建完毕之后需要执行两条命令来使服务生效：
   - `sudo systemctl daemon-reload` ，更新服务信息。
   - `sudo systemctl enable wol-enable.service` ，开启创建的服务。

## Refer

- [systemd 与 sysVinit 彩版对照表](https://linux.cn/article-3794-1.html) , 有详细说明和完善的引用说明。
- [Systemd命令速查（cheat sheet）](https://www.linuxtrainingacademy.com/systemd-cheat-sheet/)
- [SysVinit 和 Systemd 对比](http://www.linuxcoming.com/blog/2019/03/18/sysvinit_vs_systemd.html)