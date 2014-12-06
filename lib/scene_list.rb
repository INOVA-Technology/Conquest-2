module SceneList

	SCENES = {
		start: Scene.load_from_file("scenes/start"),
		path: Scene.load_from_file("scenes/path"),
		garden: Scene.load_from_file("scenes/garden")
	}

	SCENES[:start].directions = { n: :path }
	SCENES[:path].directions = { s: :start, n: :garden }
	SCENES[:garden].directions = { s: :path }

end
