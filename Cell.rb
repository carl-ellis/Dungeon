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
		case @type
      when Cell::BLOCKED
			  char = "#"
      when Cell::PERIMETER
        char = "P"
      when Cell::ROOM
        char = "R"
      when Cell::CORRIDOR
        char = "C"
      when Cell::ENTRANCE
        char = "E"
      else
			char = " "
		end
    return char
	end

end

