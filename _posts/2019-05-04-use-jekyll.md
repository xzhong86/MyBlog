---
layout: post
title: "部署Jekyll和GitHub Pages"
date:  2019-05-04 11:22:46 +0800
categories: jekyll update
---

# 为什么会想到使用Jekyll？
主要还是因为WorkPress的工作机制太复杂了，维护起来也不方便。如：
 - 需要配置Apache和MySQL
 - 文章的编写查看基本离不开WordPress，server出问题就得查看server

加上开始使用GitHub Pages，就考虑做一个GH Pages 和 独立博客 都能用的博客环境。
 - Jekyll部署为独立博客时很简单，既可以用Jekyll的server，也可以简单的放到Apache里面。
 - Jekyll对端口和URL没什么要求，可以通过各种代理、穿透来访问。
 - 像简书一类的blog网站以及一些APP也提供了对MarkDown的支持。

部署方式和文档统一使用github管理，加上代码也是github，十分统一协调。

# 安装部署Jekyll
 - gem install bundler jekyll， 很简单
