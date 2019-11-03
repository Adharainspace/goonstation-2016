/obj/bookshelf
	name = "bookshelf"
	desc = "A storage unit designed to fit a lot of books. Been a while since you've seen one of these!"
	icon = 'icons/obj/bookshelf.dmi'
	icon_state = "bookshelf_empty"
	anchored = 1
	density = 1
	var/variant = 1 //just used for normal shelves
	var/update_icon_suffix = "" //set to either "1" or "2" in New()
	var/capacity = 17 //how many books can it hold?
	var/top_shelf_cap = 6
	var/middle_shelf_cap = 5
	var/bottom_shelf_cap = 6
	var/list/bookshelf_contents = list() //idk if its important to have ordered bookshelf contents?

	New()
		..()
		if (variant)
			update_icon_suffix = "[rand(1,2)]"

	proc/add_to_bookshelf(var/obj/item/W)
		bookshelf_contents += W
		W.set_loc(src)

	proc/take_off_bookshelf(var/obj/item/W)
		bookshelf_contents -= W
		W.set_loc(get_turf(src))

///////////////////////////////////////////////
//icon crap its garbage just dont look ok? ok//
///////////////////////////////////////////////

//okay so let me explain all this huge junk below
//each bookshelf has a different filled with books icon
//and i want each shelf, as it gets more books, to fill up with books at the same rate
//so what this whole mess is intended to do is see how many books there are on the bookshelf
//then it breaks that up shelf by shelf and crops our full bookshelf icon to fit that shelf
//in the case of sideways books stacked on top of eachother, theres a special return case in book_overlay_logic_center that deals with it
//so what ive done is made it so that update_icon will never have to be overwritten by children of update_icon, so it cuts down on duplicate code
//and the only thing that needs to be overwritten on children is book_overlay_logic_center
//but what this basically means is that this whole thing is messy and probably buggy and unoptimised and im sorry if my code is unreadable
//please ping me or dm me on discord if its really gross and bad and youre lost and ill try to explain why i did things the way i did
//dont be afraid to ask me to make it better too if you see something really dumb and obtuse, ill try to fix it
//its just really gross and awful and i think i was posessed by some spirit when i wrote it (please blame the ghosts ok)
//~adhara <3

	proc/update_icon()

		ClearSpecificOverlays("top_shelf", "middle_shelf", "bottom_shelf") //lets avoid any weird icon ghosts
		if (bookshelf_contents.len <= top_shelf_cap) //top shelf only
			var/icon/top = new(src.icon, "bookshelf_full_[update_icon_suffix]") //SafeGetOverlayImage("top_shelf", src.icon, "bookshelf_full_[update_icon_suffix]")
			var/list/top_crop = book_overlay_logic_center(bookshelf_contents.len) //calls our crop proc, it returns a list of pixels that we crop to
			if ("sideways" in top_crop) //some shelves have sideways books, i have custom icons for that scenario that we'll use instead of a crop
				if (bookshelf_contents.len == 1)
					var/image/I = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_1")
					UpdateOverlays(I, "top_shelf")
					return
				else
					var/image/I = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_2")
					UpdateOverlays(I, "top_shelf")
					return
			top.Crop(top_crop[1], top_crop[2], top_crop[3], top_crop[4])
			var/image/top_image = top
			switch(update_icon_suffix) //this is how we redo offsets that are lost with Crop()
				if ("1")
					top_image.pixel_x += 7
					top_image.pixel_y += 17
				if ("2")
					top_image.pixel_x += 7
					top_image.pixel_y += 17
				if ("wall")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 16)
				if ("L")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 16)
				if ("R")
					top.Shift(EAST, 1)
					top.Shift(NORTH, 16)
			UpdateOverlays(top_image, "top_shelf")

		else if (bookshelf_contents.len <= (top_shelf_cap + middle_shelf_cap)) //top and mid
			var/icon/top = new(src.icon, "bookshelf_full_[update_icon_suffix]")
			var/list/top_crop = book_overlay_logic_center(top_shelf_cap)
			if ("sideways" in top_crop)
				if (bookshelf_contents.len == 1)
					var/image/I = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_1")
					UpdateOverlays(I, "top_shelf")
					return
				else
					var/image/I = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_2")
					UpdateOverlays(I, "top_shelf")
					return
			top.Crop(top_crop[1], top_crop[2], top_crop[3], top_crop[4])
			switch(update_icon_suffix)
				if ("1")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 17)
				if ("2")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 17)
				if ("wall")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 16)
				if ("L")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 16)
				if ("R")
					top.Shift(EAST, 1)
					top.Shift(NORTH, 16)
			UpdateOverlays(top, "top_shelf")
			var/icon/middle = new(src.icon, "bookshelf_full_[update_icon_suffix]")
			var/list/middle_crop = book_overlay_logic_center(bookshelf_contents.len)
			if ("sideways" in middle_crop)
				switch(bookshelf_contents.len)
					if (8)
						var/image/I = SafeGetOverlayImage("middle_shelf", src.icon, "2_sideways_3")
						UpdateOverlays(I, "middle_shelf")
						return
					if (9)
						var/image/I = SafeGetOverlayImage("middle_shelf", src.icon, "2_sideways_4")
						UpdateOverlays(I, "middle_shelf")
						return
					if (10)
						var/image/I = SafeGetOverlayImage("middle_shelf", src.icon, "wall_sideways_1")
						UpdateOverlays(I, "middle_shelf")
						return
					if (11)
						var/image/I = SafeGetOverlayImage("middle_shelf", src.icon, "wall_sideways_2")
						UpdateOverlays(I, "middle_shelf")
						return
			middle.Crop(middle_crop[1], middle_crop[2], middle_crop[3], middle_crop[4])
			switch(update_icon_suffix)
				if ("1")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 10)
				if ("2")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 10)
				if ("wall")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 9)
				if ("L")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 9)
				if ("R")
					top.Shift(EAST, 1)
					top.Shift(NORTH, 9)
			UpdateOverlays(middle, "middle_shelf")

		else //top, mid, bottom shelves
			var/icon/top = new(src.icon, "bookshelf_full_[update_icon_suffix]")
			var/list/top_crop = book_overlay_logic_center(top_shelf_cap)
			if ("sideways" in top_crop)
				if (bookshelf_contents.len == 1)
					var/image/I = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_1")
					UpdateOverlays(I, "top_shelf")
					return
				else
					var/image/I = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_2")
					UpdateOverlays(I, "top_shelf")
					return
			top.Crop(top_crop[1], top_crop[2], top_crop[3], top_crop[4])
			switch(update_icon_suffix)
				if ("1")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 17)
				if ("2")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 17)
				if ("wall")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 16)
				if ("L")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 16)
				if ("R")
					top.Shift(EAST, 1)
					top.Shift(NORTH, 16)
			UpdateOverlays(top, "top_shelf")
			var/icon/middle = new(src.icon, "bookshelf_full_[update_icon_suffix]")
			var/list/middle_crop = book_overlay_logic_center(middle_shelf_cap)
			if ("sideways" in middle_crop)
				switch(bookshelf_contents.len)
					if (8)
						var/image/I = SafeGetOverlayImage("middle_shelf", src.icon, "2_sideways_3")
						UpdateOverlays(I, "middle_shelf")
						return
					if (9)
						var/image/I = SafeGetOverlayImage("middle_shelf", src.icon, "2_sideways_4")
						UpdateOverlays(I, "middle_shelf")
						return
					if (10)
						var/image/I = SafeGetOverlayImage("middle_shelf", src.icon, "wall_sideways_1")
						UpdateOverlays(I, "middle_shelf")
						return
					if (11)
						var/image/I = SafeGetOverlayImage("middle_shelf", src.icon, "wall_sideways_2")
						UpdateOverlays(I, "middle_shelf")
						return
			middle.Crop(middle_crop[1], middle_crop[2], middle_crop[3], middle_crop[4])
			switch(update_icon_suffix)
				if ("1")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 10)
				if ("2")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 10)
				if ("wall")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 9)
				if ("L")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 9)
				if ("R")
					top.Shift(EAST, 1)
					top.Shift(NORTH, 9)
			UpdateOverlays(middle, "middle_shelf")
			var/icon/bottom = new(src.icon, "bookshelf_full_[update_icon_suffix]")
			var/list/bottom_crop = book_overlay_logic_center(bookshelf_contents.len)
			if ("sideways" in bottom_crop)
				if (bookshelf_contents.len == 26)
					var/image/I = SafeGetOverlayImage("bottom_shelf", src.icon, "wall_sideways_3")
					UpdateOverlays(I, "bottom_shelf")
					return
				else
					var/image/I = SafeGetOverlayImage("bottom_shelf", src.icon, "wall_sideways_4")
					UpdateOverlays(I, "bottom_shelf")
					return
			bottom.Crop(bottom_crop[1], bottom_crop[2], bottom_crop[3], bottom_crop[4])
			switch(update_icon_suffix)
				if ("1")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 3)
				if ("2")
					top.Shift(EAST, 7)
					top.Shift(NORTH, 3)
				if ("wall")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 2)
				if ("L")
					top.Shift(EAST, 0)
					top.Shift(NORTH, 2)
				if ("R")
					top.Shift(EAST, 1)
					top.Shift(NORTH, 2)
			UpdateOverlays(bottom, "bottom_shelf")

	proc/book_overlay_logic_center(var/book_count) //we will need to overwrite this for each seperate shelf, but ONLY this proc, standardisation baby
		if (update_icon_suffix == "1")
			switch(book_count)
				if (1)
					return list(7,16,9,21)
				if (2)
					return list(7,16,12,21)
				if (3)
					return list(7,16,16,21)
				if (4)
					return list(7,16,19,21)
				if (5)
					return list(7,16,22,21)
				if (6)
					return list(7,16,25,21)
				if (7)
					return list(7,9,10,14)
				if (8)
					return list(7,9,14,14)
				if (9)
					return list(7,9,18,14)
				if (10)
					return list(7,9,21,14)
				if (11)
					return list(7,9,25,14)
				if (12)
					return list (7,2,9,7)
				if (13)
					return list (7,2,12,7)
				if (14)
					return list (7,2,16,7)
				if (15)
					return list (7,2,19,7)
				if (16)
					return list (7,2,22,7)
				if (17)
					return list (7,2,25,7)
		else
			switch(book_count)
				if (1)
					return list("sideways")
				if (2)
					return list("sideways")
				if (3)
					return list(7,16,15,21)
				if (4)
					return list(7,16,19,21)
				if (5)
					return list(7,16,22,21)
				if (6)
					return list(7,16,25,21)
				if (7)
					return list(7,9,12,14)
				if (8)
					return list("sideways")
				if (9)
					return list("sideways")
				if (10)
					return list(7,9,21,14)
				if (11)
					return list(7,9,25,14)
				if (12)
					return list(7,2,9,7)
				if (13)
					return list(7,2,13,7)
				if (14)
					return list(7,2,16,7)
				if (15)
					return list(7,2,19,7)
				if (16)
					return list(7,2,22,7)
				if (17)
					return list(7,2,25,7)

///////////////////////////////////
//you can look again now its over//
///////////////////////////////////

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/paper/book))
			if (!(bookshelf_contents.len >= capacity))
				boutput(user, "you shelf the book")
				user.drop_item()
				add_to_bookshelf(W)
				update_icon()
			else
				boutput(user, "too full")
		else
			boutput(user, "not a book")

	attack_hand(mob/user as mob)
		if (bookshelf_contents.len > 0)
			var/book_sel = input("What book would you like to take off \the [src]?", "[src]") as null|anything in bookshelf_contents
			if (!book_sel)
				return
			boutput(user, "you deshelf the book")
			take_off_bookshelf(book_sel)
			user.put_in_hand_or_drop(book_sel)
			update_icon()

/obj/bookshelf/long
	icon_state = "bookshelf_empty_long"
	variant = 0
	update_icon_suffix = "wall"
	capacity = 29

/obj/bookshelf/long/end_left
	icon_state = "bookshelf_empty_end-L"
	update_icon_suffix = "L"
	capacity = 27

/obj/bookshelf/long/end_right
	icon_state = "bookshelf_empty_end-R"
	update_icon_suffix = "R"
	capacity = 27