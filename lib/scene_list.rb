module SceneList

	SCENES = {
		garden: Scene.load_from_file("scenes/garden"),
		path: Scene.load_from_file("scenes/path"),
		#start
		start: Scene.load_from_file("scenes/start"),
		start_east: Scene.load_from_file("scenes/start_east"),
		farm: Scene.load_from_file("scenes/farm")
	}

	SCENES[:start].directions = { n: :path, e: :start_east }
	SCENES[:start_east].directions = { w: :start, e: :farm }
	SCENES[:farm].directions = { w: :start_east }
	SCENES[:path].directions = { s: :start, n: :garden }
	SCENES[:garden].directions = { s: :path }

end
