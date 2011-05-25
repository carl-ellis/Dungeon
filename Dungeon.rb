#!/usr/bin/ruby

require './Cell.rb'

class Dungeon

  ROOM_SIZE_WEIGHT = 0.10
  ROOM_ALLOCATION_WEIGHT = 0.15
  MAX_PLACEMENT_ITERATION = 10

	attr_reader :width, :height
	attr_accessor :cells

	# Generates the dungeon object
	# 
	# @params		width			Width of dungeon
	# @params  	height		Height of dungeon
  def initialize(width, height)

		# ensure heights and widths are odd
		width += 1 if width.odd?
		height += 1 if height.odd?
		@width = width
		@height = height

		# Initilize cell array
		initialise_cell_array()

		# Block the perimeter
		block_perimeter()

		# Generate rooms
    generate_rooms()
		# Generate corridors
	end

	# Initialises the cell array with unallocated cells
	def initialise_cell_array
		@cells = []
		(0..width).each do |i|
			@cells[i] = []
			(0..height).each do |j|
				@cells[i][j] = Cell.new(i,j, Cell::UNALLOCATED)
			end
		end
	end

	# Sets the perimeter cells to be blocked
	def block_perimeter
		(0..width).each do |i| 
			@cells[i][0].type 				= Cell::BLOCKED
			@cells[i][height].type 	= Cell::BLOCKED
		end
		(0..height).each do |j| 
			@cells[0][j].type 				= Cell::BLOCKED
			@cells[width][j].type 	= Cell::BLOCKED
		end
	end

  # Generates the rooms for the dungeon
  # There can only be a given number of rooms in the dungeon
  # Where the allocated space in a dungeon for rooms is area / room_weight
  def generate_rooms

    allocated_cells = (@width*@height*Dungeon::ROOM_ALLOCATION_WEIGHT).floor
    taken_cells = 0
    room_id = 1

    max_room_w = @width   * Dungeon::ROOM_SIZE_WEIGHT - 1
    max_room_h = @height  * Dungeon::ROOM_SIZE_WEIGHT - 1

    # Make rooms until all the allocation has dried out
    while taken_cells < allocated_cells
      
      r_w = (rand*max_room_w).ceil + 1
      r_h = (rand*max_room_h).ceil + 1
      if r_w.odd? && r_h.odd?  
        place_room(r_w, r_h, room_id)  
        taken_cells += r_w*r_h
        room_id += 1
      end
    end
    
    puts "Alloc: #{allocated_cells} Placed:#{taken_cells}"

  end

  # Randomly places the room where there is space, and builds the perimeter wall
  #
  # @params   w           Width of room
  # @params   h           Height of room
  # @params   room_id     Height of room
  def place_room(w,h,room_id)
    
    max_tries = Dungeon::MAX_PLACEMENT_ITERATION
    c_try = 0
    while c_try < max_tries

      # Get the top left corner, must be even 
      tli = (rand*@width).floor
      tli += 1 if tli.odd?
      tlj = (rand*@height).floor
      tlj += 1 if tlj.odd?

      # Check all the cells from this point are unallocated, 
      # and an extra 1 width around for perimeter
      failed = false
      (tli..tli+w+1).each do |i|
        (tlj..tlj+h+1).each do |j|
          if !failed
            failed = true if @cells[i][j].type != Cell::UNALLOCATED
          end
        end
      end

      
      # if checks ok, build the room and the perimeter
      if !failed
        (tli..tli+w+1).each do |i|
          (tlj..tlj+h+1).each do |j|
              @cells[i][j].type = Cell::ROOM
              @cells[i][j].room_id = room_id
              @cells[i][j].type = Cell::PERIMETER if i == tli || i == tli+w+1
              @cells[i][j].type = Cell::PERIMETER if j == tlj || j == tlj+h+1
          end
        end
        # Meet loop criterea
        c_try = Dungeon::MAX_PLACEMENT_ITERATION
      end
        
      c_try += 1
    end
    
  end

	# Output to console
	def to_s
		out = ""
		(0..width).each do |i|
			str = ""
			(0..height).each do |j|
				str << "#{@cells[i][j]}"
			end
			out << "#{str}\n"
		end
		return out
	end

end

print `clear`
d = Dungeon.new(50,50)
puts d.to_s
