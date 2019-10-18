
// Drinks

/obj/item/reagent_containers/food/drinks/bottle/red
	name = "Robust-Eez"
	desc = "A carbonated robustness tonic. It has quite a kick."
	label = "robust"
	heal_amt = 1
	labeled = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("methamphetamine", 3)
		reagents.add_reagent("VHFCS", 10)
		reagents.add_reagent("cola", 17)

/obj/item/reagent_containers/food/drinks/bottle/blue
	name = "Grife-O"
	desc = "The carbonated beverage of a space generation. Contains actual space dust!"
	label = "grife"
	labeled = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("radium", 3)
		reagents.add_reagent("ephedrine", 6)
		reagents.add_reagent("VHFCS", 10)
		reagents.add_reagent("cola", 11)

/obj/item/reagent_containers/food/drinks/bottle/pink
	name = "Dr. Pubber"
	desc = "The beverage of an original crowd. Tastes like an industrial tranquilizer."
	label = "pubber"
	labeled = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("haloperidol", 4)
		reagents.add_reagent("morphine", 4)
		reagents.add_reagent("VHFCS", 10)
		reagents.add_reagent("cola", 12)

/obj/item/reagent_containers/food/drinks/bottle/lime
	name = "Lime-Aid"
	desc = "Antihol mixed with lime juice. A well-known cure for hangovers."
	label = "limeaid"
	labeled = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("antihol", 20)
		reagents.add_reagent("juice_lime", 20)

/obj/item/reagent_containers/food/drinks/bottle/spooky
	name = "Spooky Dan's Runoff Cola"
	desc = "A spoooky cola for Halloween!  Rumors that Runoff Cola contains actual industrial runoff are unsubstantiated."
	label = "spooky"
	labeled = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("chlorine", 5)
		reagents.add_reagent("phosphorus", 5)
		reagents.add_reagent("mercury", 5)
		reagents.add_reagent("VHFCS", 10)
		reagents.add_reagent("cola", 15)

/obj/item/reagent_containers/food/drinks/bottle/spooky2
	name = "Spooky Dan's Horrortastic Cola"
	desc = "A terrifying Halloween soda.  It's especially frightening if you're diabetic."
	label = "spooky"
	labeled = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("ectoplasm", 10)
		reagents.add_reagent("sulfur", 5)
		reagents.add_reagent("VHFCS", 5)
		reagents.add_reagent("cola", 20)

/obj/item/reagent_containers/food/drinks/bottle/xmas
	name = "Happy Elf Hot Chocolate"
	desc = "Surprising to see this here, in a world of corporate plutocrat lunatics."
	label = "choco"
	labeled = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("chocolate", 45)
		if(prob(10))
			reagents.add_reagent("grognardium", 5)

/obj/item/reagent_containers/food/drinks/bottle/bottledwater
	name = "Decirprevo Bottled Water"
	desc = "Bottled from our cool natural springs on Europa."
	label = "water"
	labeled = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("iodine", 5)
		reagents.add_reagent("water", 45)

/obj/item/reagent_containers/food/drinks/bottle/grones
	name = "Grones Soda"
	desc = "They make all kinds of flavors these days, good lord."
	label = "grones"
	heal_amt = 1
	labeled = 1
	initial_volume = 50

	New()
		..()
		var/flavor = rand(1,14)
		switch(flavor)
			if(1)
				src.desc = "Wicked Sick Pumpkin Prolapse flavor."
				reagents.add_reagent("diarrhea", 10)
			if(2)
				src.desc = "Ballin' Banana Testicular Torsion flavor."
				reagents.add_reagent("urine", 10)
			if(3)
				src.desc = "Radical Roadkill Rampage flavor."
				reagents.add_reagent("bloodc", 10) // heh
			if(4)
				src.desc = "Sweet Cherry Brain Haemorrhage flavor."
				reagents.add_reagent("impedrezine", 10)
			if(5)
				src.desc = "Awesome Asbestos Candy Apple flavor."
				reagents.add_reagent("lithium", 10)
			if(6)
				src.desc = "Salt-Free Senile Dementia flavor."
				reagents.add_reagent("mercury", 10)
			if(7)
				src.desc = "High Fructose Traumatic Stress Disorder flavor."
				reagents.add_reagent("atropine", 10)
			if(8)
				src.desc = "Tangy Dismembered Orphan Tears flavor."
				reagents.add_reagent("epinephrine", 10)
			if(9)
				src.desc = "Chunky Infected Laceration Salsa flavor."
				reagents.add_reagent("charcoal", 10)
			if(10)
				src.desc = "Manic Depressive Multivitamin Dewberry flavor."
				reagents.add_reagent("ephedrine", 10)
			if(11)
				src.desc = "Anti-Bacterial Air Freshener flavor."
				reagents.add_reagent("spaceacillin", 10)
			if(12)
				src.desc = "Old Country Hay Fever flavor."
				reagents.add_reagent("antihistamine", 10)
			if(13)
				src.desc = "Minty Restraining Order Pepper Spray flavor."
				reagents.add_reagent("capsaicin", 10)
			if(14)
				src.desc = "Cool Keratin Rush flavor."
				reagents.add_reagent("hairgrownium", 10)
		reagents.add_reagent("cola", 20)

/obj/item/reagent_containers/food/drinks/bottle/orange
	name = "Orange-Aid"
	desc = "A vitamin tonic that promotes good eyesight and health."
	label = "orangeaid"
	heal_amt = 1
	labeled = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("oculine", 20)
		reagents.add_reagent("juice_orange", 20)

/obj/item/reagent_containers/food/drinks/water
	name = "water bottle"
	desc = "I wonder if this is still fresh?"
	icon = 'icons/obj/items.dmi'
	icon_state = "bottlewater"
	item_state = "contliquid"
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("water", 50)

