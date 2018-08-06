afterearth={
	day_timer=0,
	currtime=0,
	timer=1,
	storm={},
	trashdrops={},
	trashdropscount=50,
	storm_chance=400,
	storm_chance_end=50,
	item_age=tonumber(minetest.settings:get("item_entity_ttl")),
	not_in_trash={
	["default:diamondblock"]=1,
	["default:steelblock"]=1,
	["default:bronzeblock"]=1,
	["default:tinblock"]=1,
	["default:mese"]=1,
	["default:copperblock"]=1,
	["default:diamond"]=1,
	["default:mese_crystal"]=1,
	["doors:door_steel"]=1,
	["default:coalblock"]=1,
}



}

dofile(minetest.get_modpath("afterearth") .. "/items.lua")
dofile(minetest.get_modpath("afterearth") .. "/craft.lua")

if afterearth.item_age=="" or afterearth.item_age==nil then
	afterearth.item_age=895
else
	afterearth.item_age=afterearth.item_age-5
end

minetest.register_on_dieplayer(function(player)
	local pos=player:getpos()
	pos={x=pos.x,y=pos.y+1.5,z=pos.z}
	local def=minetest.registered_nodes[minetest.get_node(pos).name]
	if def and def.buildable_to then
		minetest.set_node(pos,{name="afterearth:air3"})
	end
end)

minetest.register_on_joinplayer(function(player)		-- set sky for joining players
	afterearth.daycircle(player)
end)

minetest.register_globalstep(function(dtime)		-- set sky for players
	afterearth.day_timer=afterearth.day_timer+dtime
	if afterearth.day_timer<afterearth.timer then return end
	afterearth.day_timer=0
	afterearth.daycircle()
end)


afterearth.weather=function(d)
-- intensively sunshine between 11:00 and 14:00
	if d>0.458 and d<0.58 then
		for _,player in ipairs(minetest.get_connected_players()) do
			local pos=player:getpos()
			local l=minetest.get_node_light(pos)
			for i, ob in pairs(minetest.get_objects_inside_radius(pos, 30)) do
				local pos2=ob:getpos()
				local l=minetest.get_node_light(pos2)
				if l and l>=default.LIGHT_MAX then
					local n=minetest.registered_nodes[minetest.get_node(pos2).name]
					if n and n.buildable_to and not minetest.is_protected(pos,"") then
						minetest.set_node(pos2, {name = "fire:basic_flame"})
					end
					ob:punch(ob,1,{full_punch_interval=1,damage_groups={fleshy=1}})
				end
			end
		end
	end
	if not afterearth.storm.dir and math.random(1,afterearth.storm_chance)==1 then
		local d={{x=1,z=0},{x=-1,z=0},{x=0,z=1},{x=0,z=-1}}
		local max
		local min
		d=d[math.random(1,4)]
		if d.x==1 then
			max={x=-15,z=15}
			min={x=-15,z=-15}
		elseif d.x==-1 then
			max={x=15,z=15}
			min={x=15,z=-15}
		elseif d.z==1 then
			max={x=15,z=-15}
			min={x=-15,z=-15}
		else --if d.z==-1 then
			max={x=15,z=15}
			min={x=-15,z=15}
		end
		afterearth.storm.max=max
		afterearth.storm.min=min
		afterearth.storm.dir=d
	elseif afterearth.storm.dir then
		if math.random(1,afterearth.storm_chance_end)==1 then
			afterearth.storm={}
			return
		end
		local d=afterearth.storm.dir
		local max=afterearth.storm.max
		local min=afterearth.storm.min
		for _,player in ipairs(minetest.get_connected_players()) do
			local pos=player:getpos()
			local l=minetest.get_node_light(pos)
			if l and l>=default.LIGHT_MAX-1 then
				afterearth.new_dust=1
				local e=minetest.add_entity({x=pos.x+math.random(min.x,max.x),y=pos.y+math.random(1,10), z=pos.z+math.random(min.z,max.z)}, "afterearth:duster")
				e:setvelocity({x=afterearth.storm.dir.x*5, y=-2, z=afterearth.storm.dir.z*5})
				e:setacceleration({x=afterearth.storm.dir.x*5, y=-2, z=afterearth.storm.dir.z*5})
				afterearth.new_dust=nil
				local pos3={x=pos.x+max.x, y=pos.y+5, z=pos.z+max.z}
				minetest.add_particlespawner({
					amount = 20,
					time=2,
					maxpos = {x=pos.x+min.x, y=pos.y, z=pos.z+min.z},
					minpos = pos3,
					minvel = {x=d.x*10, y=-1, z=d.z*10},
					maxvel = {x=d.x*20, y=0.5, z=d.z*20},
					minacc = {x=d.x*5, y=-1, z=d.z*5},
					maxacc = {x=d.x*10, y=-10, z=d.z*10},
					minexptime = 0.5,
					maxexptime = 2,
					minsize = 0.8,
					maxsize = 1.3,
					texture = "default_dirt.png",
					collisiondetection=true,
				})
				afterearth.new_dust=1
				for i, ob in pairs(minetest.get_objects_inside_radius(pos, 20)) do
					if ob:get_luaentity() and not ob:get_luaentity().dust and afterearth.visiable(ob:getpos(),pos3) then
						if ob:get_luaentity().itemstring then
							ob:get_luaentity().age=afterearth.item_age
						end
						minetest.add_entity(ob:getpos(), "afterearth:duster")
					end
				end
				afterearth.new_dust=nil
			end
		end
	end
