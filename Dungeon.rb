#!/usr/bin/ruby

class Dungeon

	attr_reader :width, :height
	attr_accessor :cells

  def initialize(width, height)

		# ensure heights and widths are odd
		width += 1 if width.odd?
		height += 1 if height.odd?
		@width = width
		@height = height

		# Initilize cell array

		# Block the perimeter
		# Generate rooms
		# Generate corridors
	end

end
