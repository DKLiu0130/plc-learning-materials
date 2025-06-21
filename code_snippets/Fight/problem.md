**题目描述：**

请实现一个战斗模块，用于模拟两个角色之间的生命值比较，并判断胜者。

你需要定义一个模块类型 `Person`，表示具有可变生命值的角色；然后使用 functor `Fight` 接收两个模块参数，比较两者的生命值，并输出胜者。

本题是开放题，用于加深对 **函子** 的理解。

---

### 要求：

1. 定义一个模块类型：

```ocaml
module type Person = sig
  val life : int ref
  val change_life : int -> unit
end
```

该模块类型表示一个“人物”模块，包含：

* 一个可变的 `life` 值（`int ref`）表示当前生命值；
* 一个函数 `change_life`，接收一个整数，设置生命值为该值。

2. 实现一个 functor：

```ocaml
module Fight (P1 : Person) (P2 : Person) = struct
  val winner : unit -> unit
end
```

该 functor `Fight` 接收两个实现了 `Person` 模块类型的模块，构造一个新模块，提供一个函数 `winner`：

* `winner ()` 应该比较 `P1` 和 `P2` 的生命值；
* 如果 `P1` 的生命值大于 `P2`，则输出 `"p1 wins"`，否则输出 `"p2 wins"`。

3. 编写两个模块 `A` 和 `B`，都符合 `Person` 模块类型，并初始化它们的生命值。

4. 调用 `change_life` 修改其中一个模块的生命值。

5. 使用 `Fight` 比较两者，调用 `winner` 函数输出结果。

---

### 示例输入：

```ocaml
module A : Person = struct
  let life = ref 10
  let change_life num = life := num
end

module B : Person = struct
  let life = ref 10
  let change_life num = life := num
end

B.change_life 20

module Result = Fight (A) (B)

Result.winner ()
```

### 示例输出：

```
p2 wins
```

因为 B 的生命值为 20，而 A 的生命值为 10，故 B 获胜。
