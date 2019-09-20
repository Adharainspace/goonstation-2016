
//oh no you are becoming a transposed particle field!
//apparently, status effects changed a bunch? im so sorry if this is really problematic D:
/datum/ailment/disease/void_infection
	name = "Electrostatic Atomic Detanglement and Trans-superposition Syndrome"
	scantype = "NULL. CONTACT SYSTEM ADMINISTRATOR IMMEDIATELY."
	max_stages = 3
	spread = "Non-Contagious"
	cure = "Electron Re-alignment"
	associated_reagent = "unstable_void"
	affected_species = list("Human")

/datum/ailment/disease/void_infection/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if(..())
		return
	switch(D.stage)
		if(1) //this stage should start the danger with small stuns and burn/losebreath/oxy
			if(30)
				affected_mob.playsound_local(affected_mob, pick(ghostly_sounds), 100, 1)
				boutput(affected_mob, "<span style=\"color:purple\"><B>[pick("Just give in... isn't it tiresome?","You should just lie down and let nature run its course...","Give up! Give in! Give up! Give in!","You are weak... let yourself ascend... just like us...")]</B></span>")  //play a spooky noise and send a spooky message
			if(15) //play a spooky message and do some damage
			if(10) //spooky emote and confused movement
			if(5) //spooky message, noise and a faint
		if(2) //this stage should be the danger stage, with harsher stuns and worse effects
			if(25) //long bouts of pretty confused movement and some spooky messages/emotes
			if(15)
				affected_mob.stunned = max(10, affected_mob.stunned) //stun and damage
			if(7) //spooky messages and emotes and then your limb disappears!
			if(5) //start coughing violently and puke up blood and vomit and grossness
				affected_mob.

		if(3) //this stage should start with a permastun and end with the infected having their mob (teleported to hell? someplace spooky? should i keep this?) and spawning a tpf

			if(25) //medium to high probability to move to the instagib! a final chance to get any sort of shock in
					//delete the mob
					//spawn a tpf
