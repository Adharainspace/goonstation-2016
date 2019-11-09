//TODO: FULLY INTEGRATE INK CARTRIDGE, ADD ACTUAL MESSAGSES AND PLAYSOUNDS

/obj/machinery/printing_press //this makes books
	name = "printing press"
	desc = "Some machinery that's supposed to be able to write on a lot of pages super quickly. It looks pretty old."
	icon = 'icons/obj/64x32.dmi' //lets immortalise =atamusvaleo= in the code forever, i miss him
	icon_state = "printing_press" //proper icon is set in update_icon
	anchored = 1
	density = 1
	bound_width = 64 //the game just handles xtra wide objects already halleluiah

	var/paper_amt = 0 //empty by default
	var/was_paper = 0 //workaround for now, need to update icon if paper_amt is 0 to clear overlay
	var/is_running = 0 //1 if its working, 0 when idle/depowered
	var/colors_upgrade = 0 //0 by default, set to 1 when ink colors upgrade is installed
	var/books_upgrade = 0 //0 by default, set to 1 when custom book covers upgrade is installed
	var/forbidden_upgrade = 0 //0 by default, set to 1 when forbidden covers/symbols/styles upgrade is installed
	var/ink_level = 100 //decrements by 1 for each book printed, can be refilled (expensively)
	var/list/press_modes = list("Choose cover", "Set book info", "Set book contents",\
	"Amount to make", "Print books") //default, can be expanded to have "Ink Colors" and "Custom Cover"

	var/book_amount = 0 //how many reams to use? (5 books per ream)
	var/book_cover = "" //what cover design to use?
	var/book_info = "" //what text will the made books have?
	var/book_name = "" //whats the made books name?
	var/info_len_lim = 64 //64 character titles/author names max
	var/book_author = "" //who made the book?
	var/ink_color = "" //what color is the text written in?
	var/list/cover_designs = list("Grey", "Dull red", "Red", "Blue", "Green", "Yellow", "Dummies", "Robuddy", "Skull", "Latch", "Bee",\
	"Albert", "Surgery", "Law", "Nuke", "Rat", "Pharma", "Bar") //list of covers to choose from
	var/list/non_writing_icons = list("Bible") //just the bible for now. add covers to this list if their icon file isnt icons/obj/writing.dmi

	var/cover_color = "#FFFFFF" //white by default, what colour will our book be?
	var/cover_symbol = "" //what symbol is on our front cover?
	var/symbol_color = "#FFFFFF" //white by default, if our symbol is colourable, what colour is it?
	var/cover_flair = "" //whats the "flair" thing on the book?
	var/flair_color = "#FFFFFF" //white by default, whats the color of the flair (if its colorable)?

	var/list/standard_symbols = list("Bee", "Blood", "Eye", "No", "Clown", "Wizhat", "CoolS", "Brimstone", "Duck", "Planet+Moon", "Sol",\
	"Candle", "Shelterbee")//symbols that cant be colored
	var/list/colorable_symbols = list("Skull", "Drop", "Shortcross", "Smile", "One", "FadeCircle", "Square", "NT", "Ghost", "Bone",\
	"Heart", "Pentagram", "Key", "Lock") //list of symbols that can be coloured
	var/list/alchemical_symbols = list("Mercury", "Salt", "Sulfur", "Urine", "Water", "Fire", "Air", "Earth", "Calcination", "Congelation",\
	"Fixation", "Dissolution", "Digestion", "Distillation", "Sublimation", "Seperation", "Ceration", "Fermentation", "Multiplication",\
	"Projection") //alchemical symbols (because theres a lot of them)
	var/list/alphanumeric_symbols = list("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S",\
	"T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
	var/list/standard_flairs = list("Gold", "Latch", "Dirty", "Scratch", "Torn") //flairs that cant be coloured
	var/list/colorable_flairs = list("Corners", "Bookmark", "RightCover", "SpineCover") //flairs that can be coloured

////////////////////
//Appearance stuff//
////////////////////

	proc/update_icon() //this runs every time something would change the amt of paper, or if its working or done working, handles paper overlay and work animation
		if (paper_amt || was_paper)
			if (GetOverlayImage("paper"))
				ClearSpecificOverlays("paper")
			var/image/I = SafeGetOverlayImage("paper", src.icon, "paper-[paper_amt]")
			src.UpdateOverlays(I, "paper")
			was_paper = 0
		if (is_running)
			flick("printing_press-work", src)
			sleep(24)
			return
		icon_state = "printing_press-idle"

	get_desc(var/dist)
		if (dist > 6)
			return
		var/press_desc = ""
		if (paper_amt)
			press_desc += "There's [paper_amt] reams of paper loaded into \the [src]."
		else
			press_desc += "There's no paper loaded into \the [src]"
		if (is_running)
			press_desc += " \The [src] is currently making books!"
		else
			press_desc += " \The [src] is currently idle."
		return press_desc

	New()
		..()
		update_icon()

/////////////////////
//Interaction stuff//
/////////////////////

	attackby(var/obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/paper_bin))
			if (W.amount >= 10.0)
				if (paper_amt < 7)
					user.visible_message("success", "success")
					paper_amt++
					update_icon()
					W.amount -= 10.0
					W:update() //it was erroring at me idk why, so i fixed it with this, i do a typecheck so its legal
					return
				else
					boutput(user, "failure") //too full
			else
				boutput(user, "failure") //not enough paper in bin
				return

		else if (istype(W, /obj/item/paper)) //i want a special error message so people know to use bins
			boutput(user, "failure")
			return

		else if (istype(W, /obj/item/press_upgrade))
			switch (W.icon_state)
				if ("press_colors")
					if (colors_upgrade)
						src.visible_message("upgrade already installed")
						return
					colors_upgrade = 1
					press_modes += "Ink color"
					src.visible_message("upgrade installed")
				if ("press_books")
					if (books_upgrade)
						src.visible_message("upgrade already installed")
						return
					books_upgrade = 1
					press_modes += "Customise cover"
					src.visible_message("upgrade installed")
				if ("press_forbidden")
					if (forbidden_upgrade)
						src.visible_message("upgrade already installed")
						return
					forbidden_upgrade = 1
					standard_symbols += list("Anarchy", "Syndie")
					colorable_symbols += list("FixMe")
					standard_flairs += list("Fire")
					cover_designs += list("Necronomicon", "Old", "Bible")
