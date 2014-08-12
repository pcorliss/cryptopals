key = 'ICE'
input_str = <<-EOS
Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal
EOS

# The example has a line break at the 75th char, this appears to be a typo.
expected = '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f'

encoded = ""
counter = 0
input_str.chomp.each_line do |line|
  str = line
  str.each_byte do |byte|
    encoded << "%02x" % (byte ^ key[counter % key.length].ord)
    counter += 1
  end
end

#puts "Encoded:\n#{encoded}\n"
#puts "Expected:\n#{expected}\n"
puts "Matches Expected? #{encoded == expected}"
