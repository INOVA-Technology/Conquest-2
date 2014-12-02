class GameObject

	attr_accessor :permeable, :can_pickup, :actions, :description

	alias_method :permeable?, :permeable
	alias_method :can_pickup?, :can_pickup

	def initialize(image)
		@image = image
		@permeable = true
		@can_pickup = false
		@names = ["", "", ""]
		@actions = { "i" => ["Inspect", :inspect] }
		@description = "Hm... What is this?"
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

class Shrubbery < GameObject
	def initialize
		super("%")
		@can_pickup = true
		@names = ["shrubbery", "a shrubbery", "shrubberies"]
		@description = "This shrubbery looks nice, and not too expensive."
	end
end
