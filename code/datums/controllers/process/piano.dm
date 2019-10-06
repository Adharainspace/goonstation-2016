/datum/controller/process/piano
	setup()
		name = "Piano"
		schedule_interval = 5 //note interval?

	doWork()
		for (var/obj/player_piano/p in global.all_player_pianos)
			p.play_notes()