#!/usr/bin/ruby

require './Branch.rb'
require './Cell.rb'

# Describes as Corridor branch in the deadend removal tree
class CorridorBranch < Branch

  # Initialiser. 
	#	@inherit
	def initialize(cells)
		super(cells)
	end

	def full?
		v = true
		@cells.each { |c| v = false if c.type != Cell::CORRIDOR}
		return v
	end

end

