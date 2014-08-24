sample = File.read('text_analysis_sample.txt')
freq = {}
percent = {}
total = sample.each_char.count
sample.each_char.sort.each do |char|
  freq[char] ||= 0
  freq[char] += 1
  percent[char] = freq[char].to_f / total
end

puts freq.inspect
puts percent.inspect
