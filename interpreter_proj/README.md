# 一个简单的 Interpreter 项目

本项目是作者复习 PLC 时写的代码，基于助教学长 [此处](https://github.com/AugustineYang/OCaml-Interpreter) 的 `SimPL` 分支进行的修改和完善。如有错误望指正。

## Sandbox 

earlybird 1.3.3 ; ocaml-lsp-server 1.22.0

## 如何运行

先执行 `dune build` 后执行:

- `dune exec bin/main.exe`

- `dune exec interpreter_proj`

中的任意一条即可。

默认读取 `test/test_stmt.in` 中的内容并尝试解析，并与 `test/standard.out` 的内容进行比对

想使用 `earlybird` 的调试功能，可参考 [此处](https://github.com/hackwaly/ocamlearlybird)

本项目使用的是 Ocaml 标准的编译选项，将一些警告（如 `unused-value-declaration`）会视为错误并导致项目无法运行。

如果觉得不适应可以取消 `bin/dune` 第 6 行关于 `flags` 设置的注释。

## 文法


```BNF
<program> ::= <stmts> EOF

<stmts> ::= <stmt_list>

<stmt_list> ::= <expr> SEMICOLON <stmt_list>
              | <expr>

<expr> ::= INT
         | ID
         | TRUE
         | FALSE
         | <expr> TIMES <expr>
         | <expr> DIV <expr>
         | <expr> PLUS <expr>
         | <expr> MINUS <expr>
         | <expr> LEQ <expr>
         | <expr> GREATER <expr>
         | <expr> LESS <expr>
         | <expr> EQUAL <expr>
         | <expr> NOTEQUAL <expr>
         | <expr> LAND <expr>
         | <expr> LOR <expr>
         | NOT <expr>
         | MINUS <expr>
         | IF <expr> THEN <expr> ELSE <expr>
         | LET ID EQUALS <expr> IN <expr>
         | LPAREN <expr> RPAREN
```

值得注意的是，上述文法的最后一个 expr 不能跟随分号 ";"。

## 内容概述

对上述的文法进行解析（parse）后做类型检查（typecheck），并最终进行逐语句（expression）求取表达式的值（interpret）

你可以通过 "_build/default/lib/" 下生成的 `parser.output` 文件，去分析在哪个状态发生了冲突，又该如何通过修改优先级/结合性的方式，或者通过修改为无二义性文法的方式进行解决。

## Lexer 和 Parser 使用

参考 [这里](https://ocaml.org/manual/5.3/lexyacc.html) 的讲解和使用例子

## 如何自学？

可以参考 [这里](https://cs3110.github.io/textbook/chapters/interp/intro.html) 关于 `Interpreter` 整个章节的讲述