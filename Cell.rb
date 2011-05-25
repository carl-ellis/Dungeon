#!/usr/bin/ruby

class Cell

	UNALLOCATED = 0
	BLOCKED = 1
  PERIMETER = 2
	ROOM = 3
	ENTRANCE = 4
	CORRIDOR = 5

	attr_accessor :x, :y, :type, :id, :room_id

	def initialize(x, y, type)
		@x = x
		@y = y
		@type = type
	end

	def to_s
		char = ""
		if @type == Cell::BLOCKED
			char = "#"
		else
			char = " "
		end
    return char
	end

end

