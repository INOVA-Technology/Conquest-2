class Menu

	def initialize(width, height, x, y)
		@width = width
		@height = height
		@x = x
		@y = y
		@win = Curses::Window.new(@height, @width, @y, @x)
	end

	def draw
		@win.clear
		@win.box("|", "-")
		@win.refresh
	end

	def close
		@win.clear
		@win.box(" ", " ", " ")
		@win.refresh
		@win.close
	end
end

class HelpMenu < Menu
end

class InventoryMenu < Menu
	def draw(inv)
		@win.clear
		@win.box("|", "-")
		inv.each_with_index do |item, i|
			@win.setpos(i + 1, 2)
			@win << item.name(:article)
		end
		@win.setpos(1, 1)
		@win << 
		@win.refresh
	end
end
