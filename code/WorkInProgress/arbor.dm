/obj/machinery/vending/rocketride
	name = "Space Rocket Ride"
	icon_state = "rocket"
	desc = "It's old and smells like vomit."
	acceptcard = 0
	pay = 1
	var/rideactive = 0
	var/mob/living/carbon/human/rider = null
	var/in_bump = 0
	var/sealed_cabin = 0
	rider_visible =	1
	slogan_list = list("Ha ha ha ha ha!",
	"I am the great wizard Zoldorf!",
	"Learn your fate!")

	proc/update()
		if(rider)
			icon_state = "rocket-vend2"
		else
			icon_state = "rocket-vend"

	proc/update_overlays()
		src.overlays.len = 0

	proc/eject_rider(var/crashed, var/selfdismount)
		rider.set_loc(src.loc)
		rider = null
		return

	attack_hand(mob/user as mob)
		if (stat & (NOPOWER|BROKEN))
			return
		var/dat
		if(rideactive)
			dat += "<TT><B>Ride in progress, please wait!</B></TT><BR>"
		else
			dat += "<TT><B>Please insert coin.</B></TT><BR>"
			if(emagged)
				dat += "<BR><B>Available Credits:</B> CREDIT CALCULATION ERROR<BR>"
			else
				dat += "<BR><B>Available Credits:</B> $[src.credit]<BR>"
			dat += "<A href='?src=\ref[src];startride=1'>Start the ride!</A><BR>"
		user << browse("<HEAD><TITLE>Rocket Ride</TITLE></HEAD>[dat]", "window=rocketride")
		onclose(user, "rocketride")
		return

	Topic(href, href_list)
		if(..())
			return

		if (stat & (NOPOWER|BROKEN))
			return

		if (usr.contents.Find(src) || in_range(src, usr) && istype(src.loc, /turf))
			usr.machine = src
			if (href_list["startride"])
				if(!rideactive)
					if((credit < 1)&&(!emagged))
						boutput(usr, "<span style=\"color:red\">Insufficient funds!</span>") // no money? get out
						return
					if(!emagged)
						credit -= 1
					rideactive = 1
					update()
					updateUsrDialog()
					playsound(src.loc, 'sound/machines/rocketride.ogg', 100, 1)
					animate_bumble(rider, floatspeed = 15, Y1 = 2, Y2 = -2)
					sleep(230)

					if (!(stat & (NOPOWER|BROKEN)))
						icon_state = "rocket"

					rideactive = 0
					eject_rider(0, 1)
					src.update_overlays()
			add_fingerprint(usr)
			updateUsrDialog()
		return

/obj/machinery/vending/rocketride/MouseDrop_T(mob/living/carbon/human/target, mob/user)
	if (rider || !istype(target) || target.buckled || LinkBlocked(target.loc,src.loc) || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.paralysis || user.stunned || user.weakened || user.stat || istype(user, /mob/living/silicon/ai))
		return

	var/msg

	if(target == user && !user.stat)	// if drop self, then climbed in
		msg = "[user.name] climbs onto the [src]."
		boutput(user, "<span style=\"color:blue\">You climb onto the [src].</span>")
	else if(target != user && !user.restrained())
		msg = "[user.name] helps [target.name] onto the [src]!"
		boutput(user, "<span style=\"color:blue\">You help [target.name] onto the [src]!</span>")
	else
		return

	for (var/obj/item/I in src)
		I.set_loc(get_turf(src))

	target.set_loc(src)
	rider = target
	rider.pixel_x = 3
	rider.pixel_y = 8
	if(rider.restrained() || rider.stat)
		rider.buckled = src

	for (var/mob/C in AIviewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)

	return

/obj/machinery/vending/rocketride/Click()
	if(!(usr.paralysis || usr.stunned || usr.weakened || usr.stat) && (src.rideactive == 0))
		eject_rider(0, 1)
		src.update_overlays()
	return

/obj/machinery/vending/rocketride/attack_hand(mob/living/carbon/human/M as mob)
	if(!M || !rider)
		..()
		return
	if(src.rideactive == 1)
		boutput(M, "<span style=\"color:red\">You try to lift the lap bar on [src] but it won't budge!</span>")
	return
