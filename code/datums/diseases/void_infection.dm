/datum/ailment/disease/void_infection
	name = "Electrostatic Atomic Detanglement and Trans-superposition Syndrome"
	scantype = "NULL. CONTACT SYSTEM ADMINISTRATOR IMMEDIATELY."
	max_stages = 5
	spread = "Non-Contagious"
	cure = "Electric Shock"
	associated_reagent = "unstable_void"
	affected_species = list("Human")

/datum/ailment/disease/void_infection/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if(..())
		return
	switch(D.stage)
		if(1)
			if(prob(8))
				boutput(affected_mob, pick("Your thoughts feel scattered.", "Your eyes aren't focusing right.", "Something seems... different."))
			if(prob(10))
				affected_mob.emote(pick("blink", "shiver", "twitch"))
		if(2)
			if(prob(5))
				boutput(affected_mob, "Your vision is getting really blurry!")
				change_eye_blurry(12, 12)
			if(prob(6))
				boutput(affected_mob, "You can hear your heart pounding in your ears!")
				playsound(M, "sound/effects/Heart Beat.ogg", 50, 1)
			if(prob(10))
				boutput(affected_mob, pick("Your hands seem really far away...", "Your thoughts are jumbled!"))
			if(prob(12))
				affected_mob.emote(pick("tremble", "quiver", "shake", "shudder"))
		if(3)
			if(prob(4))
				boutput(affected_mob, "Your hands don't seem to be responding to your thoughts at all!")
				//drop items!
			if(prob(6))
				boutput(affected_mob, "")
				//faint cause youre not feeling good
			if(prob(8))
				//say some spooky voidish things
			if(prob(10))
				//spookyish emotes
			if(prob(12))
				//confused movement?
			if(prob(15))
				//throw up cause youre not feeling so good
		if(4)
			if(prob(6))
				//limb goes missing?
			if(prob(10))
				//throw up blood + brute damage
			if(prob(8))
				//faint
			if(prob(15))
				//confused movement, ouch
			if(prob(20))
				//spooky messages
			if(prob(20))
				//spooky things to say
		if(5)
			//say that you feel your body letting go of itself
			//permastun? one last chance to get a shock in
			if(prob(30))
				//say that you feel something hijack your body as it starts to vaporise
				//delete the body, spawn in a transposed particle field