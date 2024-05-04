require "colorize"
require "option_parser"

module CrystalBrain
  VERSION = "0.1.0"

  #states
  DEAD  = 0
  DYING = 1
  ALIVE = 2

  #clear screen command
  CLS = "\33c\e[3J"

  class Brain
    property name
    property x_size
    property y_size

    def initialize(name : String, x_size : Int32, y_size : Int32)
      @name = name
      @x_size = x_size
      @y_size = y_size
      @board = Array(Array(Int32)).new(@x_size) { Array(Int32).new(@y_size, 0) }
      random_population
    end

    #for printing to console - don't call as API unless you want to clear the screen and print the board.
    def simple_print()
      (0...@x_size).each do |x|
        line_buffer = ""
        (0...@y_size).each do |y|
          case @board[x][y]
            when ALIVE
              line_buffer += " #{"X".colorize(:red)}"
            when DYING
              line_buffer += " #{"*".to_s.colorize(:yellow)}"
            else
              line_buffer += " #{" ".to_s.colorize(:white)}"
          end
        end
        puts line_buffer
      end
    end

    def random_population()
        (0...@x_size).each do |x|
          (0...@y_size).each do |y|
            @board[x][y] =  Random.rand(3)
          end

        end
    end

    def count_live_neighbors(x_in, y_in)
      count = 0
      x = -1
      while x < 2
        y = -1
        while y < 2
          unless x==0 && y==0
            if x_in+x>=0 && x_in+x < @x_size && y_in+y>=0 && y_in+y < @y_size
              if @board[x_in+x][y_in+y] == ALIVE
                count += 1
              end
            end
          end
          y += 1
        end
        x += 1
      end
      return count
    end

    def tick()
      board_buffer = Array(Array(Int32)).new(@x_size) { Array(Int32).new(@y_size, 0) }
      (0...@x_size).each do |x|
        (0...@y_size).each do |y|
          case @board[x][y]
            when DEAD
              # then transition to life if it has exactly 2 neighbors

              neighbors = count_live_neighbors x, y
              if neighbors == 2
                board_buffer[x][y] = ALIVE
              end
            when ALIVE
              board_buffer[x][y] = DYING
            else
              board_buffer[x][y] = DEAD
          end
        end
      end
      @board = board_buffer
    end
  end


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
    parser.on "-r SIZE", "--rowsize SIZE", "Board size on the x axis" do |ysz|
      y_size = ysz.to_i
    end
    parser.on "-c SIZE", "--colsize SIZE", "Board size on the y axis" do |xsz|
      x_size = xsz.to_i
    end
    parser.on "-t TIME", "--time TIME", "Animation sleep time" do |tme|
      sleep_time = tme.to_f
    end

  end

  brain = Brain.new "MyTest", x_size.to_i, y_size.to_i
  count = 0
  while iterations > 0
    puts CLS
    puts "Iterating: " + count.to_s
    brain.simple_print
    iterations -= 1
    count += 1
    sleep sleep_time
    brain.tick
  end


end
