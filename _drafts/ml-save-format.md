# 机器学习、大模型参数保存格式

关于 pt/pth/safetensor/chkpt 格式的说明。

> 主要参考： https://blog.csdn.net/qq_35899016/article/details/149666496

| 后缀        | 格式           | 说明                   |
|-------------|----------------|------------------------|
| .pt/.pth    | PyTorch格式    | 早期使用，不安全       |
| .safetensor | SafeTensor格式 | 目前主流，安全高效     |
| .chkpt      | CheckPoint格式 | 用于保存、恢复训练过程 |

## PyTorch保存格式

调用`torch.save()` 保存产生，`torch.load()`加载， 底层使用了Python的pickle模块，
加载过程中，如果有人混入了代码在文件中，也会被执行，所以不安全。

## safetensor格式

Hugging Face后来推出了 safetensors格式， 仅保存数据（模型参数等）， 并且使用文件映射到内存，
所以十分高效。

一个.safetensors文件, 包含8Byte文件头大小信息，一个JSON的头描述数据信息，以及大量参数构成的数据块。
JSON文件头是字符串，内包含各层的数据类型，大小，偏移量。

## chkpt格式

“.chkpt/.checkpoint” ，“检查点”， 保存了训练过程中的参数和各种状态信息，保存后可以加载恢复训练过程。

## 参考

- [AI模型的“存档”艺术：揭秘.pt, .ckpt, .safetensors](https://blog.csdn.net/qq_35899016/article/details/149666496)
- [Safetensors：保存模型权重的新格式](https://zhuanlan.zhihu.com/p/691446249)
