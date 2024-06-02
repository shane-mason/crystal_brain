require "colorize"
require "option_parser"

module CrystalBrain


  enum States
    DEAD
    DYING
    ALIVE
  end

  #clear screen command
  CLS = "\33c\e[3J"

  class Brain
    property name
    property x_size : Int32
    property y_size : Int32

    def initialize(@name : String, @x_size : Int32, @y_size : Int32)
      @board = Array(Array(States)).new(@x_size) { Array(States).new(@y_size, States::DEAD) }
      random_population
    end

    def random_population()
        (0...@x_size).each do |x|
          (0...@y_size).each do |y|
            random_state = Random.rand(3)
            @board[x][y] = States.new(random_state)
          end
        end
    end


    def count_live_neighbors(x_in, y_in)
      count = 0
      (-1..1).each do |x|
        (-1..1).each do |y|
          unless x==0 && y==0
            #only if neighbor is inside the grid
            if x_in+x>=0 && x_in+x < @x_size && y_in+y>=0 && y_in+y < @y_size
              if @board[x_in+x][y_in+y] == States::ALIVE
                count += 1
              end
            end
          end
        end
      end
      return count
    end

    def tick()
      board_buffer = Array(Array(States)).new(@x_size) { Array(States).new(@y_size, States::DEAD) }
      (0...@x_size).each do |x|
        (0...@y_size).each do |y|
          case @board[x][y]
            when States::DEAD
              # then transition to life if it has exactly 2 neighbors
              neighbors = count_live_neighbors x, y
              if neighbors == 2
                board_buffer[x][y] = States::ALIVE
              end
            when States::ALIVE
              # then transition to dying
              board_buffer[x][y] = States::DYING
            else
              #then it was dying, transition to dead
              board_buffer[x][y] = States::DEAD
          end
        end
      end
      @board = board_buffer
    end

    #for printing to console - don't call as API unless you want to clear the screen and print the board.
    def simple_print()
      buffer = ""
      (0...@x_size).each do |x|
        line_buffer = ""
        (0...@y_size).each do |y|
          case @board[x][y]
            when States::ALIVE
              line_buffer += " #{"X".colorize(:red)}"
            when States::DYING
              line_buffer += " #{"*".colorize(:blue)}"
            else
              line_buffer += " #{" ".colorize(:white)}"
          end
        end
        buffer += line_buffer + "\n"
      end
      puts CLS
      puts buffer
    end
#

  end # class brain


end
