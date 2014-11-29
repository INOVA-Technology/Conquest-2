class Scene

	attr_accessor :player

	def initialize
		@width = 60
		@height = 20
		@win = Curses::Window.new(@height, @width, 0, 0)
		@win.bkgd(".")
		@win.box("|", "-")
		@win.keypad = true
		@objects = {}
		@player = nil
	end

	def item_at(x, y)
		@objects[[x, y]]
	end

	def set_player(player, x, y)
		@player = player
		@player.x = x
		@player.y = y
	end

	def move_player(direction)
		x = @player.x
		y = @player.y
		case direction.to_sym
		when :down
			if y < @height - 1
				if i = item_at(x, y + 1)
					return unless i.permeable
				end
				@player.y += 1
			end
		when :up
			if y > 0
				if i = item_at(x, y - 1)
					return unless i.permeable
				end
				@player.y -= 1
			end
		when :left
			if x > 0
				if i = item_at(x - 1, y)
					return unless i.permeable
				end
				@player.x -= 1
			end
		when :right
			if x < @width - 1
				if i = item_at(x + 1, y)
					return unless i.permeable
				end
				@player.x += 1
			end
		else
			Console.log("Scene#move_player: invalid direction: #{direction.inspect}", true)
		end
	end

	def pickup_item
		pos = [@player.x, @player.y]
		if @objects[pos]
			@player.inventory << item = @objects.delete(pos)
			Console.log("You picked up #{item.name(:article)}")
		else
			Console.log("There is nothing here to pickup.")
		end
	end

	def getkey
		@win.getch
	end

	def add_object(obj, x, y)
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