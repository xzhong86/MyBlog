---
title:  "构建uArch硬件平台"
layout:  post
date:    2022-10-28 20:35:48 +0800
categories: jekyll update
tags: geek uarch
---


# 构建uArch硬件平台

收集主要的ARM uArch产品，用作微架构测试

一些有用的链接：
 - https://en.wikipedia.org/wiki/ARM_architecture_family， 整体介绍ARM处理器
 - https://en.wikipedia.org/wiki/Comparison_of_Armv8-A_processors， 列出了V8-A core的主要微架构特性。
 - https://en.wikipedia.org/wiki/List_of_products_using_ARM_processors， 如其名，不过罗列信息不太好查看。
 - https://en.wikipedia.org/wiki/List_of_ARM_processors， 列出了包括三方的ARM处理器和简单微架构信息。底部有微架构和soc对应表。


## 手上的CPU

| ARM核      | 设备  |  备选 |
| ---        | ---   | --- |
| ARM11：     | 树莓派1、zero  |
| Cortex-A7： | 树莓派2，全志T113、V3s |
| Cortex-A53：| 树莓派3，H616， |
| Cortex-A55：| 晶晨S905，  |
| Cortex-A72：| 树莓派4，   |
| Cortex-A73：| 无   | 备选：高通835；备选：小米6，一加5 |
| Cortex-A75：| 无   | 备选：高通845、850；备选：小米8 |
| Cortex-A76：| 无   | 备选：高通855、860，备选：小米9 |
| Cortex-A77：| 黑鲨4-高通870。 | 备选：高通865、870，天玑1000； |
| Cortex-A78：| 红米note10-天玑1100。 | 备选：高通888，天玑1100、1200， |
| Cortex-X1： | 无   | 备选：高通888， |
| Cortex-X2： | 无   | 备选：高通8G1，天玑9000， |


## 小米手机列表

| 小米  | 年份   | CPU      | uArch |
| ---   | ---   | ---       | --- |
| 4代	| 2014	| 高通801	| 4x Krait 400
| 4S	| 2015	| 高通808	| 2x A57， 4x A53
| 5代	| 2016	| 高通820	| 4x Kyro
| 6代	| 2017	| 高通835	| 4x A73， 4x A53
| 8代	| 2018	| 高通845	| 4x A75， 4x A55
| 9代	| 2019	| 高通855	| 1+3x A76， 4x A55
| 10代	| 2020	| 高通865	| 1+3x A77， 4x A55
| 11代	| 2021	| 高通888	| X1， 3x A78， 4x A55
| 12代	| 2021	| 高通8Gen1	| X2， 3x A710， 4x A510

