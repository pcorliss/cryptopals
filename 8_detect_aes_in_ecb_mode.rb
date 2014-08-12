#require 'openssl'

file = File.read('challenge-data/8.txt')

smallest = nil
file.each_line do |line|
  str = line.chomp
  bytes = [str].pack("H*").bytes
  count = bytes.each_slice(16).to_a.uniq.count
  if smallest.nil? || smallest[:count] > count
    smallest = {count: count, line: line}
  end
end

puts "Line with repeated 16-byte sequences"
puts smallest.inspect
