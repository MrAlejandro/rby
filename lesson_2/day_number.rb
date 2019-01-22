puts "Enter day: "
day = gets.chomp.to_i

puts "Enter month: "
month = gets.chomp.to_i

puts "Enter year: "
year = gets.chomp.to_i

is_leap_year = year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)
days_in_month = {
    1 => 31, 2 => is_leap_year ? 29 : 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30,
    7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31
}

if month < 1 || month > 12
  puts "Such a month does not exist"
elsif day < 1 || day > days_in_month[month]
  puts "There is no such a day in the month"
elsif year < 0
  puts "Invalid year provided"
else
  m = 1
  days_passed = 0
  while m < month do
    days_passed += days_in_month[m]
    m += 1
  end
  days_passed += day

  puts "It is #{days_passed}th day of the #{year} year"
end

