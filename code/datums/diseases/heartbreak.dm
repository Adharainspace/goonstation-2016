/datum/ailment/disease/hearbtreak
	name = "Heartbreak"
	max_stages = 3
	spread = "Non-contagious"
	cure = "Comfort and/or Rest and/or Time."
	reagentcure = list("chocolate", "wine", "chickensoup", "tea")
	associated_reagent = "heartbreak"
	affected_species = list("Human")
	var/remove_buff = 0
//animate_fade_grayscale(src, 50)

/datum/ailment/disease/heartbreak/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if (..())
		return
	switch(D.stage)
		if(1) //low energy, sad emotes
			if(prob(75)) //sad emotes
				affected_mob.emote(pick("sigh","moan","groan","whimper","sniff"))
			if(prob(50))
				affected_mob.slowed += 3
				boutput(affected_mob, "<span style=\"color:grey\">[pick("You should just sit down and rest for a bit...","You're feeling really tired, you should sit down...","It feels like someone's sucking your energy away...")]</span>")
			if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
				remove_buff = holder.my_atom:add_stam_mod_regen("heartbreak", -2)
				boutput(affected_mob, "<span style=\"color:grey\">You're feeling drained!</span>")
		if(2) //low energy, sad emotes, crying, greyscale
			if(prob(50))
				affected_mob.emote(pick("cry","sob","whimper","sniff"))
			if(prob(50))
				affected_mob.slowed += 3
				boutput(affected_mob, "<span style=\"color:grey\">[pick("You should just sit down and rest for a bit...","You're feeling really tired, you should sit down...","It feels like someone's sucking your energy away...")]</span>")
			if(prob(25))
				affected_mob.say(pick("Things just seem so pointless without them...","How am I supposed to carry on without them?","They meant everything to me...","I just want them back, please, I'd do anything...","My life means nothing without them, nothing!","It's just... so difficult to go on without them..."))
			if(prob(20))
				animate_fade_grayscale(affected_mob, 50)
				boutput(affected_mob, "<span style=\"color:grey\">[pick("Things just seem so drab...","The world just seems... so dull...","Everything looks the same...","Everything's flat and ugly...")]</span>")
			if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
				remove_buff = holder.my_atom:add_stam_mod_regen("heartbreak", -4)
				boutput(affected_mob, "<span style=\"color:grey\">You're really feeling drained!</span>")
		if(3) //low energy, sad emotes, crying, greyscale, literal heartbreaking time
			if(prob(90))
				affected_mob.emote(pick("cry","sob"))
			if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
				remove_buff = holder.my_atom:add_stam_mod_regen("heartbreak", -6)
				boutput(affected_mob, "<span style=\"color:grey\">You're don't feel like you have any energy left!</span>")

/datum/ailment/disease/heartbreak/on_remove(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if(remove_buff)
		if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
			holder.my_atom:remove_stam_mod_regen("heartbreak")