---
title:  "简单HTTP Server"
layout:  post
date:    2022-10-25 22:44:24 +0800
categories: jekyll update
---

# 简单HTTP Server

  有时候我们希望启动一个http服务，做简单的测试，但是又不希望部署apache nginx等较复杂的环境，有以下方式可以使用。

## 一行命令启动

非常简单的一个命令启动http server：
 - Python3： `python3 -m http.server` 在当前目录（当前目录为root）启动一个http server，默认端口8000，默认监听 0.0.0.0
   - 命令 `python3 -m http.server 8080` 可以指定端口
 - Ruby： `ruby -run -e httpd . -p 8000` 在当前目录（就是参数中的“.”）启动http server，指定端口8000，不指定端口的话默认8080。
 - Nodejs： nodejs的话需要安装包， `npm install -g http-server`， 然后执行  `http-server`
 - PHP: `php -S 0.0.0.0:8000`
 - busybox: `busybox httpd -f -p 8000`

  以上命令都可以启动一个http server，或者浏览对应目录的文件（如果没有index.html）。

### 简单Ruby Server

  自己写一个简单server的目的就是处理文件名的问题（好在我了解怎么用ruby写一个简单的server）：如果手搓一个html文件，想要测试效果（又不想将文件名改为index.html），那么就得在浏览器里面输入html的文件名，才能访问到（或者点击链接）。完全可以写一个脚本，输入一个文件做参数，访问根路径的时候将这个文件当做index.html输出，访问其他路径就输出其他文件的内容。

  代码清单见结尾。

## 简单File Server on http

  有时候仅仅是测试页面或者浏览、下载文件还是不够，希望能够便捷的上传文件的话，怎么办呢？

  其实可用的方案很多， 比如常用的samba server共享用户目录（但是需要打开对应的目录，路径较深一般都挺麻烦），scp、ftp、sftp需要打开对应的工具软件，选择对应的目录然后上传。scp的话需要敲路径（或是上传之后再move一下），如果路径有汉字、空格都很麻烦。而我需求就是想快速往某个目录上传几个文件而已。

  于是快速开启一个http server，并上传到执行命令的目录或者指定目录就很方便。如果命令顺便打印出来访问的url和port（就像多数nodejs应用）就更方便了，在windows terminal中只需要点击一下就会启动浏览器打开上传页面了。

 - ubuntu servefile: https://manpages.ubuntu.com/manpages/bionic/man1/servefile.1.html，有一个简单的upload页面，且只能upload一次。非常简陋，难以相信作为ubuntu包命令来安装的。
 - python3 uploadserver: https://pypi.org/project/uploadserver/ ，有一个十分简单的upload页面，可以多次上传。
 - nodejs http-server-upload：https://github.com/crycode-de/http-server-upload ， 和python的上传页面很像，但是简单测试无法使用。

  以上三个工具中，python 的 uploadserver算是最好用的了，基于这个模块做简单包装就基本可以满足我的需求（http-upload.sh）：
```bash
#!/bin/sh
ip=`hostname -I | cut -d ' ' -f 1`
port=8080
echo "upload: http://$ip:$port/upload"
python3 -m uploadserver -b $ip $port
```

  但是，测试过以上工具之后，还是不太满意，我想要一种简单的file server，基于http页面，可以浏览目录下面的文件，也能上传文件，界面稍微好看一点（python uploadserver已经非常接近了，就是界面太差）。于是决定自己做一个。

## 附件

脚本 serve-html.rb 代码清单。 使用为 `serve-html.rb test.html`，执行后根据输出的url直接访问测试效果。

```ruby
#!/usr/bin/env ruby

# simple http server to test html file
# serve-html.rb test.html

require 'webrick'
require 'stringio'

root = File.expand_path '.'
port = 8180
server = WEBrick::HTTPServer.new :Port => port, :DocumentRoot => root

trap 'INT' do server.shutdown end

default_file = ARGV.size > 0 ? ARGV[0] : "index.html"

server.mount_proc '/' do |req, res|
  if req.path == '/'
    local_path = default_file
  else
    local_path = File.join(root, req.path)
  end
  fail "#{local_path} not exist!" if not File.exist? local_path
  res.body = IO.read(local_path)
end

ip = IO.popen("hostname -I").read.split.first
puts "start server at http://#{ip}:#{port}"
puts "start without default file." if ARGV.empty?
server.start
```
