#!/bin/bash

# 引数の数が2つでなければエラー
if [ "$#" -ne 2 ]; then
  echo "Error: Please provide exactly two natural numbers." >&2
  exit 1
fi

a="$1"
b="$2"

# 自然数かチェック
# ここでは自然数を 1, 2, 3, ... とし、0は不可とする
if ! [[ "$a" =~ ^[1-9][0-9]*$ ]] || ! [[ "$b" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: Arguments must be natural numbers." >&2
  exit 1
fi

# Bashの整数演算で扱いやすい範囲に制限
# 極端に大きい数はエラー扱いにする
if [ "${#a}" -gt 18 ] || [ "${#b}" -gt 18 ]; then
  echo "Error: Arguments are too large." >&2
  exit 1
fi

# ユークリッドの互除法で最大公約数を計算
while [ "$b" -ne 0 ]; do
  r=$((a % b))
  a="$b"
  b="$r"
done

echo "$a"
exit 0