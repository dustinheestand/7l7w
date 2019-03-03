def printFourAtATime
  arr = (1..16).to_a
  chunk = []
  arr.each do |i|
    chunk.push(i)
    if chunk.length == 4
      p chunk
      chunk = []
    end
  end
  arr.each_slice(4) { |slice| p slice }
end

printFourAtATime
