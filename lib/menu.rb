class Menu

	def initialize(width, height, parent_width, parent_height)
		@width = width
		@height = height
		@width = parent_width if @width > parent_width
		@height = parent_height if @height > parent_height
		@x = (parent_width - @width) / 2
		@y = (parent_height - @height) / 2
		@win = Curses::Window.new(@height, @width, @y, @x)
	end

	def draw_centered_x(str, y)
		x = (@width - str.length) / 2
		@win.setpos(y, x)
		@win << str
	end

	def draw_centered_y(str, x)
		y = (@width - str.length) / 2
		@win.setpos(y, x)
		@win << str
	end

	def draw
		@win.clear
		@win.box("|", "-")
		@win.refresh
	end

	def hide
		@win.clear
		@win.box(" ", " ", " ")
		@win.refresh
	end

	def close
		@win.close
	end
end

class HelpMenu < Menu
	def draw
		@win.clear
		@win.box("|", "-")
		draw_centered_x("Help", 1)
		["1 - List Commands"].each_with_index do |cmd, i|
			@win.setpos(i + 1, 2)
			@win << cmd
		end
		@win.refresh
		key = Curses.getch
		case key
		when "1" then list_commands
		when "q" then return
		end
	end

	def list_commands
		@win.clear
		@win.box("|", "-")
		["i - show inventory",
		 "p - pickup item",
		 "? - show help menu"].each_with_index do |cmd, i|
			@win.setpos(i + 1, 2)
			@win << cmd
		 end
		 @win.refresh
	end
end

class InventoryMenu < Menu
	def draw(inv)
		@win.clear
		@win.box("|", "-")
		draw_centered_x("Inventory", 1)
		inv.each_with_index do |item, i|
			@win.setpos(i + 3, 2)
			@win << item.name(:article)
		end
		@win.refresh
	end
end
