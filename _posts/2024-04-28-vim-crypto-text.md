---
title:  "VIM创建加密文本"
layout:  post
date:    2024-04-28
categories: jekyll update
tags:    tech editor vim
---


# VIM创建加密文本

- 使用vim 参数 '-x' 即可创建加密文件，创建时需要输入两边密码。
    `vim -x test-crypt.txt`
- 之后再用vim开启文件不需要加参数，会自动要求输入密码，打开文件。

- vim内，输入命令 `set cm?` 可以看到当前使用的加密算法，我的为 "blowfish2" 。
   - 命令 `set cm=blowfish` 可以切换加密算法（切换为"blowfish"），我就用默认的了。
   - 命令 `help 'cm'` （引号必须带上） 可以查看加密算法和说明。

