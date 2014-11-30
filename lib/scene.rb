class Scene

	attr_accessor :player, :width, :height, :directions

	def initialize
		@width = 40
		@height = 15
		@win = Curses::Window.new(@height, @width, 0, 0)
		@win.bkgd(".")
		@objects = {}
		@directions = {}
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
			if y < @height - 2
				if i = item_at(x, y + 1)
					return {} unless i.permeable?
				end
				@player.y += 1
			elsif y == @height - 2
				return { scene: [@directions[:s], @player, @player.x, 1] }
			end
		when :up
			if y > 1
				if i = item_at(x, y - 1)
					return {} unless i.permeable?
				end
				@player.y -= 1
			elsif y == 1
				return { scene: [@directions[:n], @player, @player.x, @height - 2] }
			end
		when :left
			if x > 1
				if i = item_at(x - 1, y)
					return {} unless i.permeable?
				end
				@player.x -= 1
			else
				return { scene: [@directions[:w], @player, @width - 2, @player.y] }
			end
		when :right
			if x < @width - 2
				if i = item_at(x + 1, y)
					return {} unless i.permeable?
				end
				@player.x += 1
			elsif x == @width - 2
				return { scene: [@directions[:e], @player, 1, @player.y] }
			end
		else
			Console.log("Scene#move_player: invalid direction: #{direction.inspect}", true)
		end
		{}
	end

	def pickup_item
		pos = [@player.x, @player.y]
		if @objects[pos]
			@player.inventory << item = @objects.delete(pos)
			Console.log("You picked up #{item.name(:article)}!")
		else
			Console.log("There is nothing here to pickup.")
		end
	end

	def add_object(obj, x, y)
		@objects[[x, y]] = obj
	end

	def move_object_at(x, y, nx, ny)
		@objects[[nx, ny]] = @objects.delete([x, y])
	end


	def draw
		@win.clear
		@win.box("|", "-")
		@objects.each do |(x, y), obj|
			@win.setpos(y, x)
			@win << obj.to_s
		end
		@win.setpos(@player.y, @player.x)
		@win << player.to_s
		@win.refresh
	end

	def close
		@win.close
	end
end