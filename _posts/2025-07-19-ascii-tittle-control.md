---
title:  "ASCII控制码：修改终端标题"
layout:  post
date:    2025-07-19
categories: jekyll update
---

# ASCII控制码：修改终端标题

## 起因

我在MacBook上面使用SSH连接Linux服务器之后，当前终端的标题（tittle）被修改，以至于推出SSH之后，仍然显示着Linux的用户名和主机名信息（user@host形式）。
好在我记得以前研究PS1环境变量的时候记得有些写法会影响终端标题显示，于是决定回顾一下这块的知识。

## 研究解决

简单搜索一下（如检索”shell prompt change terminal title“），就能找到一些线索。
简单说这样的代码就可以 `echo -ne "\033]0; $USER @ $HOSTNAME \a"`。

我想进一步确定它的运作原理，就进一步搜索 “ascii tty control code”， 可以看到更多的相关结果。
如 Linux手册 console_codes 里面就提到了 
`ESC ] 0 ; txt ST        Set icon name and window title`。

ESC就指代escape code， 就是上面的 `\033`， 这里的33是8进制数据，十六进制是 1B，
就是ASCII中的控制码ESC。 ESC字符之后的 ']0;' 就开启了设置符号名和标题的 控制序列，序列到 ST 字符为止。

ST意思为string terminator， 上面给的是 `\a` ， 有的例子给出的是 `\007`， 007 为BELL控制符，
`\a`是C语言中对应的转义字符。 
ST字符可能不总是007， OSC（Operating System Control）支持007做结束符， 进一步的信息没有确认。

如此，基本就理清了terminal title错误原因和解决方法了。 对于我MacBook的而言，
就是PS1环境变量配置的太简单，没有对应的配置title的序列，加上就可以了。

比如之前是：  `%n@%m %1~ %#` ，
修改为： `\033]0;%n@%m\a%n@%m %1~ %#` 即可。

ASCII控制码还有很多其他功能，比如 修改字符颜色、发出声音、移动光标等， 这些在Linux手册中描述很多。

## 参考链接

[ASCII的Wiki页面](https://en.wikipedia.org/wiki/ASCII)
[Linux用户手册关于终端控制码的说明](https://man7.org/linux/man-pages/man4/console_codes.4.html)
[StackOverflow上的一个直接例子](https://stackoverflow.com/questions/71459823/how-to-change-the-terminal-title-to-currently-running-process)

