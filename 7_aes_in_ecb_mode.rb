require 'base64'
require 'openssl'

file = File.read('challenge-data/7.txt')
contents = Base64.decode64(file)

KEY = "YELLOW SUBMARINE"

cipher = OpenSSL::Cipher.new('AES-128-ECB')
cipher.decrypt
cipher.key = KEY
plain = cipher.update(contents) + cipher.final

puts plain
