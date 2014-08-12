str         = '1c0111001f010100061a024b53535009181c'
xor_against = '686974207468652062756c6c277320657965' # "hit the bull's eye"
expected    = '746865206b696420646f6e277420706c6179' # "the kid don't play"

xor = str.to_i(16) ^ xor_against.to_i(16)
puts "Expected equals xor? #{expected == xor.to_s(16)}"
