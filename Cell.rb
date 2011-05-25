#!/usr/bin/ruby

class Cell

	BLOCKED = 1
  PERIMETER = 2
	ROOM = 3
	ENTRANCE = 4
	CORRIDOR = 5

	attr_accessor :x, :y, :type, :id, :room_id

	def initialize(x, y)
		@x = x
		@y = y
	end

end

