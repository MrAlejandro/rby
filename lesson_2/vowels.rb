vowels = ["a", "e", "i", "o", "u", "y"]

vowel_letters = {}

("a".."z").each_with_index do |letter, index|
  vowel_letters[letter] = index + 1 if vowels.include?(letter)
end

puts vowel_letters

