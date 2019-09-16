
//oh no you are becoming a transposed particle field!
//apparently, status effects changed a bunch? im so sorry if this is really problematic D:
/datum/ailment/disease/void_infection
	name = "Electrostatic Atomic Detanglement and Trans-superposition Syndrome"
	scantype = "NULL. CONTACT SYSTEM ADMINISTRATOR IMMEDIATELY."
	max_stages = 3
	spread = "Non-Contagious"
	cure = "Electric Shock"
	associated_reagent = "unstable_void"
	affected_species = list("Human")

/datum/ailment/disease/void_infection/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if(..())
		return
	switch(D.stage)
		if(1) //this stage should start to amp up the danger with small stuns and burn/losebreath/oxy
			if() //play a spooky noise and send a spooky message
			if() //play a spooky emote and do some damage
			if() //spooky message and confused movement
			if() //spooky message, noise and a faint
		if(2) //this stage should be the maximum danger stage, with harsher stuns and worse effects
			if() //long bouts of pretty confused movement and some spooky messages/emotes
			if() //drop everything your holding and fall to the ground, take some brute
			if() //start coughing violently and puke up blood and vomit and grossness
			if() //spooky messages and emotes and then your limb disappears!
		if(3) //this stage should start with a permastun and end with the infected having their mob (teleported to hell? someplace spooky? should i keep this?) and spawning a tpf
			if(33) //medium to high probability to move to the instagib! a final chance to get any sort of shock in
					//delete the mob
					//spawn a tpf
