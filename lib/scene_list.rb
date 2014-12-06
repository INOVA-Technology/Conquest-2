module SceneList

	SCENES = {
		start: Scene.load_from_file("scenes/start"),
		path: Scene.load_from_file("scenes/path")
	}

	# example:
	SCENES[:start].directions = { n: :path }
	SCENES[:path].directions = { s: :start }

end
