

require "gosu"

# ---------------- Cell ----------------
class Cell
  attr_accessor :x, :y, :walls, :visited, :trail
  attr_accessor :north, :south, :east, :west
  attr_accessor :clicked # clicked state for toggling

  def initialize(x, y)
    @x, @y = x, y
    @walls = [true, true, true, true] # top, right, bottom, left
    @visited = false
    @trail = false
    @clicked = false

    @north = @south = @east = @west = nil
  end

  # Helpers to print neighbor info
  def has_n? = !@north.nil?
  def has_s? = !@south.nil?
  def has_e? = !@east.nil?
  def has_w? = !@west.nil?
end

# ---------------- Maze Generator ----------------
class Maze
  attr_reader :cols, :rows, :grid, :start, :goal

  def initialize(cols, rows)
    @cols, @rows = cols, rows
    @grid = Array.new(cols * rows) { |i| Cell.new(i % cols, i / cols) }
    @start = at(0, 0)
    @goal = at(cols - 1, rows - 1)

    connect_neighbors! # requirement #1
  end

  def idx(x, y) = y * @cols + x
  def at(x, y) = @grid[idx(x, y)]

  def connect_neighbors!
    (0...@rows).each do |y|
      (0...@cols).each do |x|
        c = at(x, y)
        c.north = y > 0 ? at(x, y - 1) : nil
        c.south = y < @rows - 1 ? at(x, y + 1) : nil
        c.east  = x < @cols - 1 ? at(x + 1, y) : nil
        c.west  = x > 0 ? at(x - 1, y) : nil
      end
    end
  end

  # Depth-first search maze carving
  def carve!
    stack = []
    cur = @start
    cur.visited = true
    loop do
      unv = neighbors(cur).select { |(n, _)| !n.visited }
      if unv.any?
        nxt, dir = unv.sample
        cur.walls[dir] = false
        nxt.walls[(dir + 2) % 4] = false
        stack << cur
        cur = nxt
        cur.visited = true
      elsif stack.any?
        cur = stack.pop
      else
        break
      end
    end
    self
  end

  def neighbors(cell)
    x, y = cell.x, cell.y
    ns = []
    ns << [at(x, y - 1), 0] if y > 0
    ns << [at(x + 1, y), 1] if x < @cols - 1
    ns << [at(x, y + 1), 2] if y < @rows - 1
    ns << [at(x - 1, y), 3] if x > 0
    ns
  end
end

