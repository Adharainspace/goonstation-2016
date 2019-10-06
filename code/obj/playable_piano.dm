/obj/item/piano_key
	name = "piano key"
	desc = "Designed to interface the player piano."
	icon = 'icons/obj/instruments.dmi'
	icon_state = "piano_key"

var/global/list/all_player_pianos = list()

/obj/player_piano
	name = "player piano"
	desc = "A piano that can take raw text and turn it into music! The future is now!"
	icon = 'icons/obj/instruments.dmi'
	icon_state = "player_piano"
	density = 1
	var/is_busy = 0 //stops people from messing about with it
	var/list/note_input = "" //where input is stored
	var/list/piano_notes = list() //after we format it for the big ol switch
	var/list/note_volumes = list() //list of volumes as nums (20,30,40,50,60)
	var/list/note_octaves = list() //list of octaves as nums (2-6)
	var/list/note_names = list() //a,b,c,d,e,f,g,r
	var/list/note_accidentals = list() //s,b,N
	var/list/compiled_notes = list() //holds our compiled filename
	var/song_length = 0 //the number of notes in the song
	var/curr_note = 0

	attackby(obj/item/W as obj, mob/user as mob) //reset key
		if (istype(W, /obj/item/piano_key))
			if (src in all_player_pianos)
				all_player_pianos -= src
			is_busy = 0
			note_input = ""
			piano_notes = list()
			note_volumes = list()
			note_octaves = list()
			note_names = list()
			note_accidentals = list()
			compiled_notes = list()
			song_length = 0
			curr_note = 0
			src.visible_message("<span style=\"color:red\">[user] sticks \the [W] into a slot on \the [src] and twists it!</span>")
			return
		else
			..()

	attack_hand(var/mob/user as mob)
		if (is_busy)
			src.visible_message("<span style=\"color:red\">\The [src] is busy doing piano stuff! Try again later.</span>")
			return
		var/mode_sel = input("Which mode would you like?", "Mode Select") as null|anything in list("Choose Notes", "Play Song")
		if (mode_sel == "Choose Notes")
			note_input = input("Write out the notes you want to be played in the format of \"Letter,B/S/N,vol,octave;\"", "Composition Menu", note_input)
			clean_input(note_input) //if updating input order to have a different order, update build_notes to reflect that order
			return
		else if (mode_sel == "Play Song")
			build_notes(piano_notes)
			ready_piano()
			icon_state = "player_piano_playing"
			return
		else //just in case
			return

	proc/clean_input(var/list/input) //breaks our big input string into chunks
		is_busy = 1
		piano_notes = list()
		src.visible_message("<span style=\"color:blue\">\The [src] starts humming and rattling as it processes!</span>")
		var/list/split_input = splittext("[note_input]", ";")
		for (var/string in split_input)
			piano_notes += string
		is_busy = 0

	proc/build_notes(var/list/piano_notes) //breaks our chunks apart and puts them into lists on the object
		is_busy = 1
		for (var/string in piano_notes)
			var/list/curr_notes = splittext("[string]", ",")
			note_names += curr_notes[1]
			note_octaves += curr_notes[4]
			switch(lowertext(curr_notes[2]))
				if ("s")
					curr_notes[2] = "s"
				if ("b")
					curr_notes[2] = "b"
				if ("n")
					curr_notes[2] = ""
			note_accidentals += curr_notes[2]
			switch(lowertext(curr_notes[3]))
				if ("p")
					curr_notes[3] = 60
				if ("mp")
					curr_notes[3] = 70
				if ("n")
					curr_notes[3] = 80
				if ("mf")
					curr_notes[3] = 90
				if ("f")
					curr_notes[3] = 100
			note_volumes += curr_notes[3]

	proc/ready_piano()
		if (note_volumes.len + note_octaves.len - note_names.len - note_accidentals.len)
			src.visible_message("<span style=\"color:red\">\The [src] makes a grumpy ratchetting noise and shuts down! Better check the notes!</span>")
			return
		song_length = note_names.len
		for (var/i = 1, i <= note_names.len, i++)
			var/string = lowertext("[note_names[i]][note_accidentals[i]][note_octaves[i]]")
			compiled_notes += string
		global.all_player_pianos += src
		src.visible_message("<span style=\"color:blue\">\The [src] starts whirring and playing music!</span>")

	proc/play_notes()
		curr_note++
		if (curr_note > song_length)
			global.all_player_pianos -= src
			src.visible_message("<span style=\"color:blue\">\The [src] stops playing music and becomes silent again.</span>")
			icon_state = "player_piano"
			is_busy = 0
			curr_note = 0
			return
		var/sound_name = "sound/piano/"
		sound_name += "[compiled_notes[curr_note]].ogg"
		src.visible_message("[sound_name]")
		playsound(src, sound_name, note_volumes[curr_note],0,0,0)