/*					cover_designs += "Old"
					cover_designs += "Bible"*/
					src.visible_message("upgrade installed")
				if ("press_ink")
					if (ink_level < 500) //500ink internal resevoir
						ink_level += 100
						src.visible_message("ink refilled")
					else
						src.visible_message("too full for a refill")
						return
				else //in case some wiseguy tries the parent im watching u
					src.visible_message("no good, asshole")
					return
			qdel(W)
//			playsound

		else
			boutput(user, "failure")

	attack_hand(var/mob/user as mob) //all of our mode controls and setters here, these control what the books are/look like/have as contents
		if (is_running)
			src.visible_message("busy") //machine is running
			return
		var/mode_sel = input("What would you like to do?", "Mode Control") as null|anything in press_modes
		if (!mode_sel) //just in case? idk if this is necessary
			return

		switch (lowertext(mode_sel))

			if ("choose cover")
				var/cover_sel = input("What cover design would you like?", "Cover Control") as null|anything in cover_designs
/*				if (!cover_sel)
					return*/
				switch (lowertext(cover_sel))
					if ("grey")
						book_cover = "book0"
					if ("dull red")
						book_cover = "book1"
					if ("red")
						book_cover = "book7"
					if ("blue")
						book_cover = "book2"
					if ("green")
						book_cover = "book3"
					if ("yellow")
						book_cover = "book6"
					if ("dummies")
						book_cover = "book4"
					if ("robuddy")
						book_cover = "book5"
					if ("skull")
						book_cover = "sbook"
					if ("latch")
						book_cover = "bookcc"
					if ("bee")
						book_cover = "booktth"
					if ("albert")
						book_cover = "bookadps"
					if ("surgery")
						book_cover = "surgical_textbook"
					if ("law")
						book_cover = "spacelaw"
					if ("nuke")
						book_cover = "nuclearguide"
					if ("rat")
						book_cover = "ratbook"
					if ("pharma")
						book_cover = "pharmacopia"
					if ("bar")
						book_cover = "barguide"
					if ("necronomicon")
						book_cover = "necronomicon"
					if ("bible")
						book_cover = "bible"
					if ("old")
						book_cover = "bookkiy"
					else
						book_cover = "book0"
				src.visible_message("successful")
				return

			if ("set book info")
				var/name_sel = input("What do you want the title of your book to be?", "Information Control") //total information control! the patriots control the memes, snake!
/*				if (!name_sel)
					return*/
				if (length(name_sel) > info_len_lim)
					src.visible_message("too long")
					return
				book_name = name_sel
				var/author_sel = input("Who is the author of your book?", "Information Control")
