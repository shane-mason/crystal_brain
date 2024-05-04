require "./crystal_brain"
module CrystalBrain
  VERSION = "0.1.0"

  iterations = 200
  sleep_time = 0.25
  x_size = 10
  y_size = 10
  OptionParser.parse do |parser|

    parser.banner = "Welcome to Crystal Brain"
    parser.on "-v", "--version", "Show version" do
      puts "version 1.0"
      exit
    end
    parser.on "-h", "--help", "Show help" do
      puts parser
      exit
    end
    parser.on "-i ITERS", "--iterations ITERS", "Iteration count" do |iters|
      iterations = iters.to_i
    end
    parser.on "-r SIZE", "--rowsize SIZE", "Board size in rows" do |xsz|
      x_size = xsz.to_i
    end
    parser.on "-c SIZE", "--colsize SIZE", "Board size in columns" do |ysz|
      y_size = ysz.to_i
    end
    parser.on "-t TIME", "--time TIME", "Animation sleep time" do |tme|
      sleep_time = tme.to_f
    end

  end

  brain = Brain.new "MyTest", x_size.to_i, y_size.to_i
  count = 0
  while iterations > 0
    brain.simple_print
    puts "Iterating: " + count.to_s
    iterations -= 1
    count += 1
    sleep sleep_time
    brain.tick
  end
end
