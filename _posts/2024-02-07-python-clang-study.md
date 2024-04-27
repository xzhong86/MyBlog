---
title:  "Python Clang 简单学习研究"
layout:  post
date:    2024-02-07
categories: jekyll update
tags:    tech python clang pyclang libclang
---

# Python Clang 简单学习研究

(本文先发布于简书)

Clang是LLVM项目的一个前端实现，用于编译C/C++/ObjectC代码。

Clang项目允许（支持）作为一个库（libclang）来使用，就有了许多围绕Clang库开发的工具（[ClangTools](https://clang.llvm.org/docs/Tooling.html)）。 Clang使用C++开发的，使用Clang库的话也最好使用C++；不过C++写起来麻烦，这就轮到Clang库的Python绑定出场了。

使用Python探索Clang库的用法，了解Clang的AST（抽象语法树）组织形式，和主要的节点类型等， 都是很方便的。

## 准备环境

- 系统环境使用的是Ubuntu22.04
- 安装 libclang-15-dev 包： `apt install libclang-15-dev`
- python安装对应的clang包：`pip install clang==15.0.7`，clang包主版本和clang版本一致

准备一个hello world源码：

```c++
#include <iostream>
int main(int ac, char *av[])
{
    std::cout << "hello world" << std::endl;
    for (int i = 0; i < ac; i++)
        std::cout << "arg " << i << ": " << av[i] << std::endl;
}
```

## 使用 Python Clang

参考Clang给出的两个Python用例（见参考链接），写了个方便探索的脚本：

```python
#  python3 -i interactive.py
import clang.cindex

from clang.cindex import Config
from clang.cindex import Cursor
from clang.cindex import CursorKind

Config.set_library_file("/usr/lib/llvm-15/lib/libclang-15.so")

def find_cursor(csr, kind, name):
    if csr.kind == kind and csr.spelling == name:
        return csr

    for child in csr.get_children():
        res = find_cursor(child, kind, name)
        if res:
            return res

    return None

def get_info(node, depth):
    if depth > 0:
        children = [get_info(c, depth-1) for c in node.get_children()]
    else:
        children = []
    return {
        "0-kind": node.kind,
        "1-spelling": node.spelling,
        "2-location": node.location,
        "3-children": children,
    }

def dump_r(csr, depth=3):
    from pprint import pprint
    pprint(("nodes", get_info(csr, depth)))

index = clang.cindex.Index.create()
tu = index.parse("hello.cpp")
```



执行 `python -i interactive.py` 之后进入互交模式（以上代码保存为interactive.py）。

执行以下命令可以找到文件中的main函数，并打印AST信息，限制深度为3。

```code
>>> main = find_cursor(tu.cursor, CursorKind.FUNCTION_DECL, "main")
>>> dump_r(main, 3)
```

在main函数里面找到for语句，并打印AST信息，限制深度为2。

```code
>>> st_for = find_cursor(main, CursorKind.FOR_STMT, "")
>>> dump_r(st_for, 2)
```

有着两个函数之后，我们可以很方便的找到AST中的节点， 并打印其内容。当然在python互交环境的最大优点就是能够随时查看一个对象的属性和方法，并查看其值或者调用效果，很方便进行探索。（当然也可以使用ipython或者jupyter）



## 参考链接

- [Clang源码Python绑定](https://github.com/llvm/llvm-project/tree/main/clang/bindings/python) ，还带有两个示例源码。
- [LLVM/Clang 主页](https://clang.llvm.org/docs/index.html) ，有大量有用信息，根本看不完。
- [另一个libclang包的文档，有参考意义](https://libclang.readthedocs.io/en/latest/#) ，clang包的孪生版本，自带clang库，文档包含python clang的主要对象和方法。
- [CSDN上的一个博文，聊胜于无吧](https://blog.csdn.net/lltaoyy/article/details/108791436) ，排版太差，参考太少，唯一优点是中文写的。
- [Introduction to the Clang AST](https://clang.llvm.org/docs/IntroductionToTheClangAST.html) ，带一个AST讲解视频。
- [LibClang, walking in AST](https://bastian.rieck.me/blog/posts/2015/baby_steps_libclang_ast/) ，讲了clang直接打印AST 以及写C++代码访问AST。
  - clang命令：`clang -Xclang -ast-dump -fsyntax-only hello.cpp` 