/*				if (!author_sel)
					return*/
				if (length(author_sel) > info_len_lim)
					src.visible_message("too long")
					return
				book_author = author_sel
				return

			if ("set book contents")
				var/info_sel = input("What do you want your book to say?", "Content Control", null) as null|message
				if (!info_sel)
					return
				info_sel = copytext(html_encode(info_sel), 1, 4*MAX_MESSAGE_LEN) //for now this is ~700 words, 4096 characters, please increase if people say that its too restrictive/low
				info_sel = replacetext(info_sel, "\n", "<BR>")
				info_sel = replacetext(info_sel, "\[b\]", "<B>")
				info_sel = replacetext(info_sel, "\[/b\]", "</B>")
				info_sel = replacetext(info_sel, "\[i\]", "<I>")
				info_sel = replacetext(info_sel, "\[/i\]", "</I>")
				info_sel = replacetext(info_sel, "\[u\]", "<U>")
				info_sel = replacetext(info_sel, "\[/u\]", "</U>")
				info_sel = replacetext(info_sel, "\[hr\]", "<HR>")
				info_sel = replacetext(info_sel, "\[/hr\]", "</HR>")
				info_sel = replacetext(info_sel, "\[sup\]", "<SUP>")
				info_sel = replacetext(info_sel, "\[/sup\]", "</SUP>")
				info_sel = replacetext(info_sel, "\[h1\]", "<H1>")
				info_sel = replacetext(info_sel, "\[/h1\]", "</H1>")
				info_sel = replacetext(info_sel, "\[h2\]", "<H2>")
				info_sel = replacetext(info_sel, "\[/h2\]", "</H2>")
				info_sel = replacetext(info_sel, "\[h3\]", "<H3>")
				info_sel = replacetext(info_sel, "\[/h3\]", "</H3>")
				info_sel = replacetext(info_sel, "\[h4\]", "<H4>")
				info_sel = replacetext(info_sel, "\[/h4\]", "</H4>")
				info_sel = replacetext(info_sel, "\[li\]", "<LI>")
				info_sel = replacetext(info_sel, "\[/li\]", "</LI>")
				info_sel = replacetext(info_sel, "\[bq\]", "<BLOCKQUOTE>")
				info_sel = replacetext(info_sel, "\[/bq\]", "</BLOCKQUOTE>")
				book_info = info_sel
				return

			if ("amount to make")
				var/amount_sel = input("How many reams do you want to use? (1 ream = 5 books, 1 book = 0 < amount < 1)", "Ream Control") as num
				if (amount_sel > paper_amt)
					src.visible_message("not enough paper")
					return
				if (amount_sel > 0 && amount_sel < 7) //was the number they put in any good?
					if (amount_sel > 0 && amount_sel < 1) //is it between 0 and 1?
						book_amount = -1 //special value, tells press to only make 1
					else
						book_amount = amount_sel

			if ("print books")
				if (is_running)
					src.visible_message("busy")
					return
				if (!book_amount)
					src.visible_message("set an amount")
					return
				if ((book_amount * 5) > ink_level)
					src.visible_message("not enough ink")
					return
				logTheThing("say", user, null, "made some books with the name: [book_name] | the author: [book_author] | the contents: [book_info]") //book logging
				make_books()
				return

			if ("ink color")
				if (colors_upgrade) //can never be too safe
					var/color_sel = input("What colour would you like the ink to be?", "Ink Control") as color
					if (color_sel)
						ink_color = color_sel

			if ("customise cover")
				if (books_upgrade) //can never be too safe
					book_cover = "custom" //so we can bypass normal cover selection in the bookmaking process
					var/cover_color_sel = input("What colour would you like the cover to be?", "Cover Control") as color
					if (cover_color_sel)
						cover_color = cover_color_sel

					var/s_cat_sel = input("What type of symbol would you like?", "Cover Control") as null|anything in list("Standard", "Colorable", "Alchemical", "Alphanumeric")
					switch (lowertext(s_cat_sel))
						if ("standard")
							var/symbol_sel = input("What would you like the symbol to be?", "Cover Control") as null|anything in standard_symbols
							if (symbol_sel)
								cover_symbol = lowertext(symbol_sel)

						if ("colorable")
							var/symbol_sel = input("What would you like the symbol to be?", "Cover Control") as null|anything in colorable_symbols
							if (symbol_sel)
								cover_symbol = lowertext(symbol_sel)
								var/color_sel = input("What color would you like the symbol to be?", "Cover Control") as color
								if (color_sel)
									symbol_color = color_sel

						if ("alchemical")
							var/symbol_sel = input("What would you like the symbol to be?", "Cover Control") as null|anything in alchemical_symbols
							if (symbol_sel)
								cover_symbol = lowertext(symbol_sel)

						if ("alphanumeric")
							var/symbol_sel = input("What would you like the symbol to be?", "Cover Control") as null|anything in alphanumeric_symbols
							if (symbol_sel)
								cover_symbol = lowertext(symbol_sel)
								var/color_sel = input("What color would you like the symbol to be?", "Cover Control") as color
								if (color_sel)
									symbol_color = color_sel

					var/f_cat_sel = input("What type of flair would you like?", "Cover Control") as null|anything in list("Standard", "Colorable")

					if (f_cat_sel == "Standard")
						var/flair_sel = input("What would you like the flair to be?", "Cover Control") as null|anything in standard_flairs
						if (flair_sel)
							cover_flair = lowertext(flair_sel)

					else if (f_cat_sel == "Colorable")
						var/flair_sel = input("What would you like the flair to be?", "Cover Control") as null|anything in colorable_flairs
						if (flair_sel)
							var/color_sel = input("What color would you like the flair to be?", "Cover Control") as color
							if (color_sel)
								flair_color = color_sel
			else //just in case, yell at me if this is bad
				return

