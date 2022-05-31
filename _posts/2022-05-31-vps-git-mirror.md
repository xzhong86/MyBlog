---
title:  "VPS 配置git镜像"
layout:  post
date:    2022-05-31 10:55:34 -0400
categories: jekyll update
---

# VPS 配置git镜像

在 ten 服务器上创建 github的镜像库，然后我基于ten上面的库在本地工作，一方面减少直接依赖github的情况，一方面对于blog、gitbook可以在ten服务器上自动生成网页。

## 关于git的简单试验

```text
init base git code in init/
create bare repo:     git clone --bare $PWD/init source
create mirror repo:   git clone --mirror $PWD/source mirror
create working repo:  git clone $PWD/mirror working
add hook in mirror:   echo "git push --mirror" >> mirror/hooks/post-receive
```
以上几步简单试验了一下构建镜像库的过程，通过hook脚本可以自动push到上游。

> post-receive 执行失败也不会影响下游的push操作

## 在VPS上部署

于是我在VPS上面部署了我的github库的镜像，在push到vps上时自动push到github，blog/book的钩子还会构建更新网页。大部分相关脚本放进了MyTools。