# ---------------- Game ----------------
class Game < Gosu::Window
  WIDTH = 860
  HEIGHT = 900
  TOP_UI = 46

  SIZES = [15, 21, 31]
  DEFAULT_SIZE_INDEX = 1

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Maze Runner + Map Creation (White Background)"
    @title = Gosu::Font.new(20)
    @small = Gosu::Font.new(14)
    @size_i = DEFAULT_SIZE_INDEX
    @win_stamp = nil
    new_maze
  end

  def new_maze
    n = SIZES[@size_i]
    @maze = Maze.new(n, n).carve!
    @cell_px = [(WIDTH.to_f / n).floor, ((HEIGHT - TOP_UI).to_f / n).floor].min
    @origin_x = (WIDTH - @cell_px * n) / 2
    @origin_y = TOP_UI + ((HEIGHT - TOP_UI) - @cell_px * n) / 2
    @px, @py = 0, 0
    @maze.at(0, 0).trail = true
  end

  def needs_cursor? = true

  def update
    if @win_stamp && Gosu.milliseconds - @win_stamp > 800
      @win_stamp = nil
      new_maze
    end
  end

  # ---------------- Draw ----------------
  def draw
    draw_header
    draw_board
    draw_trail
    draw_maze_walls
    draw_clicked_cells
    draw_goal
    draw_player
    draw_footer
  end

  def draw_header
    Gosu.draw_rect(0, 0, WIDTH, TOP_UI, color(16, 22, 29))
    @title.draw_text("Maze Runner", 12, 12, 1, 1, 1, color(0, 0, 0))
  end

  # White background for maze area
  def draw_board
    Gosu.draw_rect(@origin_x, @origin_y, grid_w, grid_h, color(255, 255, 255))
  end

  # Draw the path traveled
  def draw_trail
    yellow = color(255, 235, 0, 140)
    @maze.grid.each do |cell|
      next unless cell.trail
      x = @origin_x + cell.x * @cell_px
      y = @origin_y + cell.y * @cell_px
      Gosu.draw_rect(x, y, @cell_px, @cell_px, yellow, 0.2)
    end
  end

  # Draw clicked cells
  def draw_clicked_cells
    bright_yellow = color(255, 255, 0, 220)
    @maze.grid.each do |cell|
      next unless cell.clicked
      x = @origin_x + cell.x * @cell_px
      y = @origin_y + cell.y * @cell_px
      Gosu.draw_rect(x, y, @cell_px, @cell_px, bright_yellow, 0.4)
    end
  end

  def draw_maze_walls
    c = color(0, 0, 0, 255) # black walls for visibility on white background
    lw = [2, (@cell_px * 0.12).round].max
    @maze.grid.each do |cell|
      x = @origin_x + cell.x * @cell_px
      y = @origin_y + cell.y * @cell_px
      0.upto(lw - 1) do |off|
        draw_line(x, y + off, c, x + @cell_px, y + off, c, 1) if cell.walls[0]
        draw_line(x + @cell_px - off, y, c, x + @cell_px - off, y + @cell_px, c, 1) if cell.walls[1]
        draw_line(x + @cell_px, y + @cell_px - off, c, x, y + @cell_px - off, c, 1) if cell.walls[2]
        draw_line(x + off, y + @cell_px, c, x + off, y, c, 1) if cell.walls[3]
      end
    end
  end

  def draw_goal
    cell = @maze.goal
    x = @origin_x + cell.x * @cell_px
    y = @origin_y + cell.y * @cell_px
    pad = (@cell_px * 0.18).to_i
    Gosu.draw_rect(x + pad, y + pad, @cell_px - pad * 2, @cell_px - pad * 2, color(0, 128, 255), 0.5)
  end

  def draw_player
    x = @origin_x + @px * @cell_px
    y = @origin_y + @py * @cell_px
    pad = (@cell_px * 0.22).to_i
    Gosu.draw_rect(x + pad, y + pad, @cell_px - pad * 2, @cell_px - pad * 2, color(0, 200, 100), 0.6)
  end

  def draw_footer
    hint = "Left click: toggle cell  |  P: print neighbors  |  Arrows/WASD move  |  R: new maze"
    @small.draw_text(hint, (WIDTH - @small.text_width(hint)) / 2, HEIGHT - 26, 1, 1, 1, color(0, 0, 0))
  end

  # ---------------- Input ----------------
  def button_down(id)
    case id
    when Gosu::KB_ESCAPE then close
    when Gosu::KB_R then new_maze
    when Gosu::KB_P then print_neighbors
    when Gosu::KB_LEFT,  Gosu::KB_A then move(-1, 0)
    when Gosu::KB_RIGHT, Gosu::KB_D then move(1, 0)
    when Gosu::KB_UP,    Gosu::KB_W then move(0, -1)
    when Gosu::KB_DOWN,  Gosu::KB_S then move(0, 1)
    when Gosu::MS_LEFT then toggle_clicked_cell(mouse_x, mouse_y)
    end
  end

  def toggle_clicked_cell(mx, my)
    return unless mx.between?(@origin_x, @origin_x + grid_w) && my.between?(@origin_y, @origin_y + grid_h)
    gx = ((mx - @origin_x) / @cell_px).floor
    gy = ((my - @origin_y) / @cell_px).floor
    cell = @maze.at(gx, gy)
    cell.clicked = !cell.clicked
  end

  def move(dx, dy)
    cell = @maze.at(@px, @py)
    allowed =
      (dx == -1 && !cell.walls[3]) ||
      (dx ==  1 && !cell.walls[1]) ||
      (dy == -1 && !cell.walls[0]) ||
      (dy ==  1 && !cell.walls[2])
    return unless allowed

    nx = @px + dx
    ny = @py + dy
    return unless nx.between?(0, @maze.cols - 1) && ny.between?(0, @maze.rows - 1)

    @px, @py = nx, ny
    @maze.at(@px, @py).trail = true
  end

  # ---------------- Print Neighbors ----------------
def print_neighbors
  cols = @maze.cols
  rows = @maze.rows

  (0...cols).each do |x|
    (0...rows).each do |y|
      c = @maze.at(x, y)
    
      puts "Cell x: #{c.x}, y: #{c.y} "\
           "north:#{c.north ? 1 : 0} "\
           "south:#{c.south ? 1 : 0} "\
           "east:#{c.east ? 1 : 0} "\
           "west:#{c.west ? 1 : 0}"
    end
    puts "End of Column"
    
  end
end


  # ---------------- Helpers ----------------
  def grid_w = @cell_px * @maze.cols
  def grid_h = @cell_px * @maze.rows
  def color(r, g = r, b = r, a = 255) = Gosu::Color.rgba(r, g, b, a)
end

Game.new.show
