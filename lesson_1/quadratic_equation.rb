puts "Enter coefficient 'a': "
a = gets.chomp.to_f

puts "Enter coefficient 'b': "
b = gets.chomp.to_f

puts "Enter coefficient 'c': "
c = gets.chomp.to_f

discriminant = b**2 - 4 * a * c

if a == 0
  puts "This is not a quadratic equation"
elsif discriminant < 0
  puts "Discriminant = #{discriminant}. No roots"
else
  x1 = (-b + Math.sqrt(discriminant)) / (2 * a)
  x1 = x1.round(2)

  if discriminant == 0
    puts "Discriminant = #{discriminant.round(2)}. x = #{x1}"
  else
    x2 = (-b - Math.sqrt(discriminant)) / (2 * a)
    puts "Discriminant = #{discriminant.round(2)}. x1 = #{x1}, x2 = #{x2.round(2)}"
  end
end
