/obj/item/piano_key //for resetting the piano in case of issues / annoying music
	name = "piano key"
	desc = "Designed to interface the player piano."
	icon = 'icons/obj/instruments.dmi'
	icon_state = "piano_key"

/obj/item/paper/book/player_piano //book for helping people!
	name = "Your Player Piano and You"
	desc = "A guide to using the station's new player piano! Probably'd make good kindling."
	info = {"
	<BIG><B>Everything You Need To Know About The Player Piano</B></BIG>
	<br>
	<br>This book is meant to give you an idea of how to work the player piano.
	<br>
	<br>
	<br><B>Basics:</B>
	<br>
	<br>Your player piano takes raw text that you input through the interface and turns it into notes!
	<br>A note will play approximately every half second.
	<br>You can enable looping on the piano by using the piano key!
	<br>The piano key will also let you reset everything on the piano (like a factory reset) if something goes really crazy.
	<br>A "note" in the player piano has four parts, each separated by a comma:
	<br>
	<br>*The Note Name
	<br>*Accidentals
	<br>*Dynamics
	<br>*Octave
	<br>
	<br>Each note "cluster" needs to be separated by a vertical pipe, like so: A,B,F,3|B,B,F,3
	<br>
	<br>Note Name: Either A,B,C,D,E,F or G if you want to play a note, or R if you don't. (IMPORTANT: READ FURTHER FOR REST INFO)
	<br>
	<br>Accidentals: B for flat, S for sharp, N for natural.
	<br>
	<br>Dynamics: P for piano (quietest), MP for mezzo piano, N for neutral, MF for mezzo forte and F for forte (loudest).
	<br>
	<br>Octave: Notes can be on one of three octaves: 3, 4 or 5. 3 is low, 5 is high. The only exception is G Sharp, which can only be 3 or 4.
	<br>
	<br><B>Limitations:</B>
	<br>
	<br>*If you want a note to be a rest, you'll need to put an R in for every field on the note: (R,R,R,R|)
	<br>*You cannot change the duration of a note, or play notes at the same time.
	<br>*You cannot play below octave 3 or above octave 5 (Including C6)
	<br>*Even though it's not likely you'll run into it, there is a limit for the number of characters you can input (2048 characters, 256 notes.)
	<br>
	<br><B>Maintenance:</B>
	<br>
	<br>*You can use your piano's key to activate a built in reset.
	<br>*You can use your piano's key to enable or disable the looping circuit.
	<br>*You can use your piano's key to set the interval of notes from 0.25 to 0.5 seconds. The default timing is 0.5 seconds.
	<br>*You can access your piano's internal workings by prying off the front panel.
	<br>*You can use a multitool to reset the piano's memory once you have access to its insides.
	<br>*You can use a wirecutter to disable looping. (WARNING, THIS IS PERMANENT, DON'T LOSE YOUR DAMN KEY)
	<br>*You can use a screwdriver to raise and lower the wheel bolts, making the piano moveable.
	<br>
	<br><B>Understanding Your Piano's Language</B>
	<br>
	<br>Your piano will often make noises. But don't worry! It's just communicating with you. And if you can't speak piano, you have this handy little book to help.
	<br>
	<br>*An angry sounding beep means that the piano is busy and you can't interface with it.
	<br>*Whirring followed by a complete shutdown means that your note input was too long for the piano.
	<br>*A lot of horrible mechanical noise followed by a complete shutdown means that the tempo you tried to input was too fast or slow.
	<br>*Ratcheting followed by a complete shutdown means that you forgot to input a piece of a note cluster somewhere.
	<br>*A lot of noise followed by a count of beeps means that a note you tried to play doesn't exist. The number of beeps is the position of the note.
	<br>*If the song ends earlier than expected, make sure that you don't have any double vertical bars in your input.
	<br>*And remember, if things are funky and not working, use your piano reset key!
	"}

/obj/player_piano //this is the big boy im pretty sure all this code is garbage
	name = "player piano"
	desc = "A piano that can take raw text and turn it into music! The future is now!"
	icon = 'icons/obj/instruments.dmi'
	icon_state = "player_piano"
	density = 1
	anchored = 1
	mats = 20
	var/timing = 0.5 //values from 0.25 to 0.5 please
	var/items_claimed = 0 //set to 1 when items are claimed
	var/is_looping = 0 //is the piano looping? 0 is no, 1 is yes, 2 is never more looping
	var/panel_exposed = 0 //0 by default
	var/is_busy = 0 //stops people from messing about with it when its working
	var/list/note_input = "" //where input is stored
	var/list/piano_notes = list() //after we break it up into chunks
	var/list/note_volumes = list() //list of volumes as nums (20,30,40,50,60)
	var/list/note_octaves = list() //list of octaves as nums (3-5)
	var/list/note_names = list() //a,b,c,d,e,f,g,r
	var/list/note_accidentals = list() //(s)harp,b(flat),N(none)
	var/list/compiled_notes = list() //holds our compiled filenames for the note
	var/song_length = 0 //the number of notes in the song
	var/curr_note = 0 //what note is the song on?

	attackby(obj/item/W as obj, mob/user as mob)

		if (istype(W, /obj/item/piano_key)) //piano key
			var/mode_sel = input("Which do you want to do?", "Piano Control") as null|anything in list("Reset Piano", "Toggle Looping", "Adjust Timing")

			switch(mode_sel)
				if ("Reset Piano") //reset piano B)
					reset_piano()
					src.visible_message("<span style=\"color:red\">[user] sticks \the [W] into a slot on \the [src] and twists it! \The [src] grumbles and shuts down completely.</span>")
					return

				if ("Toggle Looping") //self explanatory, sets whether or not the piano should be looping
					if (is_looping == 0)
						is_looping = 1
					else if (is_looping == 1)
						is_looping = 0
					else
						src.visible_message("<span style=\"color:red\">[user] tries to stick \the [W] into a slot on \the [src], but it doesn't seem to want to fit.")
						return
					src.visible_message("<span style=\"color:red\">[user] sticks \the [W] into a slot on \the [src] and twists it! \The [src] seems different now.")

				if ("Adjust Timing") //adjusts tempo
					var/time_sel = input("Input a custom tempo from 0.25 to 0.5 BPS", "Tempo Control") as num
					if (time_sel < 0.25 || time_sel > 0.5)
						src.visible_message("<span style=\"color:red\">The mechanical workings of [src] emit a horrible din for several seconds before \the [src] shuts down.")
						return
					timing = time_sel
					src.visible_message("<span style=\"color:red\">[user] sticks \the [W] into a slot on \the [src] and twists it! \The [src] rumbles indifferently.")

		else if (istype(W, /obj/item/screwdriver)) //unanchoring piano
			if (anchored)
				user.visible_message("[user] starts loosening the piano's castors...", "You start loosening the piano's castors...")
				if (!do_after(user, 30) || anchored != 1)
					return
				playsound(user, "sound/items/Screwdriver2.ogg", 65, 1)
				src.anchored = 0
				user.visible_message("[user] loosens the piano's castors!", "You loosen the piano's castors!")
				return
			else
				user.visible_message("[user] starts tightening the piano's castors...", "You start tightening the piano's castors...")
				if (!do_after(user, 30) || anchored != 0)
					return
				playsound(user, "sound/items/Screwdriver2.ogg", 65, 1)
				src.anchored = 1
				user.visible_message("[user] tightens the piano's castors!", "You tighten the piano's castors!")
				return

		else if (istype(W, /obj/item/crowbar)) //prying off panel
			if (is_busy)
				boutput(user, "You can't do that while the piano is running!")
				return
			if (panel_exposed == 0)
				user.visible_message("[user] starts prying off the piano's maintenance panel...", "You begin to pry off the maintenance panel...")
				if (!do_after(user, 30) || panel_exposed != 0)
					return
				playsound(user, "sound/items/Crowbar.ogg", 65, 1)
				user.visible_message("[user] prys off the piano's maintenance panel.","You pry off the maintenance panel.")
				var/obj/item/plank/P = new(get_turf(user))
				P.name = "Piano Maintenance Panel"
				P.desc = "A cover for the internal workings of a piano. Better not lose it."
				panel_exposed = 1
				update_icon()
			else
				boutput(user, "There's nothing to pry off of \the [src].")

		else if (istype(W, /obj/item/plank)) //replacing panel
			if (panel_exposed == 1 && W.name != "wooden plank" && !is_busy)
				user.visible_message("[user] starts replacing the piano's maintenance panel...", "You start replacing the piano's maintenance panel...")
				if (!do_after(user, 30) || panel_exposed != 1)
					return
				playsound(user, "sound/items/Deconstruct.ogg", 65, 1)
				user.visible_message("[user] replaces the maintenance panel!", "You replace the maintenance panel!")
				panel_exposed = 0
				update_icon(0)
				qdel(W)

		else if (istype(W, /obj/item/wirecutters)) //turning off looping... forever!
			if (is_looping == 2)
				boutput(user, "There's no wires to snip!")
				return
			user.visible_message("<span style=\"color:red\">[user] looks for the looping control wire...</span>", "You look for the looping control wire...")
			if (!do_after(user, 70) || is_looping == 2)
				return
			is_looping = 2
			playsound(user, "sound/items/Wirecutter.ogg", 65, 1)
			user.visible_message("<span style=\"color:red\">[user] snips the looping control wire!</span>", "You snip the looping control wire!")

		else if (istype(W, /obj/item/device/multitool)) //resetting piano the hard way
			if (panel_exposed == 0)
				..()
				return
			user.visible_message("<span style=\"color:red\">[user] starts pulsing random wires in the piano.</span>", "You start pulsing random wires in the piano.")
			if (!do_after(user, 30))
				return
			user.visible_message("<span style=\"color:red\">[user] pulsed a bunch of wires in the piano!</span>", "You pulsed some wires in the piano!")
			reset_piano()
		else
			..()

	attack_hand(var/mob/user as mob)
		if (is_busy)
			src.visible_message("<span style=\"color:red\">\The [src] emits an angry beep!</span>")
			return
		var/mode_sel = input("Which mode would you like?", "Mode Select") as null|anything in list("Choose Notes", "Play Song")
		if (mode_sel == "Choose Notes")
			note_input = ""
			note_input = input("Write out the notes you want to be played.", "Composition Menu", note_input)
			if (length(note_input) > 2048)//still room to get long piano songs in, but not too crazy
				src.visible_message("<span style=\"color:red\">\The [src] makes an angry whirring noise and shuts down.</span>")
				return
			clean_input(note_input) //if updating input order to have a different order, update build_notes to reflect that order
			return
		else if (mode_sel == "Play Song")
			build_notes(piano_notes)
			ready_piano()
			return
		else //just in case
			return

	verb/item_claim()
		set name = "Claim Items" // idea: emagging bathtub makes the bath spit out a photo of itself when you draw a bath?
		set src in oview(1)
		set category = "Local"
		if (items_claimed)
			src.visible_message("\The [src] has nothing in its item box to take! Drat!")
			return
		new /obj/item/piano_key(get_turf(src))
		new /obj/item/paper/book/player_piano(get_turf(src))
		items_claimed = 1
		src.visible_message("\The [src] spills out a key and a booklet! Nifty!")

	proc/clean_input(var/list/input) //breaks our big input string into chunks
		is_busy = 1
		piano_notes = list()
//		src.visible_message("<span style=\"color:blue\">\The [src] starts humming and rattling as it processes!</span>")
		var/list/split_input = splittext("[note_input]", "|")
		for (var/string in split_input)
			piano_notes += string
		is_busy = 0

	proc/build_notes(var/list/piano_notes) //breaks our chunks apart and puts them into lists on the object
		is_busy = 1
		note_volumes = list()
		note_octaves = list()
		note_names = list()
		note_accidentals = list()

		for (var/string in piano_notes)
			var/list/curr_notes = splittext("[string]", ",")
			note_names += curr_notes[1]
			switch(lowertext(curr_notes[4]))
				if ("r")
					curr_notes[4] = "r"
			note_octaves += curr_notes[4]
			switch(lowertext(curr_notes[2]))
				if ("s")
					curr_notes[2] = "s"
				if ("b")
					curr_notes[2] = "b"
				if ("n")
					curr_notes[2] = ""
				if ("r")
					curr_notes[2] = "r"
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
				if ("r")
					curr_notes[3] = 0
			note_volumes += curr_notes[3]

	proc/ready_piano() //final checks to make sure stuff is right, gets notes into a compiled form for easy playsounding
		if (note_volumes.len + note_octaves.len - note_names.len - note_accidentals.len)
			src.visible_message("<span style=\"color:red\">\The [src] makes a grumpy ratchetting noise and shuts down!</span>")
			is_busy = 0
			update_icon(0)
		song_length = note_names.len
		compiled_notes = list()
		for (var/i = 1, i <= note_names.len, i++)
			var/string = lowertext("[note_names[i]][note_accidentals[i]][note_octaves[i]]")
			compiled_notes += string
		for (var/i = 1, i <= compiled_notes.len, i++)
			var/string = "sound/piano/"
			string += "[compiled_notes[i]].ogg"
			if (!(string in soundCache))
				src.visible_message("<span style=\"color:red\">\The [src] makes an atrocious racket and beeps [i] times.</span>")
				is_busy = 0
				update_icon(0)
				return
		src.visible_message("<span style=\"color:blue\">\The [src] starts playing music!</span>")
		update_icon(1)
		play_notes()

	proc/play_notes() //how notes are handled, using while and spawn to set a very strict interval, solo piano process loop was too variable to work for music
		while (curr_note <= song_length)
			curr_note++
			if (curr_note > song_length)
				if (is_looping == 1)
					curr_note = 0
					play_notes()
					return
				is_busy = 0
				curr_note = 0
				src.visible_message("<span style=\"color:blue\">\The [src] stops playing music.</span>")
				update_icon(0)
				return
			sleep((timing * 10)) //to get delay into 10ths of a second
			var/sound_name = "sound/piano/"
			sound_name += "[compiled_notes[curr_note]].ogg"
			playsound(src, sound_name, note_volumes[curr_note],0,10,0)

	proc/play_notes_2() //this feels wrong
		play_notes()

	proc/reset_piano() //so i dont have to have duplicate code for multiool pulsing and piano key
		if (is_looping != 2)
			is_looping = 0
		timing = 0.5
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
		update_icon(0)

	proc/update_icon(var/active) //1: active, 0: inactive
		if (panel_exposed)
			icon_state = "player_piano_open"
			return
		if (active)
			icon_state = "player_piano_playing"
			return
		icon_state = "player_piano"
		return