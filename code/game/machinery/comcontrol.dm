/obj/machinery/computer/comcontrol
	var/cdir = 0
	var/disc = null
/obj/machinery/computer/comcontrol/dish
	var/control = null
	var/ndir = 5
/obj/machinery/computer/comcontrol/attack_ai(mob/user)
	return

/obj/machinery/computer/comcontrol/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)
/obj/machinery/computer/comcontrol/proc/interact(mob/user)
	if(stat & (BROKEN | NOPOWER)) return
	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/ai))
			user.machine = null
			user << browse(null, "window=comcon")
			return

	add_fingerprint(user)
	user.machine = src

	var/t = "<TT><B>Dish Relay Control</B><HR><PRE>"
	t += "<B>Orientation</B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR><BR><BR>"
	t += "<B><BR><BR><BR>"
	user << browse(t, "window=comcon")
	return

/obj/machinery/computer/comcontrol/Topic(href, href_list)
	if(href_list["close"] )
		usr << browse(null,"window=comcon")
		return

	if(href_list["dir"])
		cdir = text2num(href_list["dir"])
		spawn(1)
			set_panels(cdir)
			updateicon()

	if(href_list["rate control"])
		if(href_list["cdir"])
			src.cdir = dd_range(0,359,(360+src.cdir+text2num(href_list["cdir"]))%360)
			spawn(1)
				set_panels(cdir)
				updateicon()

	src.updateUsrDialog()
	return
/obj/machinery/computer/comcontrol/proc/set_panels(var/cdir)
		control = src
		ndir = cdir


/* DISC RELAY */

/obj/machinery/computer/comdisc/New()
	..()
	updateicon()
	updatefrac()


/obj/machinery/computer/comdisc/attackby(obj/item/weapon/W, mob/user)
	..()
	src.add_fingerprint(user)
	src.health -= W.force
	src.healthcheck()
	return

/obj/machinery/computer/comdisc/blob_act()
	src.health--
	src.healthcheck()
	return

/obj/machinery/computer/comdisc/proc/healthcheck()
	if (src.health <= 0)
		if(!(stat & BROKEN))
			broken()
		else
			new /obj/item/weapon/shard(src.loc)
			new /obj/item/weapon/shard(src.loc)
			del(src)
			return
	return

/obj/machinery/computer/comdisc/proc/updateicon()
	overlays = null
	if(stat & BROKEN)
		overlays += image('power.dmi', icon_state = "solar_panel-b", layer = FLY_LAYER)
	else
		overlays += image('power.dmi', icon_state = "solar_panel", layer = FLY_LAYER)
		src.dir = angle2dir(adir)
	return

/obj/machinery/computer/comdisc/proc/updatefrac()
	if(obscured)
		sunfrac = 0
		return

	var/p_angle = abs((360+adir)%360 - (360+relay.angle)%360)
	if(p_angle > 90)			// if facing more than 90deg from sun, zero output
		discfrac = 0
		return

	discfrac = cos(p_angle) ** 2

#define SOLARGENRATE 1500

/obj/machinery/computer/comdisc/process()
	if(stat & BROKEN)
		return

	if(!obscured)
		longradio = 1
		return
	else
		longradio = 0
		return
/obj/machinery/computer/comdisc/proc/broken()
	stat |= BROKEN
	updateicon()
	return

/obj/machinery/computer/comdisc/meteorhit()
	if(stat & !BROKEN)
		broken()
	else
		del(src)

/obj/machinery/computer/comdisc/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			if(prob(15))
				new /obj/item/weapon/shard( src.loc )
			return
		if(2.0)
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return