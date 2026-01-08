/obj/item/clothing/suit/roguetown/armor/guncloak
    name = "marksman's coat"
    desc = "A thick padded coat with many leather straps inside, designed for bringing the boom..."
    icon_state = "longcoat"
    icon = 'icons/roguetown/clothing/armor.dmi'
    mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
    color = CLOTHING_BLACK
    slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
    break_sound = 'sound/foley/cloth_rip.ogg'
    drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
    sewrepair = TRUE
    r_sleeve_status = SLEEVE_NORMAL
    l_sleeve_status = SLEEVE_NORMAL
    allowed_sex = list(MALE, FEMALE)
    var/max_storage = 6
    var/list/guns = list()

/obj/item/clothing/suit/roguetown/armor/guncloak/ComponentInitialize()
    . = ..()
    AddComponent(/datum/component/storage/concrete/grid/guncloak)

/datum/component/storage/concrete/grid/guncloak
    max_w_class = WEIGHT_CLASS_NORMAL
    dump_time = 0
    screen_max_rows = 2
    screen_max_columns = 1

/datum/component/storage/concrete/grid/guncloak/New(datum/P, ...)
    . = ..()
    max_items = 2
    set_holdable(list(
        /obj/item/quiver/,
        /obj/item/powderflask
        ))

/obj/item/clothing/suit/roguetown/armor/guncloak/attack_turf(turf/T, mob/living/user)
	if(guns.len >= max_storage)
		to_chat(user, span_warning("Your [src.name] is full!"))
		return
	to_chat(user, span_notice("You begin to gather the pistols..."))
	for(var/obj/item/gun/ballistic/arquebus_pistol/PISTOLERO in T.contents)
		if(do_after(user, 5))
			if(!eatgun(PISTOLERO))
				break

/obj/item/clothing/suit/roguetown/armor/guncloak/proc/eatgun(obj/A)
	if(A.type in typesof(/obj/item/gun/ballistic/arquebus_pistol))
		if(guns.len < max_storage)
			A.forceMove(src)
			guns += A
			update_icon()
			return TRUE
		else
			return FALSE

/obj/item/clothing/suit/roguetown/armor/guncloak/attackby(obj/A, loc, params)
	if(A.type in typesof(/obj/item/gun/ballistic/arquebus_pistol))
		if(guns.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			guns += A
			update_icon()
			to_chat(usr, span_notice("I quietly slot [A] into [src]."))
		else
			to_chat(loc, span_warning("Full!"))
		return
	..()

/obj/item/clothing/suit/roguetown/armor/guncloak/attack_right(mob/user)
	if(guns.len)
		var/obj/O = guns[guns.len]
		guns -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/clothing/suit/roguetown/armor/guncloak/examine(mob/user)
	. = ..()
	if(guns.len)
		. += span_notice("[guns.len] inside.")
