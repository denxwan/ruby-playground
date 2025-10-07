require 'rubygems'
require 'gosu'

WIDTH = 500
HEIGHT = 500

# 2D Array
ROWS = 10
COLS = 10
Cell_Matrix = Array.new(ROWS) { Array.new(COLS, 0) }

module ZOrder
  BACKGROUND, MIDDLE, PLAYER, UI = *0..3
end

class Player
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x,
    @y = y
  end
end

class Cell
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x,
    @y = y
  end
end

# def draw_player player
#   draw_rect(0, 0, 50, 50, Gosu::Color.new(254, 255, 75))
# end

def draw_cell cell
  draw_rect(
    x,
    y,
    50,
    50,
    Gosu::Color.new(254, 255, 75)
  )
end

# def GetPosition(mouse_value_x, mouse_value_y)
#   temp_x = mouse_value_x.div(50)
#   temp_y = mouse_value_y.div(50)
#   puts temp_x, temp_y

#   # Change state to active
#   if (Cell_Matrix[temp_x][temp_y] == false)
#     @cell = Cell.new(temp_x*50, temp_y*50)
#     draw_cell(@cell)
#     # draw_rect(temp_x*50, temp_y*50, 50, 50, Gosu::Color.new(254, 255, 75))
#   # Change state to inactive
#   else
#     # draw_rect(temp_x*50, temp_y*50, 50, 50, Gosu::Color.new(122, 251, 64))
#     @cell = Cell.new(temp_x*50, temp_y*50)
#   end
# end

class CellPosition
  attr_accessor :x, :y

  def initialize(x, y)
    @mouse_value_x = x
    @mouse_value_y = y

    # puts @mouse_value_x
    # puts @mouse_value_y
    GetPosition(x, y)
  end
end

# class Cell
#   attr_accessor :x, :y, :size, :color, :state

#   def initialize(x, y, size, color = Gosu::Color.new(122, 251, 64))
#     @x = x
#     @y = y
#     @size = size
#     @color = color
#     @state = :default # Or any initial state
#   end

#   def draw(window)
#     window.draw_quad(
#       @x, @y, @color,
#       @x + @size, @y, @color,
#       @x + @size, @y + @size, @color,
#       @x, @y + @size, @color
#     )
#   end
# end

