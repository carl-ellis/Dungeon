#!/usr/bin/ruby

require './Dungeon.rb'

class CircularDungeon < Dungeon

  # Initialiser
  # @inherit
  def intialize(width, height)
 	  super(width, height)
  end

  # Block a circular pattern around the grid
	def block_perimeter

		(0..@width).each do |i| 
      (0..@height).each do |j| 
        @cells[i][j].type 				= Cell::BLOCKED
      end
		end
    
    # variables for working out size of inner circle
    centre_x = (@width/2).floor
    centre_y = (@height/2).floor
    radius = [centre_x, centre_y].min

		(radius*-1..radius).each do |y| 
      half_row_width = Math.sqrt(radius*radius - y*y).to_i
      (half_row_width*-1..half_row_width).each do |x| 
        @cells[centre_x + x][centre_y + y].type = Cell::UNALLOCATED
      end
    end

		(0..@width).each do |i| 
			@cells[i][0].type 				= Cell::BLOCKED
			@cells[i][height].type 	= Cell::BLOCKED
		end
		(0..@height).each do |j| 
			@cells[0][j].type 				= Cell::BLOCKED
			@cells[width][j].type 	= Cell::BLOCKED
		end

  end

end
