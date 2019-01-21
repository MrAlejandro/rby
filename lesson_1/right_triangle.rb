puts "Enter triangle side#1 length: "
a = gets.chomp.to_f

puts "Enter triangle side#2 length: "
b = gets.chomp.to_f

puts "Enter triangle side#3 length: "
c = gets.chomp.to_f

can_exist = a + b > c && b + c > a && c + a > b
if can_exist
  side1, side2, hypotenuse = [a, b, c].sort!

  squared_sides_sum = side1**2 + side2**2
  is_right = (hypotenuse**2 - squared_sides_sum).abs < 0.1

  if is_right
    puts "The triangle is right"
  else
    puts "The triangle is NOT right"
  end

  is_isosceles = side1 == side2 || side1 == hypotenuse || side2 == hypotenuse
  puts "The triangle is isosceles" if is_isosceles
  
  is_equilateral = side1 == side2 == hypotenuse
  puts "The triangle is isosceles" if is_equilateral
else
  puts "Such a triangle cannot exist"
end
