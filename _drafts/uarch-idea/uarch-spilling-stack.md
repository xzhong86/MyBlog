# SpillingStack构想

## 概述
    通过实现独立的 SpillingStack， 可以提供更多的寄存器使用，加速入栈出栈，也能避免很多访存竞争以提升性能。

## SpillingStack说明
背景：<br>
    SpillingStack 全称是 GPR Spilling Stack，用独立的栈 保存寄存器spilling时的值。

    目前的程序的栈，实质上混合了两种数据：临时分配的内存 和 Spilling寄存器的值， 这即导致了性能问题，也导致了安全问题。

    性能问题：函数内的寄存器入栈和出栈是常见的引发内存竞争的原因（同地址store/load），函数自身的入栈出栈会导致内存竞争，函数调用的子函数之间也存在竞争。

    安全问题：对临时内存的写溢出会破坏栈上保存的返回寄存器的值。

## 方案说明：
    将寄存器spilling操作放到独立的 SpillingStack上进行，可以进行性能优化，顺便避免此类安全问题。

    SpillingStack 只能通过 sspush sspop 指令来读写（根据实现方案不同，一条指令可以读、写8-32个寄存器）。
    硬件实现 sspush 指令时，可以简单的做寄存器rename就可以了； spilling out （sspush）的寄存器达到一定数量时将寄存器写到 spilling buffer； spilling buffer 在合适的时机写入memory（L1D）。

    硬件实现 sspop 指令时，只进行寄存器rename即可；SpillingStackUnit 需要准备好对应的物理寄存器以便rename，如果没准备好会 sspop 指令会分配对应物理寄存器，并送到SpillingStackUnit 去执行，等待数据准备好。 
    sspop 会触发 SpillingBuffer 的窗口移动，以预先读取要用的数据，并分配物理寄存器，等待之后的sspop指令在rename阶段使用。
    sspush sspop 指令只进行寄存器rename，故效率很高；（在一开始需要warmup，效率会低一些）。同时硬件上实现越多的物理寄存器越好了（一般O3 CPU受限于rob深度，每条指令写寄存器的数量等因素，物理寄存器不是越多越好）。

    通过普通load/store 读写 SpillingStack 指向的memory，其结果和影响是未定义的。

    特权态寄存器 SSP_EL0 为SpillingStack 指针，特权指令 ssflush 可以将 spilling out的寄存器都写入内存。

## 编译器优化
    将函数的push/pop 操作换成 sspush sspop 操作，完成最简单优化。

    借助 SpillingStack 强大的性能，编译器可以将更多 caller save temporary寄存器当做 callee save 寄存器来使用，只需在调用子函数前后加上 sspush sspop 即可， 相当于函数内有更多稳定寄存器可以使用。

## DBI、DBT优化
    能够快速的对大量寄存器进行 push pop 操作， 对DBI性能就有很大帮助。

    快速高效的独立的 push pop 操作，对于 DBT而言， 相当于增加了可用的临时寄存器（与编译器的情况相同）（sspush sspop 本身通过rename实现，其实就是增加了可用寄存器数量）。 DBT的 return stack 可以在 SpillingStack上实现，带来一定程度的加速。

## 对比其他方案
    对比 SuperStack， SuperStack 设想是将整个普通栈都变成这种 高速栈操作，但是硬件实现难度大，同时临时数据分配也在栈上，导致寄存器 spilling 的密度低，spilling 换入换出开销大。 另一面，SpillingStack方案 栈上的临时数据就不会得到加速了。

    对比 VISC 的 SP-vreg ， 对架构的改动小，ARM架构增加 两条用户态指令，一条特权态指令，一个系统寄存器 即可。

## 简单例子
    使用 sspush sspop提升出入栈速度。 利用高速的SpillingStack函数内可以使用 x9-x15 等临时寄存器就像 callee-saved 的寄存器一样。也就是函数内有了更多的寄存器可以使用。
```asm
func example_a:
    sspush x19, x20, x21, x22, x30  // instead of standard push
    ...
    sspush x9, x10, x11, x12  // push temporary registers
    call sub_func
    sspop  x9, x10, x11, x12  // pop temporary registers
    ...
    sspop  x19, x20, x21, x22, x30  // instead of standard pop
    ret
```