/*		switch (lowertext(note_names[curr_note])) //literally hell code no gs5 c6 only octave 6
			if ("a")
				switch(lowertext(note_accidentals[curr_note]))
					if ("b")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/ab3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/ab4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/ab5.ogg", note_volumes[curr_note],0,0,0)
					if ("s")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/bb3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/bb4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/bb5.ogg", note_volumes[curr_note],0,0,0)
					if ("n")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/a3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/a4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/a5.ogg", note_volumes[curr_note],0,0,0)
			if ("b")
				switch(lowertext(note_accidentals[curr_note]))
					if ("b")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/bb3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/bb4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/bb5.ogg", note_volumes[curr_note],0,0,0)
					if ("s")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/c3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/c4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/c5.ogg", note_volumes[curr_note],0,0,0)
							if (6)
								playsound(src, "sound/piano/c6.ogg", note_volumes[curr_note],0,0,0)
					if ("n")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/b3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/b4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/b5.ogg", note_volumes[curr_note],0,0,0)
			if ("c")
				switch(lowertext(note_accidentals[curr_note]))
					if ("b")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/b3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/b4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/b5.ogg", note_volumes[curr_note],0,0,0)
					if ("s")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/db3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/db4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/db5.ogg", note_volumes[curr_note],0,0,0)
					if ("n")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/c3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/c4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/c5.ogg", note_volumes[curr_note],0,0,0)
							if (6)
								playsound(src, "sound/piano/c6.ogg", note_volumes[curr_note],0,0,0)
			if ("d")
				switch(lowertext(note_accidentals[curr_note]))
					if ("b")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/db3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/db4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/db5.ogg", note_volumes[curr_note],0,0,0)
					if ("s")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/eb3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/eb4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/eb5.ogg", note_volumes[curr_note],0,0,0)
					if ("n")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/d3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/d4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/d5.ogg", note_volumes[curr_note],0,0,0)
			if ("e")
				switch(lowertext(note_accidentals[curr_note]))
					if ("b")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/eb3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/eb4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/eb5.ogg", note_volumes[curr_note],0,0,0)
					if ("s")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/f3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/f4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/f5.ogg", note_volumes[curr_note],0,0,0)
					if ("n")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/e3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/e4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/e5.ogg", note_volumes[curr_note],0,0,0)
			if ("f")
				switch(lowertext(note_accidentals[curr_note]))
					if ("b")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/e3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/e4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/e5.ogg", note_volumes[curr_note],0,0,0)
					if ("s")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/gb3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/gb4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/gb5.ogg", note_volumes[curr_note],0,0,0)
					if ("n")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/f3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/f4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/f5.ogg", note_volumes[curr_note],0,0,0)
			if ("g")
				switch(lowertext(note_accidentals[curr_note]))
					if ("b")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/gb3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/gb4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/gb5.ogg", note_volumes[curr_note],0,0,0)
					if ("s")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/ab3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/ab4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/ab5.ogg", note_volumes[curr_note],0,0,0)
					if ("n")
						switch(note_octaves[curr_note])
							if (3)
								playsound(src, "sound/piano/g3.ogg", note_volumes[curr_note],0,0,0)
							if (4)
								playsound(src, "sound/piano/g4.ogg", note_volumes[curr_note],0,0,0)
							if (5)
								playsound(src, "sound/piano/g5.ogg", note_volumes[curr_note],0,0,0)
			if ("r") //rest
				return*/

/*	proc/make_notes(var/string)
		var/note = ""
		var/datum/text_roamer/T = new/datum/text_roamer(string)

		for(var/i = 0, i < length(string), i=i)
			var/datum/parse_result/P = note_parse(T)


/*/proc/chavify(var/string)

	var/modded = ""
	var/datum/text_roamer/T = new/datum/text_roamer(string)

	for(var/i = 0, i < length(string), i=i)
		var/datum/parse_result/P = chav_parse(T)
		modded += P.string
		i += P.chars_used
		T.curr_char_pos = T.curr_char_pos + P.chars_used
		T.update()

	if(prob(15))
		modded += pick(" innit"," like"," mate")

	return modded*/

	proc/note_parse(var/datum/text_roamer/R)
		var/new_string = ""
		var/used = 0

		switch(lowertext(R.curr_char))
			if("r")



