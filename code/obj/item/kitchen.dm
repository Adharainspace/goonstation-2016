/*
CONTAINS:

CUTLERY
MISC KITCHENWARE
*/

/obj/item/kitchen
	icon = 'icons/obj/kitchen.dmi'

/obj/item/kitchen/rollingpin
	name = "rolling pin"
	icon_state = "rolling_pin"
	inhand_image_icon = 'icons/mob/inhand/hand_food.dmi'
	force = 8.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 7
	w_class = 3.0
	desc = "A wooden tube, used to roll dough flat in order to make various edible objects. It's pretty sturdy."
	stamina_damage = 40
	stamina_cost = 15
	stamina_crit_chance = 2

/obj/item/kitchen/utensil
	inhand_image_icon = 'icons/mob/inhand/hand_food.dmi'
	force = 5.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	flags = FPRINT | TABLEPASS | CONDUCT
	stamina_damage = 5
	stamina_cost = 10
	stamina_crit_chance = 15

	New()
		if (prob(60))
			src.pixel_y = rand(0, 4)
		return

/obj/item/kitchen/utensil/fork
	name = "fork"
	icon_state = "fork"
	hit_type = DAMAGE_STAB
	hitsound = 'sound/effects/bloody_stab.ogg'
	desc = "A multi-pronged metal object, used to pick up objects by piercing them. Helps with eating some foods."

	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if (user && user.bioHolder.HasEffect("clumsy") && prob(50))
			user.visible_message("<span style=\"color:red\"><b>[user]</b> fumbles [src] and stabs \himself.</span>")
			random_brute_damage(user, 10)
		if (!saw_surgery(M,user)) // it doesn't make sense, no. but hey, it's something.
			return ..()

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] stabs [src] right into \his heart!</b></span>")
		blood_slash(user, 25)
		playsound(user.loc, src.hitsound, 50, 1)
		user.TakeDamage("chest", 150, 0)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

/obj/item/kitchen/utensil/knife
	name = "knife"
	icon_state = "knife"
	hit_type = DAMAGE_CUT
	hitsound = 'sound/weapons/slashcut.ogg'
	force = 10.0
	throwforce = 10.0
	desc = "A long bit metal that is sharpened on one side, used for cutting foods. Also useful for butchering dead animals. And live ones."

	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if (user && user.bioHolder.HasEffect("clumsy") && prob(50))
			user.visible_message("<span style=\"color:red\"><b>[user]</b> fumbles [src] and cuts \himself.</span>")
			random_brute_damage(user, 20)
		if (!scalpel_surgery(M,user))
			return ..()

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] slashes \his own throat with [src]!</b></span>")
		blood_slash(user, 25)
		user.TakeDamage("head", 150, 0)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

/obj/item/kitchen/utensil/spoon
	name = "spoon"
	desc = "A metal object that has a handle and ends in a small concave oval. Used to carry liquid objects from the container to the mouth."
	icon_state = "spoon"

	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if (user && user.bioHolder.HasEffect("clumsy") && prob(50))
			user.visible_message("<span style=\"color:red\"><b>[user]</b> fumbles [src] and jabs \himself.</span>")
			random_brute_damage(user, 5)
		if (!spoon_surgery(M,user))
			return ..()

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] jabs [src] straight through \his eye and into \his brain!</b></span>")
		blood_slash(user, 25)
		playsound(user.loc, src.hitsound, 50, 1)
		user.TakeDamage("head", 150, 0)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

