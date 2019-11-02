/obj/machinery/printing_press //this makes books
	name = "printing press"
	desc = "Some machinery that's supposed to be able to write on a lot of pages super quickly. It looks pretty old."
	icon = 'icons/obj/64x32.dmi' //lets immortalise =atamusvaleo= in the code forever, i miss him
	icon_state = "printing_press" //proper icon is set in update_icon
	anchored = 1
	density = 1
	bound_width = 64
	var/paper_amt = 0 //empty by default
	var/was_paper = 0 //workaround for now, need to update icon if paper_amt is 0 to clear overlay
	var/is_running = 0 //1 if its working, 0 when idle/depowered
	var/book_amount = 0 //how many reams to use? (5 books per ream)
	var/book_cover = "" //what cover design to use?
//	var/greyscale_color = "" //for greyscale books?
	var/book_info = "" //what text will the made books have?
	var/book_name = "" //whats the made books name?
	var/info_len_lim = 64 //64 character titles/author names max
	var/book_author = "" //who made the book?
	var/list/cover_designs = list("Grey", "Dull red", "Red", "Blue", "Green", "Yellow", "Dummies", "Robuddy", "Skull", "Old", "Latch", "Bee"/*, "Custom"*/) //easier editing as a var

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
					W:update() //it was erroring at me idk why but this works
					return
				else
					boutput(user, "failure") //too full
			else
				boutput(user, "failure") //not enough paper in bin
				return
		else if (istype(W, /obj/item/paper))
			boutput(user, "failure")
			return
		else
			boutput(user, "failure")

	attack_hand(var/mob/user as mob) //all of our mode controls and setters here, these control what the books are/look like/have as contents
		if (is_running)
			src.visible_message("busy") //machine is running
			return
		var/mode_sel = input("What would you like to do?", "Mode Control") as null|anything in list("Choose cover", "Set book info", "Set book contents", "Amount to make", "Print books")
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
					if ("old")
						book_cover = "bookkiy"
					if ("latch")
						book_cover = "bookcc"
					if ("bee")
						book_cover = "booktth"
//					if ("custom") custom book junk
					else
						book_cover = "book0"
				src.visible_message("successful")
				return

			if ("set book info")
				var/name_sel = input("What do you want the title of your book to be?", "Information Control") //total information control! the patriots have the memes on lockdown, snake!
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
				var/amount_sel = input("How many reams do you want to use? (1 ream = 5 books)", "Ream Control") as num
				if (amount_sel > paper_amt)
					src.visible_message("not enough paper")
					return
				book_amount = amount_sel

			if ("print books")
				if (is_running)
					src.visible_message("busy")
					return
				logTheThing("say", user, null, "made some books with the name: [book_name] | the author: [book_author] | the contents: [book_info]") //book logging
				make_books()
				return

			else //just in case too, yell at me if this is bad
				return


/////////////////////
//Book making stuff//
/////////////////////

	proc/make_books() //alright so this makes our books
		is_running = 1
		var/books_to_make = book_amount * 5
		while (books_to_make)
			update_icon()
//			playsound
			if (books_to_make % 5) //every 5 books take away 1 sheet
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
				if (B.icon_state == "custom")
					B.icon_state = "custom"
				else
					B.icon_state = book_cover
			else
				B.icon_state = "book0"
			if (book_info)
				B.info = book_info
			books_to_make--
		update_icon() //just in case?
		is_running = 0