class GameObject

	attr_accessor :permeable

	alias_method :permeable?, :permeable

	def initialize(image)
		@image = image
		@permeable = true
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
				else
					Console.log("Wall::new: invalid direction: #{direction.inspect}")
					"|"
				end
		super(image)
		@permeable = false
	end
end

class Door < GameObject
	def initialize
		super(".")
	end
end

class Food < GameObject

	def initialize(image, health)
		super(image)
		@health = health
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
