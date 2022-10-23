# TMUX速查&教程

方便我自己查阅的用法说明、记录。 不知道tmux是啥的去搜一下吧。

## 基本概念

tmux里面有Session（会话）、Window（窗口）、pane（窗格）的几个概念。

Session可以包含多个Window，像tab一样切换。一个窗口可以有多个pane，pane由窗口切分后产生。

Session可以在tmux detach后继续存在。 这使得在ssh端口之后，依然可以重连回到之前的工作状态。
也可用作后台执行任务，随时可以重连查看状态。

## 用户配置文件

用户配置文件为：`~/.tmux.conf`， 以下为我的配置文件。

```conf
# ~/.tmux.conf file
# change command prefix
set -g prefix C-x
unbind C-b
bind C-x send-prefix

# set start window number
set -g base-index 1
set -g pane-base-index 1
```
我修改了默认前缀快捷键，以及窗口编号，方便切换。


## 常用快捷键

正如上面的配置，我的 pfx 是 Ctrl+x 键。

|  快捷键  |  说明  |
| ----    | ----   |
| Ctrl+d     |  会结束当前shell，导致关闭pane、window、或者Session，注意 |
| pfx pfx    |  向shell发出pfx组合键 |
| pfx ?      |  显示帮助信息， q 或者 ESC 退出 |
| pfx :      |  输入命令，也就是tmux的子命令 |
| pfx [      |  进入copy-mode，q 退出 |
| ---        | Session 相关快捷键 |
| pfx d      |  等同 tmux detach，脱离当前Session |
| pfx s      |  列出session，可以查看、切换，q退出 |
| ---        | Window 相关快捷键 |
| pfx c      |  创建window  |
| pfx [0-9]  |  切换window，按照编号  |
| pfx p/n    |  切换到前一个、下一个window |
| ---        | Pane 相关快捷键 |
| pfx -      |  加上下左右切换Pane |
| pfx x      |  关闭当前Pane |
| pfx z      |  当前Pane全屏显示，再按一次还原 |
| pfx q      |  显示Pane编号 |


## 常用命令

命令都是tmux的子命令，用法： tmux Command Options。 命令在可以做唯一区分的时候可以简写，如 det 代表 detach。
命令也可以通过 `pfx :` 快捷键执行。

|  命令  |  说明  |
|  ----  |  ----  |
| new -s NAME   |  指定名字 创建session  |
| list-session  |  或者 ls， 列出所有session |
| detach        |  脱离当前session |
| atach -t NAME |  连接指定的session，名字或者编号 |
| kill-session -t NAME | 结束整个session，慎用 |
| switch -t NAME | 切换到指定的session |
| rename-session -t OLD NEW | 重命名session |
| new-window   | 创建window，-n NAME 可以指定名字 |
| split-window | 水平分割窗口，加 -h 参数为垂直分割 |
| select-pane -[UDLR] |  切换pane，参数为 上下左右 |
| swap-pane -U/D |  向上、下交换pane |
| list-keys      |  显示所有快捷键，配合grep方便查找 |
| list-commands  |  显示所有命令 |
| info           |  显示终端信息 |
| source-file    |  加载tmux配置文件  |


## 参考页

[阮一峰的Tmux使用教程](https://www.ruanyifeng.com/blog/2019/10/tmux.html)，入门级。
[ryerh：Tmux快捷键&速查表&简明教程](https://gist.github.com/ryerh/14b7c24dfd623ef8edc7)，进阶，还提到了插件使用。
[readTheDocs: tmux手册](https://tmuxguide.readthedocs.io/en/latest/tmux/tmux.html)，高级。
[github tmux wiki](https://github.com/tmux/tmux/wiki)， 源头，最全。
