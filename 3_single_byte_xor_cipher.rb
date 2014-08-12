str = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'

encoded_as_int = str.to_i(16)
encoded_length = str.length/2

def count_vowels(str)
  %w(a e i o u).inject(0) do |sum, vowel|
    sum += str.count(vowel)
  end
end

best = {score: 0, str: '', char: ''}

256.times do |i|
  xor_against = i.to_s(16) * encoded_length # Not sure if the char is repeated or not
  decoded = encoded_as_int ^ xor_against.to_i(16)
  decoded_string = [decoded.to_s(16)].pack('H*')

  #puts "Decoded? #{[decoded.to_s(16)].pack('H*')} with #{i.chr}"
  score = count_vowels(decoded_string)
  #puts "Score: #{score}, Char: #{i.chr}, Decoded: #{decoded_string}" if score > 8
  best = {score: score, str: decoded_string, char: i.chr} if best[:score] < score
end

puts "Best: #{best.inspect}"
#looks to be 'X' and answer is "Cooking MC's like a pound of bacon"
