---
title:  "Linux发行版包管理器"
layout:  post
date:    2022-05-05
categories: jekyll update
tags:    tech linux package-manager
---

# Linux发行版包管理器

（同步自简书账户）

简单梳理了一下包管理常用的功能，以及在不同包管理器下对应的命令。

## Pacman 包管理器
Pacman是Arch Linux 的包管理器，也是 MSYS2的包管理器，算是比较好用的管理器了。
MSYS2 Package Management Manual : [https://www.msys2.org/docs/package-management/](https://www.msys2.org/docs/package-management/)

|  操作  |  命令  |
| ---- | ---- |
| 安装包     |   `pacman -S emacs`  |
| 查找包     | `pacman -Ss emacs`  |
| 查找包（已安装的） | `pacman -Qs emacs`  |
| 删除包 | `pacman -R emacs` |
| 查看包内容 | `pacman -Ql emacs`   （列出包安装的文件列表） |
| 查看包依赖关系 | `pactree emacs` |
| 查看包信息 | `pacman -Qi emacs`   （会包含直接依赖的包信息） |
| 查看一个文件属于哪个包 | `pacman -Qo /usr/bin/ls.exe` |
| 查找包含所需文件的包 | `pacman -Fy plink-ssh.exe` |
| 通过部分包名安装包 | `pacboy -S x265:x`    （需要先安装pacboy） |


## APT 包管理器
apt包管理器用在 debain、ubuntu 系统上。

|  操作  |  命令  |
| ---- | ---- |
| 安装包 | `apt install emacs` |
| 查看包信息 | `apt show emacs` |
| 查找包 | `apt search --names-only emacs` 建议带上name only，否则匹配的太多 |
| 查找包（已安装） | `dpkg -S bin/emacs` 本地查询比较快 |
| 列出包文件列表 |  `apt-file list emacs25`, 或者 `dpkg -L emacs25` 会更快 |
| 查询哪个包包含了特定文件 | `apt-file find include/elf.h` |

* apt-file 命令需要单独安装包 apt-file


## Dnf/Yum 包管理器
dnf（以前为 yum）用在redhat centos fedora 系列系统上。

|  操作  |  命令  |
| ---- | ---- |
| 安装包 | `dnf install emacs` |
| 查找包 | `dnf search emacs` 比apt search准确 |
| 查看包信息 | `dnf info emacs` |
| 查询提供命令的包 | `dnf provides emacs` |
| 列出包内文件列表 | `dnf repoquery -l emacs` |
| 查询提供特定文件的包 | `dnf whatprovides *include/elf.h` 或者 `rpm -qf /usr/include/elf.h`  |