/////////////////////
//Book making stuff//
/////////////////////

	proc/make_books() //alright so this makes our books
		is_running = 1
		var/books_to_make = book_amount * 5
		if (books_to_make == -5)
			books_to_make = 1
		while (books_to_make)
			update_icon()
//			playsound
			if (!(books_to_make % 5)) //every 5 books take away 1 sheet
				paper_amt--
				if (!paper_amt)
					was_paper = 1
			var/obj/item/paper/book/B = new(get_turf(src))

			if (book_name)
				B.name = book_name
			else
				B.name = "unnamed book"

			B.desc = "A book printed by a machine! The future is now! (if you lived in the 15th century)"
			if (book_author)
				B.desc += " It says it was written by [book_author]."
			else
				B.desc += " It says it was written by... anonymous."

			if (book_cover)
				if (book_cover == "custom")
					B.icon = 'icons/obj/custom_books.dmi'
					B.icon_state = "paper"
					if (cover_color) //should always be yes
						var/image/I = SafeGetOverlayImage("cover", B.icon, "base-colorable")
						I.color = cover_color
						B.UpdateOverlays(I, "cover")
					if (cover_symbol)
						var/image/I = SafeGetOverlayImage("symbol", B.icon, "symbol-[cover_symbol]")
						if (symbol_color)
							I.color = symbol_color
						B.UpdateOverlays(I, "symbol")
					if (cover_flair)
						var/image/I = SafeGetOverlayImage("flair", B.icon, "flair-[cover_flair]")
						if (flair_color)
							I.color = flair_color
						B.UpdateOverlays(I, "flair")
				else
					if (book_cover in non_writing_icons) //for our non-writing.dmi icons
						switch (book_cover)
							if ("bible")
								B.icon = 'icons/obj/storage.dmi'
								B.icon_state = book_cover
					else
						B.icon_state = book_cover
			else
				B.icon_state = "book0"

			if (book_info)
				if (ink_color)
					B.info = "<span style=\"color:[ink_color]\">[book_info]</span>"
				else
					B.info = book_info

			books_to_make--
			ink_level--

		is_running = 0
		update_icon() //just in case?

/obj/item/press_upgrade //parent just to i dont have to set name and icon twice i am PEAK lazy
	name = "printing press upgrade module"
	icon = 'icons/obj/module.dmi'

/obj/item/press_upgrade/colors //custom font color upgrade
	desc = "Looks like this upgrade module is for letting your press use colored ink!"
	icon_state = "press_colors"

/obj/item/press_upgrade/books //custom covers upgrade
	desc = "Looks like this upgrade module is for letting your press customise book covers!"
	icon_state = "press_books"

/obj/item/press_upgrade/ink //using press_upgrade so i dont have to set icon i really am the laziest bitch
	name = "ink cartridge"
	desc = "Looks like this is an ink restock cartridge for the printing press!"
	icon_state = "press_ink"

/obj/item/press_upgrade/forbidden
	name = "bootleg printing press upgrade module"
	desc = "This press upgrade looks sketchy as fuck."
	icon_state = "press_forbidden"