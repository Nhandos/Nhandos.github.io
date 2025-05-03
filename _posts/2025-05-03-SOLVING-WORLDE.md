---
title: 3Blue1Brown's Wordle algorithm implementation in Rust
date: 2025-05-03 16:51:00 +0800
categories: [Computer Science]
tags: [algorithms]     
author: <nhan_dao>
---

# 3Blue1Brown's Wordle algorithm implementation in Rust

## Wordle in one paragraph

Wordle is a single-player Mastermind variant played on five-letter English words.<br>
Each guess returns a five-symbol "pattern":
* 2 / 🟩 - correct letter, correct slot
* 1 / 🟨 - letter exists elsewhere
* 0 / ⬜ - letter not in the word (or fully accounted for)

You win when the pattern is 🟩🟩🟩🟩🟩 - and you have only six guesses.
A solver's job is to choose guesses that zero-in on the secret word as fast as possible.

## Formulating the problem 

| Symbol        | Reads as                            | Comment                           |
| ------------- | ----------------------------------- | --------------------------------- |
| $\mathcal{W}$ | full dictionary                     | 12 k common words, for example    |
| $W$           | hidden word                         | a random element of $\mathcal{W}$ |
| $P_W(w)$      | prior probability the answer is *w* | frequency‑weighted or uniform     |
| $G$           | your current guess                  | a word in $\mathcal{W}$           |
| $X = f(W,G)$  | feedback pattern                    | encoded $0 \dots 242$             |

The distribution of the pattern given a guess is

$P_{X\mid G}(x)=\sum_{w\in\mathcal W:\;f(w,G)=x} P_W(w)\,.$

## Maximising Entropy strategy

Shannon entropy of the pattern is

$H(X\mid G)= -\sum_x P_{X\mid G}(x)\,\log_2 P_{X\mid G}(x).$

High entropy => a more even split of $W$, so the solver pick sthe guess with the largest $H$. This works great on the first turn, but near the end it sometimes wates a move on a "clever" splitter instead of firing the most likely word.