/proc/chav_parse(var/datum/text_roamer/R)
	var/new_string = ""
	var/used = 0

	switch(lowertext(R.curr_char))
		if("w")
			if(lowertext(R.next_char) == "h" && lowertext(R.next_next_char) == "a")
				new_string = "wo"
				used = 3
		if("W")
			if(lowertext(R.next_char) == "H" && lowertext(R.next_next_char) == "A")
				new_string = "WO"
				used = 3

		if("o")
			if(lowertext(R.next_char) == "u" && lowertext(R.next_next_char) == "g" && lowertext(R.next_next_next_char) == "h")
				new_string = "uf"
				used = 4
			if(lowertext(R.next_char) == "r" && lowertext(R.next_next_char) == "r" && lowertext(R.next_next_next_char) == "y")
				new_string = "oz"
				used = 4
		if("O")
			if(lowertext(R.next_char) == "U" && lowertext(R.next_next_char) == "G" && lowertext(R.next_next_next_char) == "H")
				new_string = "UF"
				used = 4
			if(lowertext(R.next_char) == "R" && lowertext(R.next_next_char) == "R" && lowertext(R.next_next_next_char) == "Y")
				new_string = "OZ"
				used = 4

		if("t")
			if(lowertext(R.next_char) == "i" && lowertext(R.next_next_char) == "o" && lowertext(R.next_next_next_char) == "n")
				new_string = "shun"
				used = 4
			else if(lowertext(R.next_char) == "h" && lowertext(R.next_next_char) == "e")
				new_string = "zee"
				used = 3
			else if(lowertext(R.next_char) == "h" && (lowertext(R.next_next_char) == " " || lowertext(R.next_next_char) == "," || lowertext(R.next_next_char) == "." || lowertext(R.next_next_char) == "-"))
				new_string = "t" + R.next_next_char
				used = 3
		if("T")
			if(lowertext(R.next_char) == "I" && lowertext(R.next_next_char) == "O" && lowertext(R.next_next_next_char) == "N")
				new_string = "SHUN"
				used = 4
			else if(lowertext(R.next_char) == "H" && lowertext(R.next_next_char) == "E")
				new_string = "ZEE"
				used = 3
			else if(lowertext(R.next_char) == "H" && (lowertext(R.next_next_char) == " " || lowertext(R.next_next_char) == "," || lowertext(R.next_next_char) == "." || lowertext(R.next_next_char) == "-"))
				new_string = "T" + R.next_next_char
				used = 3

		if("u")
			if (lowertext(R.prev_char) != " " || lowertext(R.next_char) != " ")
				new_string = "oo"
				used = 1
		if("U")
			if (lowertext(R.prev_char) != " " || lowertext(R.next_char) != " ")
				new_string = "OO"
				used = 1

		if("o")
			if (lowertext(R.next_char) == "w"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char )!= " "))
				new_string = "oo"
				used = 2
			else if (lowertext(R.prev_char) != " " || lowertext(R.next_char) != " ")
				new_string = "u"
				used = 1
			else if(lowertext(R.next_char) == " " && lowertext(R.prev_char) == " ") ///!!!
				new_string = "oo"
				used = 1
		if("O")
			if (lowertext(R.next_char) == "W"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char )!= " "))
				new_string = "OO"
				used = 2
			else if (lowertext(R.prev_char) != " " || lowertext(R.next_char) != " ")
				new_string = "U"
				used = 1
			else if(lowertext(R.next_char) == " " && lowertext(R.prev_char) == " ") ///!!!
				new_string = "OO"
				used = 1

		if("i")
			if (lowertext(R.next_char) == "r"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char) != " "))
				new_string = "ur"
				used = 2
			else if((lowertext(R.prev_char) != " " || lowertext(R.next_char) != " "))
				new_string = "ee"
				used = 1
		if("I")
			if (lowertext(R.next_char) == "R"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char) != " "))
				new_string = "UR"
				used = 2
			else if((lowertext(R.prev_char) != " " || lowertext(R.next_char) != " "))
				new_string = "EE"
				used = 1

		if("e")
			if (lowertext(R.next_char) == "n"  && lowertext(R.next_next_char) == " ")
				new_string = "ee "
				used = 3
			else if (lowertext(R.next_char) == "w"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char) != " "))
				new_string = "oo"
				used = 2
			else if ((lowertext(R.next_char) == " " || lowertext(R.next_char) == "," || lowertext(R.next_char) == "." || lowertext(R.next_char) == "-")  && lowertext(R.prev_char) != " ")
				new_string = "e-a" + R.next_char
				used = 2
			else if(lowertext(R.next_char) == " " && lowertext(R.prev_char) == " ") ///!!!
				new_string = "i"
				used = 1
		if("E")
			if (lowertext(R.next_char) == "N"  && lowertext(R.next_next_char) == " ")
				new_string = "EE "
				used = 3
			else if (lowertext(R.next_char) == "W"  && (lowertext(R.prev_char) != " " || lowertext(R.next_next_char) != " "))
				new_string = "OO"
				used = 2
			else if ((lowertext(R.next_char) == " " || lowertext(R.next_char) == "," || lowertext(R.next_char) == "." || lowertext(R.next_char) == "-")  && lowertext(R.prev_char) != " ")
				new_string = "E-A" + R.next_char
				used = 2
			else if(lowertext(R.next_char) == " " && lowertext(R.prev_char) == " ") ///!!!
				new_string = "I"
				used = 1

		if("a")
			if (lowertext(R.next_char) == "u")
				new_string = "oo"
				used = 2
			else if (lowertext(R.next_char) == "n")
				new_string = "un"
				used = 2
			else
				new_string = "e" //{WC} ?
				used = 1
		if("A")
			if (lowertext(R.next_char) == "U")
				new_string = "OO"
				used = 2
			else if (lowertext(R.next_char) == "N")
				new_string = "UN"
				used = 2
			else
				new_string = "E" //{WC} ?
				used = 1

	if(new_string == "")
		new_string = R.curr_char
		used = 1

	var/datum/parse_result/P = new/datum/parse_result
	P.string = new_string
	P.chars_used = used
	return P*/