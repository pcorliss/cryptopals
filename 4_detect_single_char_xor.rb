ENGLISH_LANG_LETTER_FREQ = {
  'a' => 8.167,
  'b' => 1.492,
  'c' => 2.782,
  'd' => 4.253,
  'e' => 13.0001,
  'f' => 2.228,
  'g' => 2.015,
  'h' => 6.094,
  'i' => 6.966,
  'j' => 0.153,
  'k' => 0.772,
  'l' => 4.025,
  'm' => 2.406,
  'n' => 6.749,
  'o' => 7.507,
  'p' => 1.929,
  'q' => 0.095,
  'r' => 5.987,
  's' => 6.327,
  't' => 9.056,
  'u' => 2.758,
  'v' => 0.978,
  'w' => 2.360,
  'x' => 0.150,
  'y' => 1.974,
  'z' => 0.074,
}


file = File.read('challenge-data/4.txt')

def sum_letter_freq(str)
  str.bytes.each.inject(0) do |sum, byte|
    match = ENGLISH_LANG_LETTER_FREQ[byte.chr]
    sum += match if match
    sum
  end
end

best = {line: '', score: -1000, str: '', char: ''}

file.each_line do |line|
  str = line.chomp
  encoded_as_int = str.to_i(16)
  encoded_length = str.length/2
  256.times do |i|
    xor_against = i.to_s(16) * encoded_length # Not sure if the char is repeated or not
    decoded = encoded_as_int ^ xor_against.to_i(16)
    decoded_string = [decoded.to_s(16)].pack('H*')

    #puts "Decoded? #{[decoded.to_s(16)].pack('H*')} with #{i.chr}"
    #score = count_vowels(decoded_string) * 2 + count_alpha(decoded_string)
    score = sum_letter_freq(decoded_string)
    #puts "Score: #{score}, Char: #{i.chr}, Decoded: #{decoded_string}"
    best = {line: str, score: score, str: decoded_string, char: i.chr} if best[:score] < score
  end
end

# Best: {:line=>"7b5a4215415d544115415d5015455447414c155c46155f4058455c5b523f", :score=>133.77209999999997, :str=>"Now that the party is jumping\n", :char=>"5"}
puts "Best: #{best.inspect}"
