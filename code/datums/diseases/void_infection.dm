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
	if(..())
		return
	switch(D.stage)
		if(1)
			if(prob(10))
				boutput(affected_mob, pick("Your thoughts feel scattered.", "Your eyes aren't focusing right.", "Something seems... different."))
			if(prob(15))
				affected_mob.emote(pick("blink", "shiver", "twitch"))
		if(2)
			if(prob(8))
				boutput(affected_mob, "Your vision is getting really blurry!")
				change_eye_blurry(12, 12)
			if(prob(10))
				boutput(affected_mob, "You can hear your heart pounding in your ears!")
				playsound(M, "sound/effects/Heart Beat.ogg", 50, 1)
			if(prob(13))
				boutput(affected_mob, pick("Your hands seem really far away...", "Your thoughts are jumbled!"))
			if(prob(15))
				affected_mob.emote(pick("tremble", "quiver", "shake", "shudder"))
		if(3)
			if(prob(8)) //this one should knock you over and then faint you!
				boutput(affected_mob, "You get REALLY lightheaded!")
				sleep(20)
				M.weakened += 8
				M.emote("faint")
			if(prob(10)) //this one should make you drop everything youre holding
				boutput(affected_mob, "Your hands don't seem to be responding to your thoughts at all!")
				var/h = affected_mob.hand
				affected_mob.hand = 0
				affected_mob.drop_item()
				affected_mob.hand = 1
				affected_mob.drop_item()
				affected_mob.hand = h
			if(prob(18))
				affected_mob.say(pick("Help me! I feel so... cold.", "It's all your fault! Help me, please!", "I can't feel myself anymore! I... something's wrong!"))
			if(prob(20)) //this one should give you about ten seconds of really confused movement
				affected_mob.visible_message("<span style=\"color:red\"<b>[affected_mob]</b> is stumbling all over the place!</span>"
				M.change_misstep_chance(40)
				sleep(100)
				M.change_misstep_chance(0)
			if(prob(40)) //this one should make you move one tile in a random direction
				boutput(affected_mob, "You stumble!")
				if(affected_mob.canmove && isturf(affected_mob.loc))
					step(affected_mob, pick(cardinal))
		if(4)
			if(prob(6)) //this one should disintegrate one of your limbs!

			if(prob(8)) //this one should
			if(prob(10))
				//throw up blood + brute damage
			if(prob(15))
				M.change_misstep_chance(
			if(prob(20))
				//spooky messages
			if(prob(20))
				//spooky things to say
		if(5
			boutput(affected_mob, "Ohgodohgodohgod! Its happening!"
			//permastun? one last chance to get a shock in
			if(prob(25))
				boutput(affected_mob, "Your hands don't seem to be responding to your thoughts at all!")
				//say that you feel something hijack your body as it starts to vaporise
				//delete the body, spawn in a transposed particle field