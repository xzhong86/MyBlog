# DCCP 指令
data cache copy 指令， 将一个cache line copy一份到指定的地址。

## 指令说明：
  格式： DCCP dst-reg， src-reg， descript-reg
  dst寄存器保存目标地址，src寄存器
  可以通过执行DSB确保执行完（或者不用check执行情况，由cache本身的同地址保序机制保障）

## 优势：
  提高中小以及大范围内存复制的效率，将大量内存操作下放到到cache层级去做，降低CPU指令负载。
  CPU不需要阻塞以等待指令完成，DCCP指令只需下发即可，效率更高。
  不会因为大量读写memory而对cache形成冲击。

## 微架构实现参考：
  该指令src地址命中L1 则在L1做，同理在 L2、L3 命中 则在 L2、L3做
  请求可以拆分为 dccp-from addr， 和 dccp-to addr 两个请求， 配对使用
  cache命中后，可以将dst  tag 指向 src data 完成复制， 如果upstream的cache有dst的cache line， 则无效化上级cache line
    就是针对 dst addr 执行 snoop-invalid， make-unique，evict， 然后复制数据或者修改tag指向
    如果dst addr未命中当前cache， 也可以发送 write-unique 到下级cache。
  如果在LLC没有命中，则LLC fetch src addr对应cache line，然后执行以上流程。
