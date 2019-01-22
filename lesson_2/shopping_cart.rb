cart = {}

loop do
  puts "Enter product name: "
  name = gets.chomp.strip
  break if name == "stop"

  puts "Enter product unit price: "
  price = gets.chomp.to_f

  puts "Enter product amount: "
  amount = gets.chomp.to_i

  if price > 0 && amount > 0
    if cart.has_key?(name)
      cart[name][:price] = price
      cart[name][:amount] += amount
    else
      cart[name] = {
          price: price,
          amount: amount,
      }
    end
  end
end

puts cart

order_total = 0
cart.each do |name, item|
  subtotal = item[:price] * item[:amount]
  puts "Product '#{name}' subtotal is: #{subtotal}"
  order_total += subtotal
end

puts "Order total: #{order_total.round(2)}"