end


afterearth.visiable=function(pos1,pos2)
	if not (pos2 and pos2.x and pos1 and pos1.x) then return nil end
	local v = {x = pos1.x - pos2.x, y = pos1.y - pos2.y-1, z = pos1.z - pos2.z}
	v.y=v.y-1
	local amount = (v.x ^ 2 + v.y ^ 2 + v.z ^ 2) ^ 0.5
	local d=math.sqrt((pos1.x-pos2.x)*(pos1.x-pos2.x) + (pos1.y-pos2.y)*(pos1.y-pos2.y)+(pos1.z-pos2.z)*(pos1.z-pos2.z))
	v.x = (v.x  / amount)*-1
	v.y = (v.y  / amount)*-1
	v.z = (v.z  / amount)*-1
	for i=1,d,1 do
		local node=minetest.get_node({x=pos1.x+(v.x*i),y=pos1.y+(v.y*i),z=pos1.z+(v.z*i)})
		if node and node.name and minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].walkable then
			return false
		end
	end
	return true
end

afterearth.daycircle=function(join)			--set sky color and clouds
						--[joined player] [time changed by command] [evening or night] [night or morning]
						--evening and morning = set timer to 0.2, else 1
	local d=minetest.get_timeofday()
	afterearth.weather(d)
	if join or (d-0.1>afterearth.currtime or d+0.1<afterearth.currtime) or (d>=0.75 and d<0.81) or (d>0.19 and d<0.26) then
		afterearth.currtime=d
		local t=1
		if d>=0.75 and d<0.8 then
			t=(0.8-d)*20
			afterearth.timer=0.33
		elseif d>0.8 or d<0.2 then
			t=0
			afterearth.timer=1
		elseif d>=0.2 and d<0.25 then
			t=(-0.2+d)*20
			afterearth.timer=0.3
		elseif d>0.25 then
			t=1
			afterearth.timer=1
		end
		if join then
			join:set_sky({r=255*t, g=240*t, b=170*t},"plain",{})
			join:set_clouds({
				color={r=255, g=240, b=70, a=200*t},
				ambient={r=255, g=255, b=170, a=100},
				density=0.5,
				height=200,
				speed=-40
			})
			return
		end
		for _,player in ipairs(minetest.get_connected_players()) do
			player:set_sky({r=255*t, g=240*t, b=170*t},"plain",{})
			player:set_clouds({
				color={r=255, g=240, b=70, a=200*t},
				ambient={r=255, g=255, b=170, a=100},
				density=0.5,
				height=200,
				speed=-40
			})
		end
	else
		afterearth.timer=1
	end
	afterearth.currtime=d
end

