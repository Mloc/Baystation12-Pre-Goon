/obj/item/weapon/healthanalyzer/attack(mob/M as mob, mob/user as mob)
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	if(M.zombie == 1)
		user.show_message(text("\blue Analyzing Results for []:\n\t Overall Status: \red Dead", M,), 1)
		user.show_message(text("\blue \t Damage Specifics: []-[]-[]-[]", M.oxyloss, M.toxloss, M.fireloss, M.bruteloss), 1)
		user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
		user.show_message("\blue Body Temperature:Body Temperature: 0�C (0�F)", 1)
		user.show_message("\red Contains traces of a unknown infectious agent")
		return
	if (usr.clumsy && prob(50))
		usr << text("\red You try to analyze the floor's vitals!")
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] has analyzed the floor's vitals!", user), 1)
		user.show_message(text("\blue Analyzing Results for The floor:\n\t Overall Status: Healthy"), 1)
		user.show_message(text("\blue \t Damage Specifics: []-[]-[]-[]", 0, 0, 0, 0), 1)
		user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
		user.show_message("\blue Body Temperature: ???", 1)
		return
	for(var/mob/O in viewers(M, null))
		O.show_message(text("\red [] has analyzed []'s vitals!", user, M), 1)
		//Foreach goto(67)
	user.show_message(text("\blue Analyzing Results for []:\n\t Overall Status: []", M, (M.stat > 1 ? "dead" : text("[]% healthy", M.health))), 1)
	user.show_message(text("\blue \t Damage Specifics: []-[]-[]-[]", M.oxyloss, M.toxloss, M.fireloss, M.bruteloss), 1)
	user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
	user.show_message("\blue Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)", 1)
	if (M.rejuv)
		user.show_message(text("\blue Bloodstream Analysis located [] units of rejuvenation chemicals.", M.rejuv), 1)
	if(M.becoming_zombie == 1)
		user.show_message("\red Contains traces of a unknown infectious agent")
	for(var/obj/item/I in M)
		if(I.contaminated)
			user.show_message("\red Objects on [M]'s person may be contaminated with toxic particles.")
			break
	src.add_fingerprint(user)
	if (M.stat > 1)
		user.unlock_medal("He\'s Dead, Jim", 0, "Scanned a dead body. Great job Sherlock.", "easy")
	return

