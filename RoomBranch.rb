#!/usr/bin/ruby

require './Branch.rb'

# Describes as Room branch in the deadend removal tree
class RoomBranch < Branch

  # Initialiser. 
	#	@inherit
	def initialize(cells)
		super(cells)
	end

end

