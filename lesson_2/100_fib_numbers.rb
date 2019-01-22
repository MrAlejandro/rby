fib_numbers = [0, 1]
while fib_numbers.size <= 100
  fib_numbers.push(fib_numbers[-1] + fib_numbers[-2])
end
puts fib_numbers