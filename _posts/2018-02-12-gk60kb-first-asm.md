---
layout: post
---
# 2018年2月组装键盘记录

二月5号，收到PLUM 电容键盘，按键过轻，需要加弹簧才好使一点。同时发现有GH60这个开源客制化键盘。在调查 淘宝一番之后，找到了项目源码以及可行的淘宝配件。有些想法想要实现，于是决定买一套开始DIY。

二月7号， 星期三，在淘宝下单购买了GH60（XD60）键盘套件。顺丰到付，周四收到后发现套件只有主板、卫星轴、70个机械轴，缺少外壳、定位板、键帽，然后再次下单。前后两次花了500左右，略贵。

二月9号，下班回家后开始组装键盘，安装轴比较费劲，之前还担心定位板会贴到电路板，但是没有，预期的牢固。花了一个多小时焊接完毕，然后发现卫星轴没装，而且装不上去了。。。  应该先看看视频的，看着电视剧组装给忘了。最后用吸锡器吧空格键拆下来，勉强把空格的卫星轴安装上了。其他的就不会来了，等下一部键盘在说吧。

二月10号，准备开始研究刷写固件。

二月11日，给ESC, Left Shift, Left GUI, Space+1, Space+2, Space+3, (Space右边的三个位置) 安装了LED。把Space 键的卫星轴重新安装了，用520粘死了。Space终于处于可用的状态。

二月12日，修正键盘映射，使用SpaceFn方案刷机成功，SpaceFn方案超乎预料的好用。

新想法：键盘使用模式概念，通过74HC165进行IO扩展，精确控制每一个灯珠，甚至每一个RGB灯光。