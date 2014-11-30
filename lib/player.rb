class Player

	attr_accessor :x, :y, :inventory

	def initialize
		@image = "@"
		@inventory = []
		@health = 15
	end

	def to_s
		@image
	end
end
