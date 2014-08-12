require 'base64'

str = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
expected = 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'
puts "Converting Hex String #{str} to base64"
hex_to_string = [str].pack('H*') # "I'm killing your brain like a poisonous mushroom"
encoded = Base64.strict_encode64(hex_to_string)
puts "Input string equals expected? #{expected == encoded}"

