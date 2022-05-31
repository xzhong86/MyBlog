# Docker 用法简述

早就听闻docker大名，但是一直没有好好用过。 这里大概说一下怎么用，按照我自己的思路。
这次会用到docker还是因为gitbook jekyll的安装都不是省油的灯。

## 入门参考

我是看到这个 https://github.com/Fellah/gitbook 代码，再看看使用的命令，一下明白docker怎么使用的了。

命令：`docker run -v /yourpath:/srv/gitbook -v /yourpath/html:/srv/html fellah/gitbook gitbook build . /srv/html`

Dockerfile里面声明了两个卷（volume）：`VOLUME /srv/gitbook /srv/html`，就是可以在docker命令上通过-v参数用host目录覆盖（挂载，或者说映射）内部卷。而内部卷就是工作目录 和输出目录。
-v参数冒号前面时host目录，后面是docker内部目录（卷）。

Dockerfile 另外就是关于端口的声明了，`EXPOSE 4000 35729`, 目测前面是原本使用的端口，后面是映射的host环境端口，docker -p 参数可以覆盖这个映射。
-p 参数中 冒号前面是host环境端口，后面内部程序使用的端口。

命令：`docker run -p 80:4000 -v /srv/gitbook fellah/gitbook`， 不带执行命令就用Dockerfile里面的CMD指定的命令。

直接用以上命令启动docker里面的服务后，进程没法终止，Ctrl-c不起作用，可以带上参数 -i -t 启动，就能中断了。

### 其他还没试过的命令

 * 列出运行中的docker和相关信息：`docker ps`
 * `docker run -d ...` -d 参数能使容器再后台运行，后台运行的容器通过 `docker ps` 查看，`docker attach ID` 可以连接上去。
 * `docker run --name NAME ...` 可以给一个容器实例命名。

### 其他问题

 * 如果-v没有指定host目录会怎样？文档说会创建一个卷，不太明白。

## 参考网页
 * Docker容器使用： https://www.runoob.com/docker/docker-container-usage.html

