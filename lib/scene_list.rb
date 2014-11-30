module SceneList

	SCENES = {
		start: Scene.new
	}

	SCENES[:start].add_object(Pizza.new, 3, 3)

	SCENES[:start].add_object(Wall.new(:h), 5, 5)
	SCENES[:start].add_object(Wall.new(:h), 6, 5)
	SCENES[:start].add_object(Wall.new(:h), 7, 5)
	SCENES[:start].add_object(Wall.new(:h), 8, 5)
	SCENES[:start].add_object(Wall.new(:h), 9, 5)
	SCENES[:start].add_object(Wall.new(:h), 10, 5)

	SCENES[:start].add_object(Wall.new(:v), 10, 6)
	SCENES[:start].add_object(Door.new, 10, 7)
	SCENES[:start].add_object(Wall.new(:v), 10, 8)
	SCENES[:start].add_object(Wall.new(:v), 10, 9)
	
	SCENES[:start].add_object(Wall.new(:h), 10, 10)
	SCENES[:start].add_object(Wall.new(:h), 9, 10)
	SCENES[:start].add_object(Wall.new(:h), 8, 10)
	SCENES[:start].add_object(Wall.new(:h), 7, 10)
	SCENES[:start].add_object(Wall.new(:h), 6, 10)
	SCENES[:start].add_object(Wall.new(:h), 5, 10)

	SCENES[:start].add_object(Wall.new(:v), 5, 9)
	SCENES[:start].add_object(Wall.new(:v), 5, 8)
	SCENES[:start].add_object(Wall.new(:v), 5, 7)
	SCENES[:start].add_object(Wall.new(:v), 5, 6)

	# example:
	# SCENES[:start].directions = { e: :test }

end
