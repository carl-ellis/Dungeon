require 'rubygems'
require 'sdl'     
require './CircularDungeon'

w = 80
h = 80
sf = 10

d = CircularDungeon.new(w,h)
c = d.cells
puts "SDL output"
puts "=========="

running = true

SDL::init(SDL::INIT_VIDEO)
screen = SDL::setVideoMode(w*sf,w*sf, 16,SDL::SWSURFACE)

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
			screen.fill_rect(x*sf,y*sf,sf,sf,colour)
		end
	end
	
	
	screen.flip
end
