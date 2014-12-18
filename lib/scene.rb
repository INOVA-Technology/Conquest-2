class Scene

	attr_accessor :player, :width, :height, :directions, :objects, :objects_2, :file_name

	def initialize
		@width = 40
		@height = 15
		@win = Curses::Window.new(@height, @width, 0, 0)
		@objects = {}
		@objects_2 = {}
		@directions = {}
		@file_name = ""
		@player = nil
	end

	def self.load_from_file(file)
		scene = Scene.new
		scene.file_name = file
		files = [file]
		files << "_#{file}" if File.file?("scenes/_#{file}")
		files.each_with_index do |f, i|
			File.readlines("scenes/#{f}").each_with_index do |line, y|
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
					when "$" then Money.new(rand(5..10))
					when "~" then Soil.new
					when " ", "\n", "⏐" # ignore these
					else
						Console.log("Scene.load_from_file: invalid charecter: #{char.inspect}")
						nil
					end
					if i == 0
						scene.objects[[x + 1, y + 1]] = bla unless bla.nil?
					else
						scene.objects_2[[x + 1, y + 1]] = bla unless bla.nil?
					end
				end
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
				remove_item_at(x, y)
				@player.y += 1
			elsif y == @height - 2
				remove_item_at(x, y)
				return { scene: [@directions[:s], @player, x, 1] }
			end
		when :up
			if y > 1
				if i = object_at(x, y - 1)
					return {} unless i.permeable?
				end
				remove_item_at(x, y)
				@player.y -= 1
			elsif y == 1
				remove_item_at(x, y)
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
				remove_item_at(x, y)
				return { scene: [@directions[:w], @player, @width - 2, y] }
			end
		when :right
			if x < @width - 2
				if i = object_at(x + 1, y)
					return {} unless i.permeable?
				end
				remove_item_at(x, y)
				@player.x += 1
			elsif x == @width - 2
				remove_item_at(x, y)
				return { scene: [@directions[:e], @player, 1, y] }
			end
		else
			Console.log("Scene#move_player: invalid direction: #{direction.inspect}")
		end
		{}
	end

	def pickup_item
		pos = [@player.x, @player.y]
		if @objects[pos] && @objects[pos].can_pickup?
			da_stuff = @objects
		elsif @objects_2[pos] && @objects_2[pos].can_pickup?
			da_stuff = @objects_2
		else
			Console.write("There is nothing here to pickup.")
			return
		end

		if da_stuff[pos].is_a?(Money)
			dough = da_stuff[pos].amount
			@player.money += dough
			da_stuff.delete(pos)
			remove_item_at(@player.x, @player.y)
			Console.write("+ $#{dough}!")
		else
			@player.inventory << item = da_stuff.delete(pos)
			remove_item_at(@player.x, @player.y)
			Console.write("You picked up #{item.name(:article)}!")
		end
	end

	def remove_item_at(x, y)
		@win.setpos(y, x)
		@win.delch
		@win.insch(" ")
	end

	def add_object(obj, x, y)
		@objects[[x, y]] = obj
	end

	def move_object_at(x, y, nx, ny)
		@objects[[nx, ny]] = @objects.delete([x, y])
	end


	def draw
		@win.box("|", "-")
		[@objects, @objects_2].each do |objs|
			objs.each do |(x, y), obj|
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