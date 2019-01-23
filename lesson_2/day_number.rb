puts "Enter day: "
day = gets.chomp.to_i

puts "Enter month: "
month = gets.chomp.to_i

puts "Enter year: "
year = gets.chomp.to_i

is_leap_year = year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)
days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
days_in_month[1] = 29 if is_leap_year

if month < 1 || month > 12
  puts "Such a month does not exist"
elsif day < 1 || day > days_in_month[month-1]
  puts "There is no such a day in the month"
elsif year < 0
  puts "Invalid year provided"
else
  days_passed = days_in_month.first(month-1).reduce(0) { |sum, x| sum + x }
  days_passed += day

  puts "It is #{days_passed}th day of the #{year} year"
end

