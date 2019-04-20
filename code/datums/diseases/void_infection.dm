/*
//oh no you are becoming a transposed particle field!
//apparently, status effects changed a bunch? im so sorry if this is really problematic D:
/datum/ailment/disease/void_infection
	name = "Electrostatic Atomic Detanglement and Trans-superposition Syndrome"
	scantype = "NULL. CONTACT SYSTEM ADMINISTRATOR IMMEDIATELY."
	max_stages = 5
	spread = "Non-Contagious"
	cure = "Electric Shock"
	associated_reagent = "unstable_void"
	affected_species = list("Human")

/datum/ailment/disease/void_infection/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)

/datum/ailment/disease/void_infection/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if(..())
		return
	switch(D.stage) //if() order goes from greatest prob to least probability
		if(1) //this stage should mainly be really subtle things that make the infected feel uneasy
			if()
				playsound(T, "[pick("sounds/effects","",""]")
			if()
				var/turf/T = get_turf(affected_mob)
					boutput
			if() //send an uncomfy emote
		if(2) //this stage should start to amp up the danger with small stuns and burn/losebreath/oxy
			if() //play a spooky noise AND send a spooky message
			if() //play a spooky emote AND do some damage
			if() //spooky message AND confused movement
			if() //spooky message, noise AND a faint
		if(3) //this stage should be the maximum danger stage, with harsher stuns and worse effects
			if() //long bouts of pretty confused movement and some spooky messages/emotes
			if() //drop everything your holding and fall to the ground, take some brute
			if() //start coughing violently and puke up blood and vomit and grossness
			if() //spooky messages and emotes and then your limb disappears!
		if(4) //this stage should start with a permastun and end with the infected having their mob (teleported to hell? someplace spooky? should i keep this?) and spawning a tpf
			if(33) //medium to high probability to move to the instagib! a final chance to get any sort of shock in
				//IF WE'RE NOT GOING THE HELL ROUTE
					//delete the mob
					//spawn a tpf
					*/