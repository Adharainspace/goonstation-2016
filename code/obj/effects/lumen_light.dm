/obj/effects/lumen_light
	name = ""
	desc = ""
	density = 0
	anchored = 1
	mouse_opacity = 0
	var/datum/light/light
	var/non_turf = 0 //how we tell that this was a reaction on obj or mob
	var/create_time = 0 //for process loop
	var/life_length = 0 //assigned a random value

	New()
		light = new /datum/light/point
		light.attach(src)
		create_time = world.time
		life_length = rand(3000, 6000) //random time from 5 to 10 minutes
		processing_items += src

	proc/process()
		if (world.time >= create_time + life_length)
			qdel(src)

	disposing()
		if (non_turf)
			src.loc = get_turf(src)
			light.attach(src)
		light.dispose()
		light = null
		processing_items -= src
		..()