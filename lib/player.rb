class Player

	attr_accessor :x, :y, :inventory, :health, :max_health, :money

	def initialize
		@image = "@"
		@inventory = []
		@health = 15
		@max_health = 15
		@money = 0
	end

	def to_s
		@image
	end
end
