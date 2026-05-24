#!/bin/bash

SCRIPT="./gcd.sh"
FAIL=0

# 正常系テスト
test_success() {
  input1="$1"
  input2="$2"
  expected="$3"

  output=$("$SCRIPT" "$input1" "$input2" 2>/dev/null)
  status=$?

  if [ "$status" -eq 0 ] && [ "$output" = "$expected" ]; then
    echo "OK: gcd($input1, $input2) = $expected"
  else
    echo "NG: gcd($input1, $input2) expected $expected, but got '$output' with status $status"
    FAIL=1
  fi
}

# 異常系テスト
test_error() {
  description="$1"
  shift

  output=$("$SCRIPT" "$@" 2>/tmp/gcd_error.log)
  status=$?
  error_output=$(cat /tmp/gcd_error.log)

  if [ "$status" -ne 0 ] && [ -n "$error_output" ]; then
    echo "OK: $description caused error"
  else
    echo "NG: $description should cause error, but status=$status, stdout='$output', stderr='$error_output'"
    FAIL=1
  fi
}

echo "Start gcd.sh tests"

# 正常系
test_success 2 4 2
test_success 12 18 6
test_success 17 13 1
test_success 100 25 25
test_success 81 27 27
test_success 270 192 6

# 異常系
test_error "no arguments"
test_error "only one argument" 3
test_error "too many arguments" 2 4 6
test_error "first argument is a character" a 4
test_error "second argument is a character" 4 b
test_error "negative number" -2 4
test_error "decimal number" 2.5 4
test_error "zero" 0 4
test_error "very large number" 123456789012345678901 4

rm -f /tmp/gcd_error.log

if [ "$FAIL" -eq 0 ]; then
  echo "All tests passed."
  exit 0
else
  echo "Some tests failed."
  exit 1
fi