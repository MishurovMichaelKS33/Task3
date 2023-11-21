def calculate_recursion(cake, height, width, square, stack, map, raisin_count, result)
  startx = -1
  starty = -1
  (0...height).each do |x|
    (0...width).each do |y|
      if map[x][y] == 0
        startx = x
        starty = y
        break
      end
    end
    break if startx != -1
  end
  (1..(height-startx)).each do |a|
    (1..(width-starty)).each do |b|
      next if a*b != square
      slice = []
      raisins = 0
      cake[startx...(startx + a)].each do |submas|
        slice << submas[starty...(starty + b)]
        raisins += submas[starty...(starty + b)].count 'o'
      end
      next if raisins != 1
      stack << slice
      (startx...(startx + a)).each {|x| (starty...(starty + b)).each {|y| map[x][y] = 1}}
      if stack.size == raisin_count
        result = stack.dup if result.size == 0 or result[0][0].size < stack[0][0].size
      else
        result = calculate_recursion cake, height, width, square, stack, map, raisin_count, result
      end
      stack.pop
      (startx...(startx + a)).each {|x| (starty...(starty + b)).each {|y| map[x][y] = 0}}
    end
  end
  result
end

def calculate_cake(cake)
  raisin_count = 0
  cake.each {|submas| raisin_count += submas.count 'o'}
  return "Error:\nWrong raisin count" if raisin_count == 0
  height = cake.size
  width = cake[0].size
  return "Error:\nWrong raisin count" if (height * width) % raisin_count != 0
  square = (height * width)/raisin_count
  map = Array.new(height) { Array.new(width) { 0 } }
  result = calculate_recursion cake, height, width, square, [], map, raisin_count, []
  return "Result:\nCombinations not found" if result.size == 0
  rstr = "Result:\n[\n\n"
  result.each do |x|
    x.each do |y|
      y.each do |z|
        rstr += " #{z}"
      end
      rstr += "\n"
    end
    rstr += ",\n"
  end
  rstr += "\n]"
end

if __FILE__ == $0
  loop do
    rnd = Random.new
    while true
      m = rnd.rand(4..8)
      n = rnd.rand(4..8)
      k = rnd.rand(2..9)
      break if (m * n) % k == 0
    end
    cake = Array.new(m) { Array.new(n){ '.' } }
    while k > 0
      x = rnd.rand(0...m)
      y = rnd.rand(0...n)
      if cake[x][y] == '.'
        cake[x][y] = 'o'
        k -= 1
      end
    end
    rstr = "Cake:\n"
    cake.each do |submas|
      submas.each do |char|
          rstr += " #{char}"
      end
      rstr += "\n"
    end
    puts rstr
    puts calculate_cake cake
    puts "Enter anything to continue or 'exit'"
    text = gets.chomp
    break if text == "exit"
  end
end