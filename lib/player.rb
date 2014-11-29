class Player

	attr_accessor :x, :y, :inventory

	def initialize
		@image = "@"
		@inventory = []
	end

	def to_s
		@image
	end
end
