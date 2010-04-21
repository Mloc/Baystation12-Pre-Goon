/datum/rtable
	var/list/list/datum/computernet/sourcenets = list()

/datum/rtable/proc/GetNetName(var/net)
	if (istype(net, /datum/computernet))
		var/datum/computernet/N = net
		return N.id
	else
		return net

var/dbg1
var/dbg2
proc/BuildRoutingTable()
	var/load = 0
	var/datum/rtable/R = new /datum/rtable()
	world.log << "Building routing table ([computernets.len] nets)"
	dbg1 = 0
	dbg2 = 0
	for (var/datum/computernet/srccnet in computernets)
		R.sourcenets[srccnet.id] = list()
	for (var/datum/computernet/srccnet in computernets)
		for (var/datum/computernet/destcnet in computernets)
			if (srccnet == destcnet || R.sourcenets[srccnet.id][destcnet.id])
				continue
			BuildRoutingPath(srccnet, destcnet, R)
			load++
			if(load >= 150)
				load = 0
				sleep(0)
	world.log << "Done.  1 [dbg1] [dbg2]"
	routingtable = R

proc/BuildRoutingPath(var/datum/computernet/srccnet, var/datum/computernet/destcnet, var/datum/rtable/R)
	dbg1++
	var/list/datum/computernet/path = SubBuildRoutingPath(srccnet, destcnet, list())

	if (path)
		for (var/I = 2, I <= path.len, I++)
			var/datum/computernet/net = path[I]
			R.sourcenets[net.id][destcnet.id] = path[I - 1]
		for (var/I = path.len - 1, I > 1, I--)
			var/datum/computernet/net = path[I]
			R.sourcenets[destcnet.id][net.id] = path[path.len - I]


proc/SubBuildRoutingPath(var/datum/computernet/curnet, var/datum/computernet/destcnet, var/list/ignore)
	dbg2++
	if (!curnet)
		return null
	if (curnet == destcnet)
		return list(curnet)

	ignore += curnet

	var/list/best = null

	for (var/obj/machinery/router/R in curnet.routers)

		for (var/datum/computernet/cnet in R.connectednets)
			if (cnet in ignore)
				continue

			var/list/results = SubBuildRoutingPath(cnet, destcnet, ignore)

			if (!results)
				continue
			results += curnet

			if (!best || best.len > results.len)
				best = results

	return best