vowels = ["a", "e", "i", "o", "u", "y"]

index = 1
vowel_letters = {}

("a".."z").each do |letter|
  vowel_letters[letter] = index if vowels.include?(letter)
  index += 1
end

puts vowel_letters

