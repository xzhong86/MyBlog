---
title:  "GitHub API 入门"
layout:  post
date:    2022-10-22 12:59:32 +0800
categories: jekyll update
---

# GitHub API 入门

我在找一种方法能够方便备份我在github上面的代码库，以防哪天彻底不能访问了，代码不至于找不到。

发现一个博文提到了github api，（链接 https://addyosmani.com/blog/backing-up-a-github-account/），但是文中提到的方法已经不能用了。

于是又找到一个博文：https://fusebit.io/blog/github-api-list-repositories/， 里面提到的方法感觉更有效。

这里说到的方法都是不采用爬虫，也不需要登录的方法，github提供这些api确实很便捷。

## 简单使用说明

访问 https://api.github.com/users/USERNAME 就能得到一个json文件，表明各种访问的url入口。

如执行命令：`curl https://api.github.com/users/schacon`，可以得到
```json
{
  "login": "schacon",
  "url": "https://api.github.com/users/schacon",
  "gists_url": "https://api.github.com/users/schacon/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/schacon/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/schacon/subscriptions",
  "organizations_url": "https://api.github.com/users/schacon/orgs",
  "repos_url": "https://api.github.com/users/schacon/repos",
}
```
这里保留了几个关键的信息，其他的没贴上来。 其中 repos_url 就是获取所有库的地方了，也是json格式，很方便。

另外 starred_url 也很有用，可以把自己标星的库都列出来，这下可以把自己关注的代码库也一起拉下来了。

后面就基于这个写脚本就行了，用来备份自己的代码，也给标星的代码都做一份镜像。

## 其他

利用这套API可以做不少工具了，可惜这套API的官方说明我没有找到，有谁知道的话愿不吝赐教。
