# SuperStack构想

tags: super stack, uArch方案

## 目标：
加速对栈地址的访问，从L1的 4-cycle 加速到 2-cycle 甚至 1-cycle。

## 实现方式：
  关键点：避免TLB查询，避免查tag，没有非对齐处理。
 * SuperStack 由 N cacheline 的 ram 组成，比如 32 个 cacheline。 
 * 有一个stack_base 指针指向 32个line的中间（或者偏向高地址一侧），另外有一个 stack_offset 指向表示当前SP偏移量。
 * 所有基于SP的load、store 被转换成 基于 stack_base 访问。
   * 如 load x0, [sp, #16] 转换为 load x0, [stack_base, #stack_offset+16]
   * 这样转换后， 立即数部分（或者说offset）就是 stack ram 的地址索引。
 * SP指针变动更新
   * 增减 SP 时，更新stack_offset即可。
   * 当对 SP 的增减 超过一定阈值时， 更新 stack_base 和 重置 stack_offset。
   * 更新 stack_base 之后， 将远离的cache line写会到L2， 同时fetch 一个cacheline 进来。
   * 如果fetch 的 cacheline 在一个新的page里面， 这个时候走TLB 获取 物理地址。
   * 写回到L2 cacheline 需要携带物理地址。
 * 访问 stack ram
   * stack ram 里面不需要物理地址， 对ram的读写 使用 offset 索引即可完成。
   * 地址bit如何使用取决于ram 怎么组织。
   * 对于store操作，只要页表没有问题，不需要等到cacheline回填就能写入（如此可以store-load bypass）。

所以：Super Stack 就像一个移动的window，当window移动的时候，会写回一个cacheline，同时读取一个cacheline。而对window内的数据进行访问的时候，就像简单的数组索引。因为window内的访问不需要地址转换，甚至都不需要物理地址，也不存在hit miss检查 所以会很快（不过也是会miss的）。