/obj/item/reagent_containers/food/drinks/tea
	name = "tea"
	desc = "A fine cup of tea.  Possibly Earl Grey.  Temperature undetermined."
	icon_state = "tea0"
	item_state = "coffee"
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("tea", 50)

/obj/item/reagent_containers/food/drinks/tea/mugwort
	name = "mugwort tea"
	desc = "Rumored to have mystical powers of protection.<br>It has a message written on it: 'To the world's greatest wizard - love, Dad'"
	icon_state = "tea1"
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("tea", 30)
		reagents.add_reagent("mugwort",20)

/obj/item/reagent_containers/food/drinks/coffee
	name = "Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	heal_amt = 1
	initial_volume = 50
	module_research = list("vice" = 5)

	New()
		..()
		reagents.add_reagent("coffee", 30)

/obj/item/reagent_containers/food/drinks/eggnog
	name = "Egg Nog"
	desc = "A festive beverage made with eggs. Please eat the eggs. Eat the eggs up."
	icon_state = "nog"
	heal_amt = 1
	festivity = 1
	rc_flags = RC_FULLNESS
	initial_volume = 50
	module_research = list("vice" = 5)
	module_research_type = /obj/item/reagent_containers/food/drinks/bottle/beer

	New()
		..()
		reagents.add_reagent("eggnog", 40)

/obj/item/reagent_containers/food/drinks/chickensoup
	name = "Chicken Soup"
	desc = "Got something to do with souls. Maybe. Do chickens even have souls?"
	icon_state = "coffee"
	heal_amt = 1
	rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("chickensoup", 30)

/obj/item/reagent_containers/food/drinks/weightloss_shake
	name = "Weight-Loss Shake"
	desc = "A shake designed to cause weight loss.  The package proudly proclaims that it is 'tapeworm free.'"
	icon_state = "shake"
	heal_amt = 1
	rc_flags = RC_FULLNESS
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("lipolicide", 30)
		reagents.add_reagent("chocolate", 5)

/obj/item/reagent_containers/food/drinks/cola
	name = "space cola"
	desc = "Cola. in space."
	icon_state = "cola"
	heal_amt = 1
	rc_flags = RC_FULLNESS
	initial_volume = 50
	var/is_sealed = 1 //can you drink out of it?
	var/standard_override //is this a random cola or a standard cola (for crushed icons)

	New()
		..()
		reagents.add_reagent("cola", 20)
		reagents.add_reagent("VHFCS", 10)

		if(prob(50))
			src.icon_state = "cola-blue"

	attack(mob/M as mob, mob/user as mob)
		if (is_sealed)
			boutput(user, "<span style=\"color:red\">You can't drink out of a sealed can!</span>") //idiot
			return
		..()

	attack_self(mob/user as mob)
		var/drop_this_shit = 0 //i promise this is useful
		if (src.is_sealed)
			user.visible_message("[user] pops the tab on \the [src]!", "You pop \the [src] open!")
			is_sealed = 0
			playsound(src.loc, "sound/items/can_open.ogg", 50, 1)
			return
		if (!src.reagents || !src.reagents.total_volume)
			var/zone = user.zone_sel.selecting
			if (zone == "head")
				user.visible_message("<span style=\"color:red\"><b>[user] crushes \the [src] against their forehead!! [pick("Bro!", "Epic!", "Damn!", "Gnarly!", "Sick!",\
				"Crazy!", "Nice!", "Hot!", "What a monster!", "How sick is that?", "That's slick as shit, bro!")]", "You crush the can against your forehead! You feel super cool.")
				drop_this_shit = 1
			else
				user.visible_message("[user] crushes \the [src][pick(" one-handed!", ".", ".", ".")] [pick("Lame.", "Eh.", "Meh.", "Whatevs.", "Weirdo.")]", "You crush the can!")
			var/obj/item/crushed_can/C = new(get_turf(user))
			playsound(src.loc, "sound/items/can_crush-[rand(1,3)].ogg", 50, 1)
			C.set_stuff(src.name, src.icon_state)
			user.u_equip(src)
			user.drop_item(src)
			if (!drop_this_shit) //see?
				user.put_in_hand_or_drop(C)
			qdel(src)

/obj/item/crushed_can
	name = "crushed can"
	desc = "This can's been totally crushed!"
	icon = 'icons/obj/can.dmi'

	proc/set_stuff(var/name, var/icon_state)
		src.name = "crushed [name]"
		if (icon_state == "cola" || "cola-blue")
			switch(icon_state)
				if ("cola")
					src.icon_state = "crushed-1"
					return
				if ("cola-blue")
					src.icon_state = "crushed-2"
					return
		var/list/iconsplit = splittext("[icon_state]", "-")
		src.icon_state = "crushed-[iconsplit[2]]"

/obj/item/reagent_containers/food/drinks/milk
	name = "Creaca's Space Milk"
	desc = "A bottle of fresh space milk from happy, free-roaming space cows."
	icon_state = "milk"
	heal_amt = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("milk", 50)

/obj/item/reagent_containers/food/drinks/milk/rancid
	name = "Rancid Space Milk"
	desc = "A bottle of rancid space milk. Better not drink this stuff."
	icon_state = "milk"
	heal_amt = 1
	initial_volume = 50

	New()
		..()
		reagents.add_reagent("milk", 25)
		reagents.add_reagent("toxin", 25)

/obj/item/reagent_containers/food/drinks/milk/soy
	name = "Creaca's Space Soy Milk"
	desc = "A bottle of fresh space soy milk from happy, free-roaming space soybean plants. The plant pots just float around untethered."