/obj/item/kitchen/food_box // I came in here just to make donut/egg boxes put the things in your hand when you take one out and I end up doing this instead, kill me. -haine
	name = "food box"
	desc = "A box that can hold food! Well, not this one, I mean. You shouldn't be able to see this one."
	icon = 'icons/obj/foodNdrink/food_related.dmi'
	icon_state = "donutbox"
	amount = 6
	var/box_type = "donutbox"
	var/contained_food = /obj/item/reagent_containers/food/snacks/donut
	var/contained_food_name = "donut"

	donut_box
		name = "donut box"
		desc = "A box for containing and transporting \"dough-nuts\", a popular ethnic food."

	egg_box
		name = "egg carton"
		desc = "A carton that holds a bunch of eggs. What kind of eggs? What grade are they? Are the eggs from space? Space chicken eggs?"
		icon_state = "eggbox"
		amount = 12
		box_type = "eggbox"
		contained_food = /obj/item/reagent_containers/food/snacks/ingredient/egg
		contained_food_name = "egg"

	lollipop
		name = "lollipop bowl"
		desc = "A little bowl of sugar-free lollipops, totally healthy in every way! They're medicinal, after all!"
		icon_state = "lpop8"
		amount = 8
		box_type = "lpop"
		contained_food = /obj/item/reagent_containers/food/snacks/lollipop
		contained_food_name = "lollipop"

	New()
		..()
		spawn(10)
			if (!ispath(src.contained_food))
				logTheThing("debug", src, null, "has a non-path contained_food, \"[src.contained_food]\", and is being disposed of to prevent errors")
				qdel(src)
				return

	get_desc(dist)
		if (dist <= 1)
			. += "There's [(src.amount > 0) ? src.amount : "no" ] [src.contained_food_name][s_es(src.amount)] in \the [src]."

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, src.contained_food))
			user.drop_item()
			W.set_loc(src)
			src.amount ++
			boutput(user, "You place \the [src.contained_food_name] back into \the [src].")
			src.update()
		else return ..()

	MouseDrop(mob/user as mob) // no I ain't even touchin this mess it can keep doin whatever it's doin
		if ((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
			if (usr.hand)
				if (!( usr.l_hand ))
					spawn( 0 )
						src.attack_hand(usr, 1, 1)
						return
			else
				if (!( usr.r_hand ))
					spawn( 0 )
						src.attack_hand(usr, 0, 1)
						return
		return

	attack_hand(mob/user as mob, unused, flag)
		if (flag)
			return ..()
		src.add_fingerprint(user)
		var/obj/item/reagent_containers/food/snacks/myFood = locate(src.contained_food) in src
		if (myFood)
			if (src.amount >= 1)
				src.amount--
			user.put_in_hand_or_drop(myFood)
			boutput(user, "You take \an [src.contained_food_name] out of \the [src].")
		else
			if (src.amount >= 1)
				src.amount--
				var/obj/item/reagent_containers/food/snacks/newFood = new src.contained_food(src.loc)
				user.put_in_hand_or_drop(newFood)
				boutput(user, "You take \an [src.contained_food_name] out of \the [src].")
		src.update()

	proc/update()
		src.icon_state = "[src.box_type][src.amount]"
		return

/obj/item/plate
	name = "plate"
	desc = "It's like a frisbee, but more dangerous!"
	icon = 'icons/obj/foodNdrink/food_related.dmi'
	icon_state = "plate"
	item_state = "zippo"
	throwforce = 3.0
	throw_speed = 3
	throw_range = 8
	force = 2
	rand_pos = 0

/obj/item/plate/attack(mob/M as mob, mob/user as mob)
	if (user.a_intent == INTENT_HARM)
		if (M == user)
			boutput(user, "<span style=\"color:red\"><B>You smash the plate over your own head!</b></span>")
		else
			M.visible_message("<span style=\"color:red\"><B>[user] smashes [src] over [M]'s head!</B></span>")
			logTheThing("combat", user, M, "smashes [src] over %target%'s head! ")
		random_brute_damage(M, force)
		M.weakened += rand(0,2)
		M.updatehealth()
		playsound(src, "shatter", 70, 1)
		var/obj/O = new /obj/item/raw_material/shard/glass(get_turf(M))
		if (src.material)
			O.setMaterial(copyMaterial(src.material))
		qdel(src)
	else
		M.visible_message("<span style=\"color:red\">[user] taps [M] over the head with [src].</span>")
		logTheThing("combat", user, M, "taps %target% over the head with [src].")

/obj/item/tray //this is the big boy
	name = "serving tray"
	desc = "It's a big flat tray for serving food upon."
	icon = 'icons/obj/foodNdrink/food_related.dmi'
	icon_state = "tray"
	throwforce = 3.0 //these values could use some tweaking if theyre too powerful
	throw_speed = 3 //same as these
	throw_range = 5 //these too
	force = 8 //this too maybe? sorry
	var/list/tray_contents = list()
	var/old_desc = null
	var/new_desc = null
	var/y_counter = 0
	var/y_mod = 0
	var/tray_health = 6 //the number of times you can smash someone over the head with the tray before it breaks

	proc/add_contents(var/obj/item/W)
		tray_contents += W

	proc/remove_contents(var/obj/item/W)
		tray_contents -= W

	proc/update_icon()
		for (var/i = 1, i <= tray_contents.len, i++)
			var/obj/item/F = tray_contents[i]
			var/image/I = SafeGetOverlayImage("food_[i]", F.icon, F.icon_state)
			I.transform *= 0.5
			if (i % 2)
				I.pixel_x = -8
			else
				I.pixel_x = 8
			y_counter++
			if (y_counter == 3)
				y_mod++
				y_counter = 1
			I.pixel_y = y_mod * 2
			I.layer = src.layer + 0.1
			src.UpdateOverlays(I, "food_[i]", 0, 1)
		for (var/i = tray_contents.len + 1, i <= src.overlays.len, i++)
			src.ClearSpecificOverlays("food_[i]")
		y_counter = 0
		y_mod = 0
		return

	proc/shit_goes_everywhere(var/turf/T)
		if (!T)
			T = src.loc
		if (ismob(T))
			T = get_turf(T)
		if (!T)
			qdel(src)
			return

		T.visible_message("<span style=\"color:red\">Everything on \the [src] goes flying!</span>")
		var/list/nearby_turfs = list()
		for (T in view(5,src))
			nearby_turfs += T

		while (tray_contents.len > 0)
			var/obj/item/F = tray_contents[1]
			src.remove_contents(F)
			src.update_icon()
			F.set_loc(src.loc)
			F.throw_at(pick(nearby_turfs), 16, 3)

	throw_impact(var/turf/T)
		..()
		if(tray_contents.len == 0)
			return
		src.shit_goes_everywhere(T)

	attackby(obj/item/W as obj, mob/user as mob)
		if (!W.edible)
			boutput(user, "[W] isn't food, That doesn't belong on \the [src]!")
			return
		if (tray_contents.len == 30)
			boutput(user, "That won't fit, \the [src] is too full!")
			return
		user.drop_item()
		W.set_loc(src)
		src.add_contents(W)
		src.update_icon()
//		src.build_desc()
		boutput(user, "You put [W] on \the [src]")

	attack_self(mob/user as mob)
		if (tray_contents.len == 0)
			boutput(user, "There's no food to take off of \the [src]!")
			return
		var/food_sel = input(user, "Which food?", "Tray Contents") as null|anything in tray_contents
		if (!food_sel)
			return
		user.put_in_hand_or_drop(food_sel)
		src.remove_contents(food_sel)
		src.update_icon()
//		src.build_desc()
		boutput(user, "You take \the [food_sel] off of \the [src].")

	attack(mob/M as mob, mob/user as mob)
		if (user.a_intent == INTENT_HARM)
			if (M == user)
				boutput(user, "<span style=\"color:red\"><B>You bash yourself in the face with \the [src]!</b></span>")
			else
				M.visible_message("<span style=\"color:red\"><B>[user] bashes [M] over the head with \the [src]!</B></span>")
				logTheThing("combat", user, M, "smashes \the [src] over %target%'s head! ")
			user.drop_item(src)
			if(tray_contents.len > 0)
				src.shit_goes_everywhere(get_turf(src))
			random_brute_damage(M, force)
			M.weakened += rand(0,2)
			M.updatehealth()
			playsound(src, 'sound/weapons/trayhit.ogg', 50, 1)
			if (tray_health == 0)
				src.visible_message("The tray shatters!")
				qdel(src)
			tray_health--
			src.visible_message("The tray looks a little less sturdy...")
		else
			M.visible_message("<span style=\"color:red\">[user] bops [M] over the head with \the [src].</span>")
			logTheThing("combat", user, M, "taps %target% over the head with [src].")

	attack_hand(mob/user as mob)
		..()
		src.update_icon()

	dropped(mob/user as mob)
		..()
		if(tray_contents.len == 0)
			return
		user.visible_message("[user] drops \the [src] on the ground!")
		src.shit_goes_everywhere(get_turf(src))

/*	proc/build_desc() //this is a mess and doesnt work
		if (old_desc) //remove old desc from the description
			src.desc -= old_desc
		if (tray_contents.len == 0) //if the tray's empty, set the empty description
			new_desc = "There's nothing on \the [src]!"
			old_desc = new_desc
			src.desc = new_desc
			return
		new_desc = "[src] has " //set the start of the sentence
		for (var/i = 1, i <= tray_contents.len, i++) //loop through the list
			var/obj/item/F = tray_contents[i]
			if(i == tray_contents.len) //if its at the last element, cap off the sentence
				new_desc += "and \an [F]."
			else
				new_desc += "\an [F], " //otherwise, keep building the sentence normally
		old_desc = new_desc //set old desc so we can clear it next time we need to redo the description
		src.desc += new_desc
		return

	New()
		src.build_desc()*/

/*	attackby(obj/item/W as obj, mob/user as mob)
		if (!W.edible)
			boutput(user, "[W] isn't food! That doesn't belong on \the [src]")
			return
		if (!food1)
			food1 = image(W.icon, "")
			food1.icon_state = "[W.icon_state]"
			food1.pixel_x = -8
			user.drop_item()
			W.set_loc(src)
			food_in_tray += food1
			src.UpdateOverlays(food1, 1)
			src.desc += " The [src] has \an [W] on it."
			return
		if (food1 && !food2)
			food2 = image(W.icon, "")
			food2.icon_state = "[W.icon_state]"
			food2.pixel_x = 8
			user.drop_item()
			W.set_loc(src)
			food_in_tray += food2
			src.UpdateOverlays(food2, 2)
			src.desc += " The [src] also has \an [W] on it."
			return

	attack_hand(mob/user as mob, unused, flag)
		for(/obj/item/W in src)
			if(W.edible)
				food_in_tray += W.name

 		var/food_sel = input(user, "Test1", "Test2") as null|anything in food_in_tray
			if (!food_sel)
				return

		user.put_in_hand_or_drop(food_sel)
		boutput(user, "You take [food_sel] off of /the [src]")
		if (food_sel.icon_state == food1.iconstate)
			src.overlays -= food1
			src.desc -= " The [src] has \an [W] on it."
			return
		else if (food_sel.icon_state == food2.icon_state)
			src.overlays -= food2
			src.desc -= " The [src] also has \an [W] on it."
			return
		else //is this necessary? probably not
			return

proc/build_desc(var/name1, var/name2) maybe not necessary?


	New()
		..()
		handle = image('icons/obj/surgery.dmi', "")
		handle.icon_state = "surgical-scissors-handle"
		handle.color = "#[random_hex(6)]"
		src.overlays += handle

obj/item/tray/attack(mod/M as mob, mob/user as mob)
loose plan for this is to...
 when attacked one start doing the overlay stuff
first it checks if its food
then it checks the icon of the object for overlay stuff
then it sets an overlay on the tray with the icon and iconstate info
one per tray until i learn how to offset or whatever
also += to description with the name of the food that was added
then, store the food in src
then, when attacked w/ an empty hand, remove food (if there is any)*/

/obj/item/fish
	throwforce = 3
	force = 5
	icon = 'icons/obj/foodNdrink/food_related.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_food.dmi'
	w_class = 3
	var/fillet_type = /obj/item/reagent_containers/food/snacks/ingredient/meat/fish

	salmon
		name = "salmon"
		desc = "A commercial saltwater fish prized for its flavor."
		icon_state = "salmon"
		fillet_type = /obj/item/reagent_containers/food/snacks/ingredient/meat/fish/salmon

	carp
		name = "carp"
		desc = "A common run-of-the-mill carp."
		icon_state = "carp"

	bass
		name = "largemouth bass"
		desc = "A freshwater fish native to North America."
		icon_state = "bass"
		fillet_type = /obj/item/reagent_containers/food/snacks/ingredient/meat/fish/white

	red_herring
		name = "peculiarly coloured clupea pallasi"
		desc = "What is this? Why is this here? WHAT IS THE PURPOSE OF THIS?"
		icon_state = "red_herring"

/obj/item/fish/attack(mob/M as mob, mob/user as mob)
	if (user && user.bioHolder.HasEffect("clumsy") && prob(50))
		user.visible_message("<span style=\"color:red\"><b>[user]</b> swings [src] and hits \himself in the face!.</span>")
		user.weakened = max(2 * src.force, user.weakened)
		return
	else
		playsound(src.loc, pick('sound/weapons/slimyhit1.ogg', 'sound/weapons/slimyhit2.ogg'), 50, 1, -1)
		user.visible_message("<span style=\"color:red\"><b>[user] slaps [M] with [src]!</b>.</span>")

/obj/item/fish/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (istype(W, /obj/item/kitchen/utensil/knife))
		if (fillet_type)
			var/obj/fillet = new fillet_type(src.loc)
			user.put_in_hand_or_drop(fillet)
			boutput(user, "<span style=\"color:blue\">You skin and gut [src] using your knife.</span>")
			qdel(src)
			return
	..()
	return