class MazeCreation < Gosu::Window
  def initialize 
    super(WIDTH, HEIGHT, false)
    # super WIDTH, HEIGHT, ROWS, COLS
    self.caption = "Maze Creation"
    # @should_draw_ruby = false
    @sel_x = nil
    @sel_y = nil
    @cell_state = nil
    @cells = Array.new()

    # Matrix initialization
    for x in 0..9
      for y in 0..9
        Cell_Matrix[x][y] = false
      end
    end

  #   # Instantiate Player
  #   # @player = Player.new(50, 50)

  #   # Background image
  #   #@background = Gosu::Image.new()
    # @bg_color = Gosu::Color.new(122, 251, 64)
  end

  # CELL_SIZE = 50
  # ROWS = 10
  # COLS = 10

  # def initialize
  #   super(COLS * CELL_SIZE, ROWS * CELL_SIZE, false)
  #   self.caption = "Maze Creation"

  #   @cells = []
  #   ROWS.times do |row|
  #     COLS.times do |col|
  #       x = col * CELL_SIZE
  #       y = row * CELL_SIZE
  #       @cells << Cell.new(x, y, CELL_SIZE)
  #       puts @cells
  #     end
  #   end
  # end

  # def draw
  #   @cells.each do |cell|
  #     cell.draw(self)
  #   end
  #   # draw_rect(0, 0, 50, 50, Gosu::Color.new(255, 0, 0))
  # end

  def update
  end

  def draw
    # @background.draw(0, 0, ZOrder::BACKGROUND)
    
    #draw_rect(0, 0, self.width, self.height, Gosu::Color.new(122, 251, 64))
    #@cells.each { |cell| draw_cell(cell) }
    # for i in 0..9
    #   for j in 0..9
    #     draw_rect(i, j, 50, 50, Gosu::Color.new(122, 251, 64))
    #     j = j + 50
    #   end
    #   i = i + 50
    # end
    # draw_player(@player)
    # if @should_draw_ruby
    #   # insert()
    #   draw_rect(@sel_x*50, @sel_y*50, 50, 50, Gosu::Color.new(254, 255, 75))
    # end

    # Matrix method for draw func
    for i in 0..9
      for j in 0..9
        if (Cell_Matrix[i][j] == true)
          draw_rect(i*50, j*50, 50, 50, Gosu::Color.new(254, 255, 75))
        else
          draw_rect(i*50, j*50, 50, 50, Gosu::Color.new(122, 251, 64))
        end
      end
    end

  end

  def button_down(id)
    case id
    when Gosu::MsLeft then 
      # @position = CellPosition.new(mouse_x.to_i, mouse_y.to_i)
      GetPosition(mouse_x.to_i, mouse_y.to_i)
      @should_draw_ruby = true
      # @cells.push(Cell.new(150, 300))
    end
  end

  def draw_cell cell
    # Default color of the cell
    color = Gosu::Color.new(254, 255, 75)
    if (@cell_state == true)
      color = Gosu::Color.new(122, 251, 64)
    else
      color = Gosu::Color.new(254, 255, 75)
    end

    draw_rect(
      @sel_x*50,
      @sel_y*50,
      50,
      50,
      color = Gosu::Color.new(122, 251, 64)
    )
    # if (Cell_Matrix[@sel_x][@sel_y] == false)
    #   draw_rect(
    #     @sel_x*50,
    #     @sel_y*50,
    #     50,
    #     50,
    #     Gosu::Color.new(254, 255, 75)
    # )
    # else if (Cell_Matrix[@sel_x][@sel_y] == true)
    #   draw_rect(
    #     @sel_x*50,
    #     @sel_y*50,
    #     50,
    #     50,
    #     Gosu::Color.new(122, 251, 64)
    # )
    # end
    # end
  end

  def GetPosition(mouse_value_x, mouse_value_y)
    temp_x = (mouse_value_x).div(50)
    temp_y = mouse_value_y.div(50)
    @sel_x = temp_x
    @sel_y = temp_y

    

    #puts Cell_Matrix[@sel_x][@sel_y]
    # puts "#{mouse_value_x-20} #{mouse_value_y}"
    # puts "#{@sel_x} #{@sel_y}"

    # Inversing the state
    # Cell_Matrix[@sel_x][@sel_y] = !Cell_Matrix[@sel_x][@sel_y]

    if (Cell_Matrix[@sel_x][@sel_y] == false)
      Cell_Matrix[@sel_x][@sel_y] = true
      @cell_state = Cell_Matrix[@sel_x][@sel_y]

    else
      Cell_Matrix[@sel_x][@sel_y] = false
      @cell_state = Cell_Matrix[@sel_x][@sel_y]
    end

    # @cells.push(Cell.new(@sel_x, @sel_y))
    #puts "Cell #{@sel_x} #{@sel_y} has been changed to -> #{Cell_Matrix[@sel_x][@sel_y]}"

    for i in 0..9
      for j in 0..9
        north = 0
        south = 0
        east = 0
        west = 0

        # Check north
        temp_j = j-1
        if ((temp_j >= 0) && (temp_j < 9))
          if (Cell_Matrix[i][temp_j] == true)
            north = 1
          end
        end

        # Check south
        temp_j = j+1
        if ((temp_j >= 0) && (temp_j < 9))
          if (Cell_Matrix[i][temp_j] == true)
            south = 1
          end
        end

        # Check east
        temp_i = i+1
        if ((temp_i >= 0) && (temp_i < 9))
          if (Cell_Matrix[temp_i][j] == true)
            east = 1
          end
        end

        # Check west
        temp_i = i-1
        if ((temp_i >= 0) && (temp_i < 9))
          if (Cell_Matrix[temp_i][j] == true)
            west = 1
          end
        end

        puts "Cell x: #{i}, y: #{j} north:#{north} south:#{south} east:#{east} west:#{west}"
      end
      puts "------------------- End of Column -------------------"
    end


    # # Change state to active
    # if (Cell_Matrix[temp_x][temp_y] == false)
    #   # @cell = Cell.new(temp_x*50, temp_y*50)
    #   # draw_cell(@cell)
    #   @should_draw_ruby = false
    #   # draw_rect(temp_x*50, temp_y*50, 50, 50, Gosu::Color.new(254, 255, 75))
    # # Change state to inactive
    # else
    #   # draw_rect(temp_x*50, temp_y*50, 50, 50, Gosu::Color.new(122, 251, 64))
    #   # @cell = Cell.new(temp_x*50, temp_y*50)
    #   @should_draw_ruby = false
    # end
  end
end

# MazeCreation.new.show
window = MazeCreation.new
window.show
