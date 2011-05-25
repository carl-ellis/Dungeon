#!/usr/bin/ruby

require './Cell.rb'

class Dungeon

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

d = Dungeon.new(25,25)
puts d.to_s
