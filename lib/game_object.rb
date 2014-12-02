class GameObject

	attr_accessor :permeable, :can_pickup, :actions, :inspect

	alias_method :permeable?, :permeable
	alias_method :can_pickup?, :can_pickup

	def initialize(image)
		@image = image
		@permeable = true
		@can_pickup = false
		@names = ["", "", ""]
		@actions = { "e" => ["Inspect", :inspect] }
		@inspect = "Hm... What is this?"
	end

	def to_s
		@image
	end

	def name(option = nil)
		case option
		when :article then @names[1]
		when :plural then @names[2]
		else
			Console.log("#{self.class}#name: unknown option: #{option.inspect}") \
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
					Console.log("Wall::new: invalid direction: #{direction.inspect}")
					"|"
				end
		super(image)
		@permeable = false
	end
end

class Food < GameObject
	def initialize(image, health)
		super(image)
		@health = health
		@can_pickup = true
	end
end

class Pizza < Food
	def initialize
		super("∆", 10)
		@names = ["pizza", "a pizza", "pizzas"]
		@inspect = "This pizza looks good! Wait, is that bacon on it!?"
	end
end

class Shrubbery < GameObject
	def initialize
		super("%")
		@can_pickup = true
		@names = ["shrubbery", "a shrubbery", "shrubberies"]
		@inspect = "This shrubbery looks nice, and not too expensive."
	end
end
