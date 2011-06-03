#!/usr/bin/ruby

require './Cell.rb'


# Describes a branch in the deadend removal tree
class Branch

	attr_accessor :cells, :children

  # Initialiser. 
	# Cells are the cells in the object
	# Children are other objects
	#
	#	@params		cells		Cells of that object	
	def initialize(cells)
		@cells = cells
		@children = []
	end

end
