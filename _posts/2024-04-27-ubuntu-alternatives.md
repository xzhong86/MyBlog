---
title:  "Ubuntu Alternatives 管理机制"
layout:  post
date:    2024-04-27
categories: jekyll update
---


# Ubuntu Alternatives 管理机制

'update-alternatives' 命令是Debian系统包管理器dpkg的一个命令，可以用来解决系统中工具多个版本的问题。

原理上，alternatives会创建'/usr/bin/'下的软连接，指向 '/etc/alternatives/' 目录下对应的命令， 而该目录下也是链接，指向最终的命令。

例如，通过alternatives修改editor为vim之后，软连接就是这样：
```sh
zpz@nuc6i3:~$ ls -l /usr/bin/editor
lrwxrwxrwx 1 root root 24  4月  6 12:32 /usr/bin/editor -> /etc/alternatives/editor
zpz@nuc6i3:~$ ls -l /etc/alternatives/editor
lrwxrwxrwx 1 root root 18  4月  9 22:47 /etc/alternatives/editor -> /usr/bin/vim.basic
```

通过命令 `update-alternatives --config editor` 就能修改：
```sh
zpz@nuc6i3:~$ update-alternatives --config editor
There are 4 choices for the alternative editor (providing /usr/bin/editor).

  Selection    Path                Priority   Status
------------------------------------------------------------
  0            /bin/nano            40        auto mode
  1            /bin/ed             -100       manual mode
  2            /bin/nano            40        manual mode
* 3            /usr/bin/vim.basic   30        manual mode
  4            /usr/bin/vim.tiny    15        manual mode

Press <enter> to keep the current choice[*], or type selection number:
```

通过命令 `update-alternatives --list editor` 可以快速列出备选项（对比config而言）。

通过命令 `update-alternatives --install ...` 可以安装备选项，以gcc为例：
```sh
$ sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 10
$ sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 20
```
‘--install’ 参数中：
   - 第一个为 目标链接路径，用户界面路径
   - 第二个为 类别名字，该备选项名字
   - 第三个为 真实路径
   - 第四个为 优先级，越大优先级越高

安装之后就可以通过 '--config' 来进行配置。


## Refer

- [update-alternatives Linux中的默认程序修改器](https://www.thisfaner.com/p/linux-update-alternatives-usage/)
- [linux版本管理工具update-alternatives](https://blog.csdn.net/seaship/article/details/115693727)
- [ubuntu 20.04如何切换gcc/g++/python的版本](https://blog.csdn.net/u014100559/article/details/134564436)
- Linux Manual: `man update-alternatives`
