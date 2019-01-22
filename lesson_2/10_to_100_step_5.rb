numbers = []
(10..100).each { |num| numbers.push(num) if num % 5 == 0 }
puts numbers
