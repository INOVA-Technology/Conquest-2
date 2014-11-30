class Menu

	def initialize(width, height, parent_width, parent_height)
		@width = width
		@height = height
		@width = parent_width if @width > parent_width
		@height = parent_height if @height > parent_height
		@x = (parent_width - @width) / 2
		@y = (parent_height - @height) / 2
		@win = Curses::Window.new(@height, @width, @y, @x)
		@scroll_level = 0
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

	def draw_pt0
		@win.clear
		draw
		@win.box("|", "-")
		@win.refresh
	end

	def show
		draw_pt0
		handle_keys
	end

	def handle_keys
		key = Curses.getch
		if key == 258
			scroll_down
		elsif key == 259
			scroll_up
		else
			return extra_keys(key)
		end
		handle_keys
	end

	def extra_keys(key)
		{}
	end

	def draw
	end

	def scroll_down
		@scroll_level -= 1
		draw_pt0
	end

	def scroll_up
		return if @scroll_level == 0
		@scroll_level += 1
		draw_pt0
	end

	def hide
		@scroll_level = 0
		@win.clear
		@win.box(" ", " ", " ")
		@win.refresh
	end

	def title(da_title)
		draw_centered_x(da_title, @scroll_level + 1)
	end

	def close
		@win.close
	end
end

class HelpMenu < Menu
	def draw
		title("Help")
		["1 - List Commands"].each_with_index do |cmd, i|
			@win.setpos(i + 2 + @scroll_level, 2)
			@win << cmd
		end
	end

	def extra_keys(key)
		actions = {}
		case key
		when "1"
			actions[:menu] = :commands
		end
		actions
	end

end

class CommandsMenu < Menu
	def draw
		["i - show inventory",
		 "p - pickup item",
		 "? - show help menu"].each_with_index do |cmd, i|
			@win.setpos(i + 1 + @scroll_level, 2)
			@win << cmd
		 end
	end
end

class InventoryMenu < Menu

	attr_accessor :inventory

	def draw
		title("Inventory")
		@inventory.each_with_index do |item, i|
			@win.setpos(i + @scroll_level + 2, 2)
			@win << item.name(:article)
		end
	end

end
