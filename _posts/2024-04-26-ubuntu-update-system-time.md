---
title:  "Ubuntu网络更新系统时间"
layout:  post
date:    2024-04-26
categories: jekyll update
---

# Ubuntu网络更新系统时间

使用Linux命令 ntpdate 可以从网络同步时间，之后用 hwclock 命令写入系统硬件。

- 首先，需要安装ntpdate软件包： `sudo apt install ntpdate`
- 之后跟网络NTP服务器同步时间： `sudo ntpdate cn.pool.ntp.org` 。（网络授时）
- 将时间更新到硬件设备（RTC）： `sudo hwclock --systohc`
