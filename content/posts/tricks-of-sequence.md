---
date: '2025-02-25T04:44:28Z'
title: '常见数列的一些技巧'
tags: [Math, Notes]
---

一个比较零散的笔记，会把一些比较难想到的数列的技巧记录过来（嘿嘿）。

内容比较零散，不系统，是给自己看的 qwq。

<!--more-->

<!--
## $a_{n+1} = pa_n+q$ 型

1. 令 $a_{n+1} = a_n = x$，得到 $x = px+q$，
    $$
    a_{n+1} = pa_n+q \Rightarrow x = px+q
    $$
2. 解出这个方程，并在原递推公式两边同时减去 $x$，构造出等比数列 $\{a_n-x\}$，
    $$
    a_{n+1}-x = pa_n+q-x \Rightarrow a_{n+1}-x = p(a_n+\frac{q-x}{p})
    $$
3. 求出 $\{a_n-x\}$ 通项公式，即可求出 $\{a_n\}$ 通项公式。

-->

## $a_{n+1} = \frac{pa_n+q}{ra_n+s}$ 型

- **定义1**：方程 $x = f(x)$ 的解 $x$ 称为函数 $f(x)$ 的不动点。
- **定义2**：递推数列 $a_{n+1} = \frac{pa_n+q}{ra_n+s}, bc\neq0$ 对应的特征方程为 $x = \frac{px+q}{rx+s}$，该方程的解为 $f(x) = \frac{pa_n+q}{ra_n+s}$ 不动点。

1. 写出数列特征方程，并解出不动点 $x$，
    $$
    a_{n+1} = \frac{pa_n+q}{ra_n+s} \Rightarrow x = \frac{px+q}{rx+s} \Rightarrow x = \dots
    $$
2. 在原数列左右两边同时减去 $x$, 并取倒数，
    $$
    a_{n+1}-x = \frac{pa_n+q}{ra_n+s}-x \Rightarrow \frac{1}{a_{n+1}-x} = \frac{ra_n+s}{(p-xr)\left(a_n-x\right)}
    $$
3. 列出方程组，做商并解出 $a_n$。
    $$
    \begin{cases}
        \dfrac{1}{a_{n+1}-x_1} = \dfrac{ra_n+s}{(p-x_1r)\left(a_n-x_1\right)} \\
        \dfrac{1}{a_{n+1}-x_2} = \dfrac{ra_n+s}{(p-x_2r)\left(a_n-x_2\right)}
    \end{cases},
    \Rightarrow a_n = \dots
    $$

<!--
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
-->
