# 题目描述

将一个以某个进制表示的数字（由一串数字序列表示），转换为另一个进制下表示相同数值的数字序列。

你需要实现以下函数：

`let convert_base (from:int) (digit:int list) (target:int) : int list option` 

如果参数合法，返回一个整数列表 `int list`，表示将原始数字转换为目标进制后的数字序列（不含前导零，除非数值为 0）；

如果任一参数不合法（如进制小于 2，或 `digits` 中存在非法数字，或 `digits` 为空），返回 `None`。

示例输出：

`# convert_base 2 [1;1;1;1] 10;;`

- `: int list option = Some [1; 5]`

`# convert_base 1 [1;1;1;1] 10;;`

- `: int list option = None`