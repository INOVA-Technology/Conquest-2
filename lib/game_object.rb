class GameObject

	attr_accessor :id

	def initialize
		@image = "@"
	end

	def to_s
		@image
	end

end