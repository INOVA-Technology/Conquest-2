class Player

	attr_accessor :x, :y

	def initialize
		@image = "@"
	end

	def to_s
		@image
	end
end