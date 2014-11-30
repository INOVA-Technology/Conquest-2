module SceneList

	SCENES = {
		start: Scene.new
	}

	SCENES[:start].add_object(Pizza.new, 3, 3)

	# example:
	# SCENES[:start].directions = { e: :test }

end
