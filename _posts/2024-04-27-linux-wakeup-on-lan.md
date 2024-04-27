---
title:  "Linx系统配置网络唤醒"
layout:  post
date:    2024-04-27
categories: jekyll update linux ubuntu tech newwork
---


# Linx系统配置网络唤醒

想要配置Linux通过网络唤醒，这样可以随时控制开机，并登录相关服务器。
该功能英文名字为 wakeup-on-lan (WOL).

## 开启步骤

- 需要用到工具‘ethtool’，安装命令：`sudo apt install ethtool`
- 查看用到的网卡： `ip a` , 例如下面的输出，用到的网卡接口是 ‘eno1’
```sh
zpz@nuc6i3:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether f4:4d:30:6e:d9:7a brd ff:ff:ff:ff:ff:ff
    altname enp0s31f6
    inet 192.168.1.147/24 brd 192.168.1.255 scope global dynamic noprefixroute eno1
       valid_lft 133386sec preferred_lft 133386sec
    inet6 fe80::e2c3:cf5d:931:35b/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: wlp1s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether a0:c5:89:70:06:fc brd ff:ff:ff:ff:ff:ff
```

- 执行命令 `sudo ethtool eno1` 查看网络接口状态，得到类似以下的输出，其中 Wake-on 的值为 g 则是开启了， 为 d 则是禁用了。
    （在此之前还得确认主板BIOS开启了网络唤醒）（如果网卡不支持WOL的话可能没有这一项）
```sh
zpz@nuc6i3:~$ sudo ethtool eno1
Settings for eno1:
        Supported ports: [ TP ]
        ...
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: Twisted Pair
        PHYAD: 1
        Transceiver: internal
        MDI-X: off (auto)
        Supports Wake-on: pumbg
        Wake-on: g
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes
```

有些主板通过上面步骤开启了WOL之后，重启依然会进入关闭状态，这时可以创建一个启动服务，在系统启动时再次开启WOL。

- 通过命令 `sudo --preserve-env systemctl edit --force --full wol-enable.service` 创建服务，或者直接在对应位置创建文件 `sudo vi /etc/systemd/system/wol-enable.service`

```ini
[Unit]
Description=Enable Wake-up on LAN

[Service]
Type=oneshot
ExecStart=/sbin/ethtool -s eno1   wol g

[Install]
WantedBy=basic.target
```

- 配置完成之后还需要执行：
   - `sudo systemctl daemon-reload` ，更新服务信息。
   - `sudo systemctl enable wol-enable.service` ，开启创建的服务。

## Refer

- [How to Enable Wake-on-LAN in Ubuntu](https://www.golinuxcloud.com/wake-on-lan-ubuntu/#Auto_Wake-On-Lan_Activation_at_Startup)
