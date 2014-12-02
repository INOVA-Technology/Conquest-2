class Player

	attr_accessor :x, :y, :inventory, :health, :max_health

	def initialize
		@image = "@"
		@inventory = []
		@health = 15
		@max_health = 15
	end

	def to_s
		@image
	end
end
