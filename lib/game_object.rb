class GameObject

	attr_accessor :permeable, :can_pickup, :actions, :description, :color

	alias_method :permeable?, :permeable
	alias_method :can_pickup?, :can_pickup

	def initialize(image)
		@image = image
		@permeable = true
		@can_pickup = false
		@names = ["", "", ""]
		@actions = { "i" => ["Inspect", :inspect] }
		@description = "Hm... What is this?"
		@color = nil
	end

	def to_s
		@image
	end

	def name(option = nil)
		case option
		when :article then @names[1]
		when :plural then @names[2]
		else
			Console.log("#{self.class}#name: unknown option: #{option.description}") \
				unless option == nil
			@names[0]
		end
	end

end

class Wall < GameObject
	def initialize(direction)
		image = case direction
				when :horizontal, :h then "-"
				when :vertical, :v then "|"
				when :topleft, :tl then "┌"
				when :topright, :tr then "┐"
				when :bottomright, :br then "┘"
				when :bottomleft, :bl then "└"
				else
					Console.log("Wall::new: invalid direction: #{direction.description}")
					"|"
				end
		super(image)
		@permeable = false
		@description = "A wall? How'd you get this? Please file a bug here: http://goo.gl/3IdtND"
	end
end

class Path < GameObject
	def initialize
		super("░")
	end
end

class Food < GameObject

	attr_accessor :health

	def initialize(image, health)
		super(image)
		@health = health
		@can_pickup = true
		@actions["e"] = ["Eat", :eat]
	end
end

class Pizza < Food
	def initialize
		super("∆", 10)
		@names = ["pizza", "a pizza", "pizzas"]
		@description = "This pizza looks good! Wait, is that bacon on it!?"
	end
end

class Pretzel < Food
	def initialize
		super("⌘", 4)
		@names = ["pretzel", "a pretzel", "pretzels"]
		@description = "This is a nice salted hot pretzel."
	end
end

class Shrubbery < GameObject
	def initialize
		super("%")
		@color = Curses::COLOR_GREEN
		@can_pickup = true
		@names = ["shrubbery", "a shrubbery", "shrubberies"]
		@description = "This shrubbery looks nice, and not too expensive."
	end
end

class Bush < GameObject
	def initialize
		super("#")
		@permeable = false
		@color = Curses::COLOR_GREEN
	end
end

class Rose < GameObject
	def initialize
		super("¥")
		@can_pickup = true
		@names = ["rose", "a rose", "roses"]
		@description = "A lovely rose."
		@color = Curses::COLOR_YELLOW
	end
end

class Shamrock < GameObject
	def initialize
		super("•")
		@can_pickup = true
		if rand(1..100) == 1
			@leaves = 4
			@description = "Wow! A four leaf clover! This could come in handy..."
			@names = ["four leaf clover", "a four leaf clover", "four leaf clovers"]
		else
			@leaves = 3
			@description = "It's a shamrock! Too bad it only has 3 leaves."
			@names = ["three leaf clover", "a three leaf clover", "three leaf clovers"]
		end
		@color = Curses::COLOR_GREEN
	end
end

class Flower < GameObject
	def initialize
		super("*")
		@can_pickup = true
		@names = ["flower", "a flower", "flowers"]
		@description = "A lovely flower."
		@color = Curses::COLOR_RED
	end
end

class Carrot < Food
	def initialize
		super("^", 5)
		@names = ["carrot", "a carrot", "carrots"]
		@description = "A carrot."
		@color = Curses::COLOR_YELLOW
	end
end