minetest.register_on_dignode(function(pos, oldnode, digger)
	if pos.y<1 then
		local a=minetest.find_node_near(pos, 1,"air")
		if a then 
			minetest.set_node(pos, {name = "afterearth:air"})
		end
	end
end)

minetest.register_abm({
	nodenames = {"air","afterearth:air2"},
	neighbors = {"group:sand","group:stone","default:gravel"},
	interval = 10,
	chance = 10,
	action = function(pos,node)
		if node.name=="air" then
			local l=minetest.get_node_light(pos)
			if l and l>=11 then
				minetest.set_node(pos, {name = "afterearth:air2"})
			end
		elseif node.name=="afterearth:air2" then
			local l=minetest.get_node_light(pos)
			if l and l<11 then
				minetest.set_node(pos, {name = "air"})
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"air"},
	interval = 10,
	chance = 10,
	action = function(pos,node)
		if pos.y<-20 then
			minetest.set_node(pos, {name = "afterearth:air"})
		end
	end,
})

minetest.clear_registered_biomes()
minetest.clear_registered_decorations()

	minetest.register_biome({
		name = "land",
		--node_dust = "default:sand",
		node_top = "afterearth:waste",
		depth_top = 10,
		node_filler = "default:sand",
		depth_filler = 3,
		node_stone = "default:stone",
		node_water_top = "afterearth:air",
		depth_water_top =5 ,
		node_water = "afterearth:source",
		node_river_water = "afterearth:source",
		y_min = -31000,
		y_max = 400,
		heat_point = 50,
		humidity_point = 50,
	})

	minetest.register_biome({
		name = "sand",
		node_dust = "afterearth:air2",
		node_top = "default:sand",
		depth_top = 10,
		node_filler = "afterearth:waste",
		depth_filler = 3,
		node_stone = "default:stone",
		node_water_top = "afterearth:air",
		depth_water_top =1 ,
		node_water = "afterearth:source",
		node_river_water = "afterearth:source",
		y_min = 10,
		y_max = 400,
		heat_point = 25,
		humidity_point = 50,
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "afterearth:waste2",
		wherein         = {"afterearth:waste"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -55,
		y_max           = 400,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "afterearth:waste3",
		wherein         = {"afterearth:waste"},
		clust_scarcity  = 50 * 50 * 50,
		clust_size      = 7,
		y_min           = -55,
		y_max           = 20,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "afterearth:trash",
		wherein         = {"afterearth:waste","group:sand"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -55,
		y_max           = 400,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "afterearth:air",
		wherein        = "air",
		clust_scarcity =  1 * 1 * 1,
		clust_num_ores = 2,
		clust_size     = 2,
		y_min          = -31000,
		y_max          = 0,
	})

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"afterearth:waste"},
		sidelen = 16,
		noise_params = {
			offset = -0.0004,
			scale = 0.0008,
			spread = {x = 250, y = 250, z = 250},
			seed = 230,
			octaves = 2,
			persist = 0.5
		},
		biomes = {"land"},
		y_min = 1,
		y_max = 400,
		decoration = {"default:tree","default:jungletree","default:pine_tree","default:pine_tree","default:acacia_tree","default:aspen_tree"},
		height = 1,
		height_max = 5,
	})

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"afterearth:waste"},
		sidelen = 16,
		noise_params = {
			offset = -0.0004,
			scale = 0.0008,
			spread = {x = 250, y = 250, z = 250},
			seed = 230,
			octaves = 2,
			persist = 0.5
		},
		biomes = {"land"},
		y_min = 1,
		y_max = 400,
		decoration = {"default:tree","default:jungletree","default:pine_tree","default:pine_tree","default:acacia_tree","default:aspen_tree"},
		height = 1,
		height_max = 5,
	})

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"afterearth:waste"},
		sidelen = 16,
		noise_params = {
			offset = 0.001,
			scale = 0.0005,
			spread = {x = 10, y = 10, z = 10},
		},
		biomes = {"land"},
		y_min = 1,
		y_max = 400,
		decoration = {"afterearth:tire"},
		height = 1,
		height_max = 1,
	})