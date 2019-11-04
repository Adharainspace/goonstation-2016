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

//sorry this whole thing is a bit messy but i commented the first part so hopefully its easier to understand?
//only reason i did it like this is i felt like having 100+ iconstates would be really dumb and hard to work with
//this is polished up A LOT from the last version
//~adhara <3

	proc/update_icon()
		ClearSpecificOverlays("top_shelf", "middle_shelf", "bottom_shelf") //lets avoid any weird ghosts
		var/image/top_image = null //initialise these 3 so we can set them inside of the conditionals
		var/image/middle_image = null
		var/image/bottom_image = null

		if (bookshelf_contents.len) //were almost always drawing the top shelf
			var/icon/top = new(src.icon, "bookshelf_full_[update_icon_suffix]") //makes a new icon that we can crop from the full bookshelf icon
			var/list/top_crop = list() //creating this rn so we can modify it in an if thing while also being able to reference it outside of those ifs
			if (bookshelf_contents.len > top_shelf_cap) //lets see how to call our crop location proc, it returns a list of pixels that we crop to
				top_crop = book_overlay_logic_center(top_shelf_cap) //if theres more books on the shelf than on the top row, just generate the top row
			else
				top_crop = book_overlay_logic_center(bookshelf_contents.len) //if theres less than the shelf capacity, lets get the pixel locations for that
			if ("sideways" in top_crop) //some shelves have sideways books, i have custom icons for that scenario that we'll use instead of a crop
				if (bookshelf_contents.len == 1) //values for which there are sideways books in the full book icon
					top_image = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_1")
				else
					top_image = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_2")
			else
				top.Crop(top_crop[1], top_crop[2], top_crop[3], top_crop[4]) //this crops our icon, but it resets offsets back to 1,1
				top_image = image(top) //sets the image we made at the beginning to our cropped icon, we'll fix the offsets later

		if (bookshelf_contents.len > top_shelf_cap) //is the top shelf full? move onto the middle shelf
			var/icon/middle = new(src.icon, "bookshelf_full_[update_icon_suffix]")
			var/list/middle_crop = list()
			if (bookshelf_contents.len > middle_shelf_cap)
				middle_crop = book_overlay_logic_center(top_shelf_cap + middle_shelf_cap)
			else
				middle_crop = book_overlay_logic_center(bookshelf_contents.len)
			if ("sideways" in middle_crop)
				switch(bookshelf_contents.len)
					if (8)
						middle_image = SafeGetOverlayImage("middle_shelf", src.icon, "2_sideways_3")
					if (9)
						middle_image = SafeGetOverlayImage("middle_shelf", src.icon, "2_sideways_4")
					if (10)
						middle_image = SafeGetOverlayImage("middle_shelf", src.icon, "wall_sideways_1")
					if (11)
						middle_image = SafeGetOverlayImage("middle_shelf", src.icon, "wall_sideways_2")
			else
				middle.Crop(middle_crop[1], middle_crop[2], middle_crop[3], middle_crop[4])
				middle_image = image(middle)

		if (bookshelf_contents.len > middle_shelf_cap) //is the middle shelf full? move onto the bottom shelf
			var/icon/bottom = new(src.icon, "bookshelf_full_[update_icon_suffix]")
			var/list/bottom_crop = book_overlay_logic_center(bookshelf_contents.len) //dont need the if because the bottom shelf is the last shelf!!
			if ("sideways" in bottom_crop)
				if (bookshelf_contents.len == 26)
					bottom_image = SafeGetOverlayImage("bottom_shelf", src.icon, "wall_sideways_3")
				else
					bottom_image = SafeGetOverlayImage("bottom_shelf", src.icon, "wall_sideways_4")
			else
				bottom.Crop(bottom_crop[1], bottom_crop[2], bottom_crop[3], bottom_crop[4])
				bottom_image = image(bottom)

		if (top_image) //now we handle offsets and updating the icon
			switch(update_icon_suffix) //theres so many variants with different pixel offsets that this is best, i think
				if ("1")
					top_image.pixel_x += 6
					top_image.pixel_y += 15
				if ("2")
					top_image.pixel_x += 6
					top_image.pixel_y += 15
				if ("wall")
					top_image.pixel_y += 16
				if ("L")
					top_image.pixel_y += 16
				if ("R")
					top_image.pixel_x += 1
					top_image.pixel_y += 16
			UpdateOverlays(top_image, "top_shelf")

		if (middle_image)
			switch(update_icon_suffix)
				if ("1")
					middle_image.pixel_x += 6
					middle_image.pixel_y += 8
				if ("2")
					middle_image.pixel_x += 6
					middle_image.pixel_y += 8
				if ("wall")
					middle_image.pixel_y += 9
				if ("L")
					middle_image.pixel_y += 9
				if ("R")
					middle_image.pixel_x += 1
					middle_image.pixel_y += 9
			UpdateOverlays(middle_image, "middle_shelf")

		if (bottom_image)
			switch(update_icon_suffix)
				if ("1")
					bottom_image.pixel_x += 6
					bottom_image.pixel_y += 1
				if ("2")
					bottom_image.pixel_x += 6
					bottom_image.pixel_y += 1
				if ("wall")
					bottom_image.pixel_y += 2
				if ("L")
					bottom_image.pixel_y += 2
				if ("R")
					bottom_image.pixel_x += 1
					bottom_image.pixel_y += 2
			UpdateOverlays(bottom_image, "bottom_shelf")

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
	top_shelf_cap = 9
	middle_shelf_cap = 10
	bottom_shelf_cap = 10
	capacity = 29

	book_overlay_logic_center(var/book_count)
		switch(book_count)
			if (1)
				return list(1,17,3,22)
			if (2)
				return list(1,17,7,22)
			if (3)
				return list(1,17,10,22)
			if (4)
				return list(1,17,14,22)
			if (5)
				return list(1,17,17,22)
			if (6)
				return list(1,17,20,22)
			if (7)
				return list(1,17,26,22)
			if (8)
				return list(1,17,29,22)
			if (9)
				return list(1,17,32,22)
			if (10)
				return list("sideways")
			if (11)
				return list("sideways")
			if (12)
				return list(1,10,10,15)
			if (13)
				return list(1,10,13,15)
			if (14)
				return list(1,10,16,15)
			if (15)
				return list(1,10,19,15)
			if (16)
				return list(1,10,22,15)
			if (17)
				return list(1,10,25,15)
			if (18)
				return list(1,10,29,15)
			if (19)
				return list(1,10,32,15)
			if (20)
				return list(1,3,3,8)
			if (21)
				return list(1,3,6,8)
			if (22)
				return list(1,3,9,8)
			if (23)
				return list(1,3,12,8)
			if (24)
				return list(1,3,16,8)
			if (25)
				return list(1,3,19,8)
			if (26)
				return list("sideways")
			if (27)
				return list("sideways")
			if (28)
				return list(1,3,28,8)
			if (29)
				return list(1,3,32,8)

