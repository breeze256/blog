---
date: '2025-02-25T04:44:28Z'
title: '常见数列的一些技巧'
tags: [Math, Notes]
---

一个比较零散的笔记，会把一些比较难想到的数列的技巧记录过来（嘿嘿）。

内容比较零散，不系统，是给自己看的 qwq。

<!--more-->

## $a_{n+1} = \frac{p}{\lambda a_n + q}$ 型

1. 等式两边同时加上一个常数 $x$，对右侧进行通分，
    $$
    a_{n+1} = \frac{p}{\lambda a_n + q} \Rightarrow a_{n+1}+x = \frac{\lambda x\left(a_n+\frac{mx+n}{\lambda x}\right)}{\lambda a_n + q}
    $$
2. 对比 $a_{n+1}+x$ 与 $a_n+\frac{mx+n}{\lambda x}$，解出 $x$，
    $$
    x = \frac{mx+n}{\lambda x} \Rightarrow x_1, x_2 = ?
    $$
3. 将其中一个解 $\mu$ 代回递推公式，左右同时取倒数，有，
    $$
    a_{n+1}+\mu = \frac{\lambda x\left(a_n+\mu\right)}{\lambda a_n + q} \Rightarrow \frac{1}{a_{n+1}+\mu} = \frac{1}{\lambda x} \frac{q}{a_n+\mu} + C_0
    $$
4. 按照解 $a_{n+1} = \lambda a_n + p$ 的方法解出即可。

例题：

有数列 $\{a_n\}$，满足 $a_{n+1} = \dfrac{2}{a_n+1}, a_1 = 2, a_n = ?$

左右两边同时加上 $x$，有：

$$
a_{n+1}+x = \frac{x\left(a_n+1+(2/x)\right)}{a_n+1} \Rightarrow \frac{1}{a_{n+1}+2} = -\frac{1}{2}\frac{1}{a_n+2} + \frac{1}{2}
$$

解出：
$$
\frac{1}{a_n+2} = \frac{1}{6}\left(-\frac{1}{2}\right)^n+\frac{1}{3}, a_n = \frac{6}{\left(-\frac{1}{2}\right)^n+2}-2.
$$
