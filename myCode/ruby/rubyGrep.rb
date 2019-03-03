def main(pattern, filename)
  pattern = Regexp.new pattern
  file = File.open(filename, "r")
  file.each_line.with_index { |ln, i| puts "#{i}: #{ln}" if ln =~ pattern }
end

main(ARGV[0], ARGV[1])
