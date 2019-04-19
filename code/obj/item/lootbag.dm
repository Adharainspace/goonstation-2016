//obj/item/pocket_locker
	name = "pocket locker"
	desc = "A marvel in modern space technology. Smells slightly like embalming fluid."
	icon = 'icons/obj/large_storage.dmi'
	icon_state = "pocketlocker"
	flags = FPRINT
	w_class = 1.0
	force = 0
	throwforce = 1.0
	throw_speed = 4
	throw_range = 20
	stamina_damage = 0
	stamina_cost = 0
	stamina_crit_chance = 0
	density = 0
	var/open = 0
	var/image/open_image = null
	var/sound_zipper = 'sound/machines/click.ogg'

	disposing()
		for(var/atom/movable/AM in src)
			AM.set_loc(src.loc)
		..()

	proc/update_icon()
		if (src.open)
			src.icon_state = "open"
			src.w_class = 4.0
			src.density = 0
		else if (!src.open)
			if (src.contents && src.contents.len)
				src.icon_state = "closed"
			else
				src.icon_state = "closed"
			src.w_class = 4.0
			src.density = 1
		else
			src.icon_state = "pocketlocker"
			src.w_class = 1.0
			src.density = 0

	attack_self(mob/user as mob)
		if (src.icon_state == "pocketlocker" && src.w_class == 1.0)
			user.visible_message("<b>[user]</b> unzips [src].",\
			"You unzip [src].")
			user.drop_item()
			src.update_icon()
		else
			return

	attack_hand(mob/user as mob)
		add_fingerprint(user)
		if (src.icon_state == "pocketlocker" && src.w_class == 1.0)
			return ..()
		else
			if (src.open)
				src.close()
			else
				src.open()
			return

	relaymove(mob/user as mob)
		if (user.stat)
			return
		if (prob(75))
			user.show_text("You fuss with [src], trying to find the zipper, but it's no use!", "red")
			for (var/mob/M in hearers(src, null))
				M.show_text("<FONT size=[max(0, 5 - get_dist(src, M))]>...rustle...</FONT>")
			return
		src.open()
		src.visible_message("<span style=\"color:red\"><b>[user]</b> unzips themselves from [src]!</span>")

	MouseDrop(mob/user as mob)
		..()
		if (!(src.contents && src.contents.len) && (usr == user && !usr.restrained() && !usr.stat && in_range(src, usr) && !issilicon(usr)))
			if (src.icon_state != "pocketlocker")
				usr.visible_message("<b>[usr]</b> folds up [src].",\
				"You fold up [src].")
			src.overlays -= src.open_image
			src.icon_state = "pocketlocker"
			src.w_class = 1.0
			src.density = 0
			src.attack_hand(usr)

	proc/open()
		playsound(src.loc, src.sound_zipper, 100, 1, , 6)
		for (var/obj/O in src)
			O.set_loc(get_turf(src))
		for (var/mob/M in src)
			spawn(3)
				M.set_loc(get_turf(src))
		src.open = 1
		src.update_icon()

	proc/close()
		playsound(src.loc, src.sound_zipper, 100, 1, , 6)
		for (var/obj/O in get_turf(src))
			if (O.density || O.anchored || O == src)
				continue
			O.set_loc(src)
		for (var/mob/M in get_turf(src))
			if (M.anchored || M.buckled)
				continue
			M.set_loc(src)
		src.open = 0
		src.update_icon()


//obj/item/clothing/ears/yetimuffs
	name = "yeti's earmuffs"
	icon_state = "yetimuffs"
	protective_temperature = 1500
	item_state = "yetimuffs"
	desc = "Made from free-range yetis fed only with non-GMO skiers."
	block_hearing = 1

///obj/item/clothing/gloves/titanring
	name = "Titan's Ring"
	desc = "\"DO NOT TOUCH PROPERTY OF TITAN\" is etched on the inside. Who knows who that is."
	icon_state = "titanring"
	item_state = "titanring"
	hide_prints = 0
	equipped(var/mob/user, var/slot)
		var/mob/living/carbon/human/H = user
		H.bioHolder.AddEffect("hulk")
	unequipped(var/mob/user, var/slot)
		var/mob/living/carbon/human/H = user
		H.bioHolder.RemoveEffect("hulk")

//obj/item/clothing/under/gimmick/frog
	name = "frog jumpsuit"
	desc = "This jumpsuit calls to question your sense of belonging."
	icon_state = "frog"
	item_state = "frog"
	equipped(var/mob/user, var/slot)
		var/mob/living/carbon/human/H = user
		H.bioHolder.AddEffect("jumpy")
	unequipped(var/mob/user, var/slot)
		var/mob/living/carbon/human/H = user
		H.bioHolder.RemoveEffect("jumpy")