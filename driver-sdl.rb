require 'rubygems'
require 'sdl'     
require './CircularDungeon'

d = CircularDungeon.new(50,50)
c = d.cells
h = d.height
w = d.width
puts "SDL output"
puts "=========="

running = true

SDL::init(SDL::INIT_VIDEO)
screen = SDL::setVideoMode(500,500,16,SDL::SWSURFACE)

CORRIDORCOLOUR = screen.format.mapRGB(255,255,255)
BLOCKEDCOLOUR = screen.format.mapRGB(0,0,0)
ROOMCOLOUR = screen.format.mapRGB(218,165,32)
WALLCOLOUR = screen.format.mapRGB(128,128,128)
   
while running
	while event = SDL::Event2.poll
		case event
		when SDL::Event2::KeyDown, SDL::Event2::Quit
			exit
		end
	end	

	(0..w).each do |x|
		(0..h).each do |y|
			colour = nil
			case c[x][y].type
				when Cell::CORRIDOR
					colour = CORRIDORCOLOUR
				when Cell::ROOM, Cell::ENTRANCE
					colour = ROOMCOLOUR
				when Cell::PERIMETER
					colour = WALLCOLOUR
				else
					colour = BLOCKEDCOLOUR
			end
			screen.fill_rect(x*10,y*10,10,10,colour)
		end
	end
	
	
	screen.flip
end
