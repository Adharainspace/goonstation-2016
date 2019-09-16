/obj/screen/plane_parent
	name = "not important"
	icon = null
	screen_loc = "1,1"
	plane = 0

	New()
		src.appearance_flags = PLANE_MASTER | appearance_flags
		src.blend_mode = BLEND_DEFAULT
		src.mouse_opacity = 1

/*/obj/item/space_thing/filter_thing
	name = "Filter Thing"

	attack_self(mob/user)
		var/obj/screen/plane_parent/pp = new()
		user.client.screen += pp
		var/start = pp.filters.len
		var/f_num = 5
		for(var/i = 1, i <= f_num, i++)
			pp.filters += filter(type="wave", x=rand() * 50, y=rand() * 50, size=(rand()*2.5+0.5)*2, offset=rand())
		for(var/i = 1, i <= f_num, i++)
			var/f = pp.filters[start + i]
			boutput(user, "[f:x], [f:y], [f:size], [f:offset]")
			animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
			animate(offset=f:offset-1, time=rand()*20+10)*/
