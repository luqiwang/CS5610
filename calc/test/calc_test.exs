defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "trime_line" do
    assert Calc.trim_line("1 - (12 + 2)") == ["1", "-", "(", "12", "+", "2", ")"]
  end

  test "divide_op" do
    assert Calc.divide_op("-(") == ["-","("]
  end

  test "operate_stacks" do
    nums = [1, 3, 2]
    ops = ["+", "(", "-"]
    assert Calc.operate_stacks(nums, ops) == {[1, 1], ["+", "("]}
  end

  test "deal_bracket" do
    nums = [1, 3, 2]
    ops = ["+", "(", "-"]
    assert Calc.deal_bracket(nums, ops) == {[1, 1], ["+"]}
  end

  test "deal_operator" do
    nums = [2, 3]
    ops = ["*"]
    head = "+"
    assert Calc.deal_operator(nums, ops, head) == {[6],["+"]}
  end

  test "count test1" do
    list1 = ["3", "+", "2", "*", "2"]
    assert Calc.count(list1, [], []) == 7
  end

  test "count test2" do
    list2 = ["3", "+", "5", "/", "2"]
    assert Calc.count(list2, [], []) == 5
  end

  test "eval1" do
    assert Calc.eval("3  +2 *   2") == 7
  end

  test "eval2" do
    assert Calc.eval("5 - (4 * 3) / (5 - 1)") == 2
  end

  test "eval3" do
    assert Calc.eval("5 - (-4 * 3) / (5 - 1)") == 8
  end

  test "is_number?" do
    assert Calc.is_number?("-5") == true
  end

end
