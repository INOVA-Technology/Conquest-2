class GameObject

	attr_accessor :permeable

	def initialize(image)
		@image = image
		@permeable = true
	end

	def to_s
		@image
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