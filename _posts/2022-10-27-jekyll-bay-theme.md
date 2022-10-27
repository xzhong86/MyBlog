---
title:  "切换Jekyll主题"
layout:  post
date:    2022-10-25 22:45:49 +0800
categories: jekyll update
---

# 切换Jekyll主题

花了好几个小时才搞定替换主题，有不少坑，这里记录一下处理过程。

 - 参考[bay主页](https://github.com/eliottvincent/bay)，更换主题。采用配置的方式，而不是clone bay代码（这会复杂一些）。
   - 我复制了bay主题里面的\_config.yml blog.md work.md 来完善基本文件。另外修改了 blog的layout 来过滤一部分博文。

 - 途中可能会遇到的问题，bundle install卡死，是墙导致的。需要 [配置清华镜像](https://mirrors.tuna.tsinghua.edu.cn/help/rubygems/) 使用。
   - 顺便一提，bundle install的gem包可以通过 bundle info xxx 来看到确切位置。命令需要在执行bundle install的地方执行。

 - 配置好启动可能遇到无法加载webrick的问题，这是由于ruby3.0导致的（[参考](https://www.cnblogs.com/huyuchengus/p/15473035.html)），执行`bundle add webrick`就可以了。

 - 最后在服务器上部署的使用，没有使用jekyll serve，结果work blog页面链接不上，于是在对应页面里面添加了 permalink 来解决（原本是slug，不知为何不管用了）。
   - 另外，在blog里面生成页面链接的时候，bay主题故意去掉了结尾的html，导致生成的页面没法在apache上面正确访问。服了

 - 另外，我以为需要复制bay的assets目录，后来发现没有也可以，好像会自动找到主题里面的资源文件。这也是把bay用作主题的好处吧，不用在自己的库里面存资源文件了。

