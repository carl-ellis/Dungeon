#!/usr/bin/ruby

require './Cell.rb'
require './Direction.rb'
require './RoomBranch.rb'
require './CorridorBranch.rb'

class Dungeon

  ROOM_SIZE_WEIGHT = 0.10
  ROOM_ALLOCATION_WEIGHT = 0.15
  MAX_PLACEMENT_ITERATION = 10
	ROOM_DOORS = 4.0 

	attr_reader :width, :height, :room_map, :corridor_map
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
		generate_corridors()

		# Trim tree
		trim_tree()
	end

	# Initialises the cell array with unallocated cells
	def initialise_cell_array
		@cells = []
		@room_map = {}
		@corridor_map = {}
		@corridor_seeds = []
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

	# Gets the number of available cells for rooms
	def get_allocated_cells
		allocated_cells = 0.0;
		@cells.each { |i| i.each { |j| allocated_cells += 1 if j.type != Cell::BLOCKED } }
		return (allocated_cells*Dungeon::ROOM_ALLOCATION_WEIGHT).floor
	end

  # Generates the rooms for the dungeon
  # There can only be a given number of rooms in the dungeon
  # Where the allocated space in a dungeon for rooms is area / room_weight
  def generate_rooms

    allocated_cells = get_allocated_cells
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
				# Probability falls so there are an average of 2 doors per room
				per = 2*(w+h)
				door_chance = Dungeon::ROOM_DOORS/per

				# Prep for building a logical object ready for dead end removal
				room_cells = []

        (tli..tli+w+1).each do |i|
          (tlj..tlj+h+1).each do |j|
              @cells[i][j].type = Cell::ROOM
              @cells[i][j].room_id = room_id
							# If perimeter wall, assign door if random number is under the threshold
   						if i == tli || i == tli+w+1 || j == tlj || j == tlj+h+1  
              @cells[i][j].type = Cell::PERIMETER 
								if i.odd? || j.odd?
		              @cells[i][j].type = Cell::ENTRANCE if rand < door_chance
								end
							end

							# Store the room cells read for assignment to logical structure
							room_cells << @cells[i][j];
          end
        end
        # Meet loop criterea
        c_try = Dungeon::MAX_PLACEMENT_ITERATION

				# Build logical object and map entrance cells to the room
				room_obj = RoomBranch.new(room_cells)
				room_cells.each { |c| room_map[c] = room_obj if c.type == Cell::ENTRANCE }

      end
        
      c_try += 1
    end
    
  end

  # Generates corridors on all viable corridor seeds
	# (odd (x,y)'s
	def generate_corridors()
		(0..width).each do |i|
			(0..height).each do |j|
				if i.odd? && j.odd? && @cells[i][j].type == Cell::UNALLOCATED
					carve_corridors(i,j,nil)
				end
			end
		end
	end

	# Carve out corridor sections in every direction from a given
	# (x,y)
	#
	# @params		i			Initial x coord
	# @params 	j			Initial y coord
	def carve_corridors(i,j, parent)
		dirs = Direction::DIRECTIONS.keys.shuffle

		# Pick a random direction
		dirs.each do |d_key|
			#Check the next two squares in that direction
			t_cells = [@cells[i][j]]
			failed = false
			corientrance = false
			(1..2).each do |step|
				jump = Direction::DIRECTIONS[d_key]
				if !t_cells[step-1].nil? && !failed
					t_cells[step] = @cells[t_cells[step-1].x+jump[0]][t_cells[step-1].y+jump[1]] 
					failed = true if t_cells[step].nil? || t_cells[step].type != Cell::UNALLOCATED 
					if !t_cells[step].nil? && t_cells[step].type == Cell::ENTRANCE  
						corientrance = true 
						failed = true
						break
					end
				else
					failed = true
				end
			end
			# If unallocated, carve and start next section
			if !failed
				# Create Corridor logical structure
				corridor_obj = CorridorBranch.new(t_cells)
				t_cells.each do |c| 
					c.type = Cell::CORRIDOR 
					corridor_map[c] = corridor_obj
				end
				# Add to corrdidor tree
				parent.children << corridor_obj if !parent.nil?

				l_cell = t_cells.last
				carve_corridors(l_cell.x, l_cell.y,corridor_obj)
			end
			# special case for entrance corridor links
			if corientrance
				# Create Corridor logical structure
				corridor_obj = CorridorBranch.new(t_cells)
				t_cells.each do |c| 
					corridor_map[c] = corridor_obj
				end
				l_cell = t_cells.last
				# Add to corrdidor tree
				parent.children << room_map[l_cell] if !parent.nil?
			end
		end

	end

	# go through the tree and trim off all branches without rooms
	def trim_tree
		check_branch(corridor_map[@cells[1][1]])
	end

	# Does this branch have a room on the end. if it doesn't remove the reference
	#
	# @params		branch		Branch you are checking
	#
	# @returns						If branch has a room
	def check_branch(branch)
  	room = false
		return room if branch.nil?

		# Recurse through the tree to see if rooms exist
		branch.children.each do |c|
			t_room = check_branch(c)
			if !t_room
				# If there is no room, remove the corridor
				c.cells.each { |cell| cell.type = Cell::UNALLOCATED }
			else
				room = true if !room
			end
		end

		# Due to corridor overlap, this makes sure the corridor gets rebuilt when a lower branch is wiped
		branch.cells.last.type = Cell::CORRIDOR if room 

		# True if a room
		room = branch.is_a?(RoomBranch) if !room

    return room
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

