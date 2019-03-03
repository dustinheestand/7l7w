def main
  answer = rand(100) + 1
  guess = 0
  while guess != answer
    puts "Guess a number between one and ONE HUNDRED" if guess < 1 or guess > 100
    guess = gets.to_i
    puts "Higher" if guess > 0 and guess < answer
    puts "Lower" if guess < 100 and guess > answer
  end
  puts "Got it!"
end

main
