class Scene

	attr_accessor :player, :width, :height, :directions, :objects

	def initialize
		@width = 40
		@height = 15
		@win = Curses::Window.new(@height, @width, 0, 0)
		@objects = {}
		@directions = {}
		@player = nil
	end

	def self.load_from_file(file)
		scene = Scene.new
		File.readlines(file).each_with_index do |line, y|
			line.chars.each_with_index do |char, x|
				bla = case char
				when "∆" then Pizza.new
				when "%" then Shrubbery.new
				when "-" then Wall.new(:h)
				when "|" then Wall.new(:v)
				when "┌" then Wall.new(:tl)
				when "┐" then Wall.new(:tr)
				when "└" then Wall.new(:bl)
				when "┘" then Wall.new(:br)
				when "#" then Bush.new
				when "░" then Path.new
				when "⌘" then Pretzel.new
				when "•" then Shamrock.new
				when "¥" then Rose.new
				when "*" then Flower.new
				when "^" then Carrot.new
				when " ", "\n", "⏐" # ignore these
				else
					Console.log("Scene.load_from_file: invalid charecter: #{char.inspect}")
					nil
				end
				scene.objects[[x + 1, y + 1]] = bla unless bla.nil?
			end
		end
		scene
	end

	def object_at(x, y)
		@objects[[x, y]]
	end

	def set_player(player, x, y)
		@player = player
		@player.x = x
		@player.y = y
	end

	# this is hideous and needs to be refactored
	def move_player(direction)
		x = @player.x
		y = @player.y
		case direction.to_sym
		when :down
			if y < @height - 2
				if i = object_at(x, y + 1)
					return {} unless i.permeable?
				end
				@win.setpos(y, x)
				@win.delch
				@win.insch(" ")
				@player.y += 1
			elsif y == @height - 2
				@win.setpos(y, x)
				@win.delch
				@win.insch(" ")
				return { scene: [@directions[:s], @player, x, 1] }
			end
		when :up
			if y > 1
				if i = object_at(x, y - 1)
					return {} unless i.permeable?
				end
				@win.setpos(y, x)
				@win.delch
				@win.insch(" ")
				@player.y -= 1
			elsif y == 1
				@win.setpos(y, x)
				@win.delch
				@win.insch(" ")
				return { scene: [@directions[:n], @player, x, @height - 2] }
			end
		when :left
			if x > 1
				if i = object_at(x - 1, y)
					return {} unless i.permeable?
				end
				@win.setpos(y, x)
				@win.delch
				@win.insch(" ")
				@player.x -= 1
			else
				@win.setpos(y, x)
				@win.delch
				@win.insch(" ")
				return { scene: [@directions[:w], @player, @width - 2, y] }
			end
		when :right
			if x < @width - 2
				if i = object_at(x + 1, y)
					return {} unless i.permeable?
				end
				@win.setpos(y, x)
				@win.delch
				@win.insch(" ")
				@player.x += 1
			elsif x == @width - 2
				@win.setpos(y, x)
				@win.delch
				@win.insch(" ")
				return { scene: [@directions[:e], @player, 1, y] }
			end
		else
			Console.log("Scene#move_player: invalid direction: #{direction.inspect}")
		end
		{}
	end

	def pickup_item
		pos = [@player.x, @player.y]
		if @objects[pos]
			if @objects[pos].can_pickup?
				@player.inventory << item = @objects.delete(pos)
				@win.setpos(@player.y, @player.x)
				@win.delch
				@win.insch(" ")
				Console.write("You picked up #{item.name(:article)}!")
			else
				Console.write("There is nothing here to pickup.")
			end
		else
			Console.write("There is nothing here to pickup.")
		end
	end

	def add_object(obj, x, y)
		@objects[[x, y]] = obj
	end

	def move_object_at(x, y, nx, ny)
		@objects[[nx, ny]] = @objects.delete([x, y])
	end


	def draw
		@win.box("|", "-")
		@objects.each do |(x, y), obj|
			@win.setpos(y, x)
			if obj.color
				@win.setpos(y, x)
				@win.attron(Curses.color_pair(obj.color)|Curses::A_NORMAL) do
					@win << obj.to_s
				end
			else
				@win << obj.to_s
			end
		end
		@win.setpos(@player.y, @player.x)
		@win << @player.to_s
		@win.refresh
	end

	def clear
		@win.clear
	end

	def close
		@win.close
	end
end