/obj/bookshelf/long_end_left
	icon_state = "bookshelf_empty_end_L"
	update_icon_suffix = "L"
	top_shelf_cap = 9
	middle_shelf_cap = 9
	bottom_shelf_cap = 9
	capacity = 27

	book_overlay_logic_center(var/book_count)
		switch(book_count)
			if (1)
				return list(2,17,4,22)
			if (2)
				return list(2,17,7,22)
			if (3)
				return list(2,17,11,22)
			if (4)
				return list(2,17,14,22)
			if (5)
				return list(2,17,17,22)
			if (6)
				return list(2,17,21,22)
			if (7)
				return list(2,17,24,22)
			if (8)
				return list(2,17,28,22)
			if (9)
				return list(2,17,32,22)
			if (10)
				return list(2,10,4,15)
			if (11)
				return list(2,10,8,15)
			if (12)
				return list(2,10,11,15)
			if (13)
				return list(2,10,14,15)
			if (14)
				return list(2,10,17,15)
			if (15)
				return list(2,10,20,15)
			if (16)
				return list(2,10,24,15)
			if (17)
				return list(2,10,28,15)
			if (18)
				return list(2,10,32,15)
			if (19)
				return list(2,3,5,8)
			if (20)
				return list(2,3,8,8)
			if (21)
				return list(2,3,12,8)
			if (22)
				return list(2,3,15,8)
			if (23)
				return list(2,3,19,8)
			if (24)
				return list(2,3,22,8)
			if (25)
				return list(2,3,25,8)
			if (26)
				return list(2,3,28,8)
			if (27)
				return list(2,3,32,8)

/obj/bookshelf/long_end_right
	icon_state = "bookshelf_empty_end_R"
	update_icon_suffix = "R"
	top_shelf_cap = 9
	middle_shelf_cap = 9
	bottom_shelf_cap = 9
	capacity = 27

	book_overlay_logic_center(var/book_count)
		switch(book_count)
			if (1)
				return list(1,17,4,22)
			if (2)
				return list(1,17,7,22)
			if (3)
				return list(1,17,10,22)
			if (4)
				return list(1,17,13,22)
			if (5)
				return list(1,17,16,22)
			if (6)
				return list(1,17,20,22)
			if (7)
				return list(1,17,23,22)
			if (8)
				return list(1,17,27,22)
			if (9)
				return list(1,17,31,22)
			if (10)
				return list(1,10,3,15)
			if (11)
				return list(1,10,7,15)
			if (12)
				return list(1,10,11,15)
			if (13)
				return list(1,10,15,15)
			if (14)
				return list(1,10,19,15)
			if (15)
				return list(1,10,22,15)
			if (16)
				return list(1,10,25,15)
			if (17)
				return list(1,10,28,15)
			if (18)
				return list(1,10,31,15)
			if (19)
				return list(1,3,4,8)
			if (20)
				return list(1,3,8,8)
			if (21)
				return list(1,3,11,8)
			if (22)
				return list(1,3,14,8)
			if (23)
				return list(1,3,18,8)
			if (24)
				return list(1,3,21,8)
			if (25)
				return list(1,3,24,8)
			if (26)
				return list(1,3,27,8)
			if (27)
				return list(1,3,31,8)

