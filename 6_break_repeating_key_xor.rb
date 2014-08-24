require 'base64'

file = File.read('challenge-data/6.txt')
contents = Base64.decode64(file)

# From freq.rb and our sample text
SAMPLE_CHAR_FREQ = {
  "\n" => 0.012048192771084338,
  " " => 0.16006884681583478,
  '"' => 0.005737234652897304,
  "(" => 0.0011474469305794606,
  ")" => 0.0011474469305794606,
  "," => 0.0068846815834767644,
  "-" => 0.0034423407917383822,
  "." => 0.010327022375215147,
  "/" => 0.0005737234652897303,
  "0" => 0.0005737234652897303,
  "1" => 0.0068846815834767644,
  "2" => 0.002868617326448652,
  "3" => 0.0005737234652897303,
  "4" => 0.002868617326448652,
  "5" => 0.0017211703958691911,
  "6" => 0.0005737234652897303,
  "7" => 0.0005737234652897303,
  "9" => 0.0034423407917383822,
  ":" => 0.0005737234652897303,
  "A" => 0.005737234652897304,
  "B" => 0.004016064257028112,
  "C" => 0.004016064257028112,
  "D" => 0.0017211703958691911,
  "E" => 0.0017211703958691911,
  "F" => 0.0005737234652897303,
  "G" => 0.0011474469305794606,
  "H" => 0.0005737234652897303,
  "I" => 0.006310958118187034,
  "J" => 0.0011474469305794606,
  "L" => 0.0005737234652897303,
  "M" => 0.0017211703958691911,
  "N" => 0.002294893861158921,
  "O" => 0.0011474469305794606,
  "P" => 0.002294893861158921,
  "Q" => 0.0017211703958691911,
  "S" => 0.0005737234652897303,
  "T" => 0.009753298909925417,
  "U" => 0.0005737234652897303,
  "W" => 0.006310958118187034,
  "a" => 0.06769936890418818,
  "b" => 0.013195639701663799,
  "c" => 0.03155479059093517,
  "d" => 0.03384968445209409,
  "e" => 0.08835341365461848,
  "f" => 0.01434308663224326,
  "g" => 0.01835915088927137,
  "h" => 0.029259896729776247,
  "i" => 0.06253585771658061,
  "k" => 0.006310958118187034,
  "l" => 0.030407343660355707,
  "m" => 0.021801491681009755,
  "n" => 0.04819277108433735,
  "o" => 0.04991394148020654,
  "p" => 0.011474469305794608,
  "r" => 0.05163511187607573,
  "s" => 0.03327596098680436,
  "t" => 0.05163511187607573,
  "u" => 0.022375215146299483,
  "v" => 0.005737234652897304,
  "w" => 0.010900745840504877,
  "x" => 0.002868617326448652,
  "y" => 0.01434308663224326,
  "z" => 0.002868617326448652,
  "|" => 0.0011474469305794606
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
    match = SAMPLE_CHAR_FREQ[byte.chr]
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
