input = "YELLOW SUBMARINE"
block_size = 20
expected_output = "YELLOW SUBMARINE\x04\x04\x04\x04"

def pad(input, size)
  remainder = input.length % size
  padding_size = size - remainder
  input.clone << padding_size.chr * padding_size
end

padded = pad(input, block_size)
puts "Expected? #{expected_output == padded}"
puts "Padded: #{padded.inspect}"
puts "Expect: #{expected_output.inspect}"
