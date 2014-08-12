require 'base64'

file = File.read('challenge-data/6.txt')
contents = Base64.decode64(file)

ENGLISH_LANG_LETTER_FREQ = {
  # From Wikipedia
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

  # Best approximation in a quick hack
  'T' => 0.1594,
  'A' => 0.155,
  'I' => 0.0823,
  'S' => 0.0775,
  'O' => 0.0712,
  'C' => 0.0597,
  'M' => 0.0426,
  'F' => 0.0408,
  'P' => 0.040,
  'W' => 0.0382,
  ' ' => 20,
}

# I'm certain there's a more efficient way to do this
# But I'm short on time.
def hamming_distance(a, b)
  a_binary = a.unpack("b*").first
  b_binary = b.unpack("b*").first

  a_binary.each_char.zip(b_binary.each_char).inject(0) do |sum, bits|
    a_bit, b_bit = bits
    sum += 1 if a_bit != b_bit
    sum
  end
end

#a = 'this is a test'
#b = 'wokka wokka!!!'

#puts "Hamming Distance: #{hamming_distance(a, b)}"

def determine_keysize(contents)
  smallest = nil
  (2..40).each do |keysize|
    blocks = contents.chars.each_slice(keysize).take(4)

    normalized_distance = blocks.combination(2).map do |block_a, block_b|
      hamming_distance(block_a.join, block_b.join) / keysize.to_f
    end.inject(:+)

    #normalized_distance = hamming_distance(first.join, second.join) / keysize.to_f
    if smallest.nil? || smallest[:distance] > normalized_distance
      #puts "New Smallest: #{normalized_distance} #{keysize}"
      smallest = {distance: normalized_distance, keysize: keysize}
    end
  end

  smallest[:keysize]
end

def transposed_blocks(contents, keysize)
  contents.chars.each_slice(keysize).inject([]) do |sum, block|
    block.each_with_index do |char, i|
      sum[i] ||= []
      sum[i] << char
    end
    sum
  end
end

def sum_letter_freq(bytes)
  bytes.each.inject(0) do |sum, byte|
    match = ENGLISH_LANG_LETTER_FREQ[byte.chr]
    sum += match if match
    #sum -= 5 unless match
    sum
  end
end

def determine_key(chars)
  best = nil
  256.times do |i|
    decoded = chars.map do |char|
      (char.ord ^ i)
    end
    score = sum_letter_freq(decoded)
    if best.nil? or best[:score] < score
      best = {score: score, char: i.chr}
      #puts "Best: #{best.inspect} Decoded: #{decoded.map(&:chr).inspect}"
    end

  end
  #puts "Decoded: #{chars.map{|char| char.ord ^ best[:char].ord}.map(&:chr).first(10).inspect}"
  best[:char]
end

def decode(contents, key)
  contents.each_char.each_with_index.map do |char, index|
    (char.ord ^ key[index % key.length].ord).chr
  end.join
end

keysize = determine_keysize(contents)
puts "Keysize: #{keysize}" # Keysize: 29
blocks = transposed_blocks(contents, keysize)
key = blocks.map do |block|
  determine_key(block)
end
puts "Key: #{key.join}" # Key: Terminator X: Bring the noise
puts "Decoded:\n#{decode(contents, key.join)}"
