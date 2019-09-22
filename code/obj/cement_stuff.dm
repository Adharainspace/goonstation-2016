/turf/simulated/floor/concrete
	name = "concrete floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "concrete"

/turf/space/fluid //add override for attack_object w/ reagent containers to scoop SiO2
	name = "seafloor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "mars1"

/obj/item/seashell //placeholder for seashells, add the stuff in New() to seashells please
	name = "seashell"
	icon = 'icons/obj/decals.dmi'
	icon_state = "seashell"

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(10)
		reagents = R
		R.my_atom = src
		R.add_reagent("calcium_carbonate", 10)

/obj/concrete_wet
	name = "wet concrete"
	icon = 'icons/effects/effects.dmi'
	icon_state = "concrete_wet"
	opacity = 0
	anchored = 1
	density = 0
	layer = OBJ_LAYER + 0.9
	var/health = 4
	var/c_quality = 0
	var/created_time = 0

	New()
		..()
		created_time += world.time
		processing_items += src

	proc/process()
		if (world.time >= created_time + 150) //15secs
			flick("concrete_drying", src)
			var/obj/concrete_wall/C = new(get_turf(src))
			C.update_strength(c_quality)
			qdel(src)

	disposing()
		processing_items -= src
		..()

/*	CanPass(atom/A, turf/T)
		if (ismob(A))
			if (istype(A, mob/
			A.slowed += 2*/

	attack_hand(var/mob/user)
		if (health <= 0)
			user.visible_message("<span style=\"color:red\">[user] breaks apart the lump of wet concrete with their bare hands!</span>")
			return
		health--
		if (health <= 0)
			user.visible_message("<span style=\"color:red\">[user] breaks apart the lump of wet concrete with their bare hands!</span>")
			return
		user.visible_message("<span style=\"color:red\">[user] hits the hunk of wet concrete! It looks a bit less sturdy now.</span>")

	attackby(var/obj/item/I, var/mob/user)
		if (health <= 0)
			user.visible_message("<span style=\"color:red\">[user] breaks apart the lump of wet concrete!!</span>")
			return
		health -= 2
		if (health <= 0)
			user.visible_message("<span style=\"color:red\">[user] breaks apart the lump of wet concrete!</span>")
			return
		user.visible_message("<span style=\"color:red\">[user] hits the hunk of wet concrete! It looks a lot less sturdy now.</span>")

/obj/concrete_wall
	name = "concrete wall"
	icon = 'icons/effects/effects.dmi'
	icon_state = "concrete"
	density = 1
	opacity = 0 	// changed in New()
	anchored = 1
	name = "concrete wall"
	desc = "A heavy duty wall made of concrete! This thing is gonna take some manual labour to get through..."
	flags = FPRINT | CONDUCT | USEDELAY
	var/strength = 0 // 1=poor, 2=ok, 3=good, 4=perfect
	var/health = 3 //3, 6, 9, 12 health
	var/max_health = 0 //description purposes

	New()
		..()

		if(istype(loc, /turf/space))
			loc:ReplaceWithConcreteFloor()

		update_nearby_tiles(1)
		spawn(1)
			RL_SetOpacity(1)

	disposing()
		RL_SetOpacity(0)
		density = 0
		update_nearby_tiles(1)
		..()

	proc/update_strength(var/quality)
		if(quality)
			strength = quality
			health *= strength
			max_health = health

	ex_act(severity)
		dispose()

	attack_hand(var/mob/user)
		if (user.bioHolder.HasEffect("hulk") && (prob(100 - strength*20)))
			user.visible_message("<span style=\"color:red\">[user] smashes through the concrete wall! Woah!</span>")
			dispose()
		else
			boutput(user, "<span style=\"color:red\">You hit the concrete wall and really hurt your hand!</span>")
			random_brute_damage(user, 5)
		return

	attackby(var/obj/item/I, var/mob/user)
		if (health <= 0)
			user.visible_message( "<span style=\"color:red\">[user] smashes through the concrete wall.</span>", "<span style=\"color:blue\">You smash through the concrete wall with \the [I].</span>")
			dispose()
			return
		health = health*10 - I.force
		if (health <= 0)
			user.visible_message( "<span style=\"color:red\">[user] smashes through the concrete wall.</span>", "<span style=\"color:blue\">You smash through the concrete wall with \the [I].</span>")
			dispose()
			return
		boutput(user, "<span style=\"color:blue\">You hit the concrete wall and it cracks a little under the assault.</span>")

	proc/update_nearby_tiles(need_rebuild)
		var/turf/simulated/source = loc
		if (istype(source))
			return source.update_nearby_tiles(need_rebuild)

		return 1

	get_desc()
		if (max_health / health == 1)
			. += "The wall is in perfect condition!"
			return
		if (max_health / health >= 0.75)
			. += "The wall is showing some wear and tear."
			return
		if (max_health / health >= 0.5)
			. += "The wall is starting to look worse for the wear."
			return
		if (max_health / health >= 0.25)
			. += "The wall has suffered some major damage!"
			return
		if (max_health / health >= 0)
			. += "The wall is almost in pieces!"
			return