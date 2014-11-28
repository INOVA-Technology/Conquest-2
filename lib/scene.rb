class Scene

	attr_accessor :player

	def initialize
		@win = Curses::Window.new(25, 80, 0, 0)
		@win.bkgd(".")
		@win.box("|", "-")
		@win.keypad = true
		@objects = {}
		@player = nil
	end

	def set_player(player, x, y)
		@player = player
		@player.x = x
		@player.y = y
	end

	def move_player(direction)
		case direction.to_sym
		when :down
			@player.y += 1
		when :up
			@player.y -= 1
		when :left
			@player.x -= 1
		when :right
			@player.x += 1
		else
			Console.log("Invalid direction: #{direction.inspect}")
		end
	end

	def getkey
		@win.getch
	end

	def add_object(obj, x, y)
		obj.id = @objects.length if GameObject == obj
		@objects[[x, y]] = obj
	end

	def move_object_at(x, y, nx, ny)
		@objects[[nx, ny]] = @objects.delete([x, y])
	end


	def draw
		@win.clear
		add_object(@id, 0, 0) if ARGV[0] == "-d"
		@objects.each do |(x, y), obj|
			@win.setpos(y, x)
			@win << obj.to_s
		end
		@win.setpos(@player.y, @player.x)
		@win << player.to_s
		@win.refresh
	end
end