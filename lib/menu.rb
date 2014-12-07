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
		@line_count = 0
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
		@line_count = 0
		@win.clear
		draw_text
		@win.box("|", "-")
		@win.refresh
	end

	def show
		draw
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

	def draw_text
	end

	def scroll_down
		return unless @line_count + @scroll_level > @height - 2
		@scroll_level -= 1
		draw
	end

	def scroll_up
		return if @scroll_level == 0
		@scroll_level += 1
		draw
	end

	def hide
		@scroll_level = 0
		@win.clear
		@win.box(" ", " ", " ")
		@win.refresh
	end

	def title(da_title)
		draw_centered_x(da_title, @scroll_level + 1)
		@line_count += 1
	end

	def draw_list(list, y)
		list.each_with_index do |cmd, i|
			y_pos = i + y + @scroll_level
			next if y_pos < 0
			@win.setpos(y_pos, 2)
			@win << cmd
		end
		@line_count += list.length
	end

	def close
		@win.close
	end
end

class HelpMenu < Menu
	def draw_text
		title("Help")
		list = ["1 - List Commands"]
		draw_list(list, 2)
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
	def draw_text
		cmds = ["i - show inventory",
				"p - pickup item",
				"? - show help menu"]
		draw_list(cmds, 1)
	end
end

class InventoryMenu < Menu

	attr_accessor :inventory

	def draw_text
		@du_hash = {}
		title("Inventory")
		letter = "a"
		duh = @inventory.group_by { |i| i.name }
		duh = duh.map do |name, items|
			which = :article
			unless items.one?
				which = :plural
				idk = "#{items.count} "
			end
			idk = "#{letter} - #{idk}#{items[0].name(which)}"
			@du_hash[letter] = items
			letter.next!
			idk
		end
		draw_list(duh, 2)
	end

	def extra_keys(key)
		actions = {}
		if @du_hash[key]
			item = @du_hash[key].first
			actions[:menu] = :item_actions
			actions[:menu_item] = item
		end
		actions
	end
end

class ItemActionsMenu < Menu

	attr_accessor :item

	def draw_text
		title(@item.name)
		duh = @item.actions.map do |key, (text, _)|
			"#{key} - #{text}"
		end
		draw_list(duh, 2)
	end

	def extra_keys(key)
		actions = {}
		if @item.actions[key]
			actions[:item_action] = [@item, @item.actions[key][1]]
		end
		actions
	end

end
