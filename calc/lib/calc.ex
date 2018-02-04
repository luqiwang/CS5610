defmodule Calc do

  # the main function is based on Professor Nat's notes:
  # http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/07-elixir/rw.exs
  def main() do
    case IO.gets("input: ") do
      :eof ->
        IO.puts "All done"
      {:error, reason} ->
        IO.puts "Error: #{reason}"
      line ->
        IO.puts(eval(line))
        main()
    end
  end

#eval function can handle negative operand.
  def eval(line) do
    if String.contains?(line, ".") do
      "Input should not contain point"
    else
      list = trim_line(line)
      cond do
        List.first(list) == "-" -> count(list, [0], [])
        true -> count(list, [], [])
      end
    end
  end

  def trim_line(line) do
    line
    |> String.codepoints()
    |> Enum.filter(&(&1 != " "))
    |> Enum.chunk_by(&(&1 >= "0"))
    |> Enum.map(&(List.to_string(&1)))
    |> Enum.map(&(divide_op(&1)))
    |> List.flatten()
  end

  def divide_op(x) do
    cond do
      String.length(x) > 1 && x <= "0" -> String.codepoints(x)
      true -> x
    end
  end

  def is_number?(x) do
    cond do
      String.first(x) == "-" && String.length(x) > 1 -> true
      x >= "0" -> true
      true -> false
    end
  end

  def count(list, nums, ops) do
    cond do
      length(list) > 0 ->
        [head | list] = list
        cond do
          is_number?(head) ->
            {num, frac} = Integer.parse(head)
            nums = nums ++ [num]
          head == "(" ->
            if List.first(list) == "-" do
              list = List.delete_at(list, 0)
              list = List.update_at(list, 0, &("-"<>&1))
            end
            ops = ops ++ [head]
          head == ")" -> {nums, ops} = deal_bracket(nums, ops)
          head == "+" || head == "-" || head == "*" || head == "/" ->
            {nums, ops} = deal_operator(nums, ops, head)
          true ->
        end
        count(list, nums, ops)
      length(list) == 0 && length(ops) > 0 ->
        {nums, ops} = operate_stacks(nums, ops)
        count(list, nums, ops)
      length(list) == 0 && length(ops) == 0 -> List.first(nums)
    end
  end

  def operate_stacks(nums, ops) do
    {num1, nums} = List.pop_at(nums, -1)
    {num2, nums} = List.pop_at(nums, -1)
    {op, ops} = List.pop_at(ops, -1)
    nums = nums ++ [operate(op, num1, num2)]
    {nums, ops}
  end

  def deal_bracket(nums, ops) do
    cond do
      List.last(ops) != "(" ->
        {nums, ops} = operate_stacks(nums, ops)
        deal_bracket(nums, ops)
      true ->
        {op, ops} = List.pop_at(ops, -1)
        {nums, ops}
    end
  end

  def deal_operator(nums, ops, head) do
    cond do
      length(ops) > 0 && prior?(head, List.last(ops)) ->
        {nums, ops} = operate_stacks(nums, ops)
        deal_operator(nums, ops, head)
      true ->
         ops = ops ++ [head]
         {nums, ops}
    end
  end

  def operate(op, num2, num1) do
    cond do
      op == "+" -> num1 + num2
      op == "-" -> num1 - num2
      op == "*" -> num1 * num2
      op == "/" -> Integer.floor_div(num1, num2)
      true ->
    end
  end

  def prior?(head, top) do
    cond do
      top == "(" -> false
      (top == "+" || top == "-") && (head == "*" || head == "/") -> false
      true -> true
    end
  end
end
