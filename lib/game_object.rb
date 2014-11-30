class GameObject

	attr_accessor :permeable, :can_pickup

	alias_method :permeable?, :permeable
	alias_method :can_pickup?, :can_pickup

	def initialize(image)
		@image = image
		@permeable = true
		@can_pickup = false
	end

	def to_s
		@image
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
	end

	def name(option = nil)
		case option
		when :plural then "pizzas"
		when :article then "a pizza"
		else
			"pizza"
			Console.log("Pizza#name: unknown option: #{option.inspect}", true) \
				unless option == nil
		end
	end

end
