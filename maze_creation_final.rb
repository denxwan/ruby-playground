require 'rubygems'
require 'gosu'

WIDTH = 500
HEIGHT = 500

# 2D Array
ROWS = 10
COLS = 10
Cell_Matrix = Array.new(ROWS) { Array.new(COLS, 0) }

class MazeCreation < Gosu::Window
  def initialize 
    super(WIDTH, HEIGHT, false)
    self.caption = "Maze Creation"

    # Declaring variables
    @sel_x = nil
    @sel_y = nil

    # Matrix initialization
    for x in 0..9
      for y in 0..9
        Cell_Matrix[x][y] = false
      end
    end
  end

  def update
  end

  def draw
    # Matrix method for draw func
    # Every row
    for i in 0..9
      # Every column
      for j in 0..9
        # Check if the selected cell is currently active
        # If so, make it active or inactive
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
    # Get mouse click input
    when Gosu::MsLeft then 
      # Call the function to select the cell using the mouse input coordinates
      GetPosition(mouse_x.to_i, mouse_y.to_i)
    end
  end

  # Function to select the cell from mouse input
  def GetPosition(mouse_value_x, mouse_value_y)
    # Divide by the cell size and get correct cell position
    @sel_x = mouse_value_x.div(50)
    @sel_y = mouse_value_y.div(50)

    # Inversing the cell state
    if (Cell_Matrix[@sel_x][@sel_y] == false)
      Cell_Matrix[@sel_x][@sel_y] = true
    else
      Cell_Matrix[@sel_x][@sel_y] = false
    end

    # Checking all cells to output the neighbour refence
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

        # Output neighbour reference
        puts "Cell x: #{i}, y: #{j} north:#{north} south:#{south} east:#{east} west:#{west}"
      end
      puts "--------------- End of Column ---------------"
    end
  end
end

window = MazeCreation.new
window.show
