#!/usr/bin/ruby

require './Branch.rb'

# Describes as Corridor branch in the deadend removal tree
class CorridorBranch < Branch

  # Initialiser. 
	#	@inherit
	def initialize(cells)
		super(cells)
	end

end