/*		ClearSpecificOverlays("top_shelf", "middle_shelf", "bottom_shelf") //lets avoid any weird icon ghosts
		if (bookshelf_contents.len <= top_shelf_cap) //top shelf only
			var/icon/top = new(src.icon, "bookshelf_full_[update_icon_suffix]") //
			var/list/top_crop = book_overlay_logic_center(bookshelf_contents.len) //calls our crop proc, it returns a list of pixels that we crop to
			if ("sideways" in top_crop) //some shelves have sideways books, i have custom icons for that scenario that we'll use instead of a crop
				if (bookshelf_contents.len == 1) //values for which there are sideways books in the full book icon
					var/image/I = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_1")
					UpdateOverlays(I, "top_shelf")
					return
				else
					var/image/I = SafeGetOverlayImage("top_shelf", src.icon, "2_sideways_2")
					UpdateOverlays(I, "top_shelf")
					return
			top.Crop(top_crop[1], top_crop[2], top_crop[3], top_crop[4])
			var/image/top_image = image(top) //turn out icon into an image so we can offset it
			switch(update_icon_suffix) //this is how we redo offsets that are lost with Crop()
				if ("1")
					top_image.pixel_x += 6
					top_image.pixel_y += 15
				if ("2")
					top_image.pixel_x += 6
					top_image.pixel_y += 15
				if ("wall")
					top_image.pixel_y += 16
				if ("L")
					top_image.pixel_y += 16
				if ("R")
					top_image.pixel_x += 1
					top_image.pixel_y += 16
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
			var/image/top_image = image(top)
			switch(update_icon_suffix)
				if ("1")
					top_image.pixel_x += 6
					top_image.pixel_y += 15
				if ("2")
					top_image.pixel_x += 6
					top_image.pixel_y += 15
				if ("wall")
					top_image.pixel_y += 16
				if ("L")
					top_image.pixel_y += 16
				if ("R")
					top_image.pixel_x += 1
					top_image.pixel_y += 16
			UpdateOverlays(top_image, "top_shelf")
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
			var/image/middle_image = image(middle)
			switch(update_icon_suffix)
				if ("1")
					middle_image.pixel_x += 6
					middle_image.pixel_y += 8
				if ("2")
					middle_image.pixel_x += 6
					middle_image.pixel_y += 8
				if ("wall")
					middle_image.pixel_y += 9
				if ("L")
					middle_image.pixel_y += 9
				if ("R")
					middle_image.pixel_x += 1
					middle_image.pixel_y += 9
			UpdateOverlays(middle_image, "middle_shelf")

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
			var/image/top_image = image(top)
			switch(update_icon_suffix)
				if ("1")
					top_image.pixel_x += 6
					top_image.pixel_y += 15
				if ("2")
					top_image.pixel_x += 6
					top_image.pixel_y += 15
				if ("wall")
					top_image.pixel_y += 16
				if ("L")
					top_image.pixel_y += 16
				if ("R")
					top_image.pixel_x += 1
					top_image.pixel_y += 16
			UpdateOverlays(top_image, "top_shelf")
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
			var/image/middle_image = image(middle)
			switch(update_icon_suffix)
				if ("1")
					middle_image.pixel_x += 6
					middle_image.pixel_y += 8
				if ("2")
					middle_image.pixel_x += 6
					middle_image.pixel_y += 8
				if ("wall")
					middle_image.pixel_y += 9
				if ("L")
					middle_image.pixel_y += 9
				if ("R")
					middle_image.pixel_x += 1
					middle_image.pixel_y += 9
			UpdateOverlays(middle_image, "middle_shelf")
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
			var/image/bottom_image = image(bottom)
			switch(update_icon_suffix)
				if ("1")
					bottom_image.pixel_x += 6
					bottom_image.pixel_y += 1
				if ("2")
					bottom_image.pixel_x += 6
					bottom_image.pixel_y += 1
				if ("wall")
					bottom_image.pixel_y += 2
				if ("L")
					bottom_image.pixel_x += 1
					bottom_image.pixel_y += 2
				if ("R")
					bottom_image.pixel_y += 2
			UpdateOverlays(bottom_image, "bottom_shelf")*/