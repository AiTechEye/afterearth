

minetest.after(0, function()
for v, s in pairs(core.registered_items) do
	if s.groups and s.groups.not_in_creative_inventory ~=1 and not afterearth.not_in_trash[v] then
		local c=minetest.get_craft_recipe(v)
		if c.items  then
			table.insert(afterearth.trashdrops,v)
		elseif type(s.drop)=="string" and s.drop~="" and not (afterearth.trashdrops[s.drop] or afterearth.not_in_trash[v]) then
			table.insert(afterearth.trashdrops,v)
		end
	end
end

afterearth.trashdropscount=math.floor(#afterearth.trashdrops/4)
end)




local drownings={
	"default:torch",
	"default:torch_wall",
	"default:torch_ceiling",
	"default:stone",
	"default:cobble",
	"default:dirt",
	"default:sand",
	"default:gravel",
}
for i, s in pairs(drownings) do
	if core.registered_items[s] then
		minetest.override_item(s,{drowning=1})
	end
end
local eatsbles={
	"default:leaves",
	"default:jungleleaves",
	"default:acacia_leaves",
	"default:aspen_leaves",
	"default:bush_leaves",
	"default:acacia_bush_leaves",
	"default:junglegrass",
	"default:grass_1",
	"default:grass_2",
	"default:grass_3",
	"default:grass_4",
	"default:grass_5",
	"default:dry_grass_1",
	"default:dry_grass_2",
	"default:dry_grass_3",
	"default:dry_grass_4",
	"default:dry_grass_5",
	"default:bush_leaves",
	"default:acacia_bush_leaves",
	"default:cactus",
	"default:papyrus",
	"default:dry_shrub",
	"flowers:rose",
	"flowers:tulip",
	"flowers:dandelion_yellow",
	"flowers:geranium",
	"flowers:viola",
	"flowers:waterlily",
	"flowers:dandelion_white"
}
for i, s in pairs(eatsbles) do
	if core.registered_items[s] then
		minetest.override_item(s,{
			on_use = minetest.item_eat(1),
		})
		table.insert(afterearth.trashdrops,s)
	end
end

minetest.register_node("afterearth:rubberblock", {
	description = "Rubberblock",
	tiles = {"afterearth_rubber.png"},
	groups = {cracky=3,fall_damage_add_percent=-75,bouncy=99},
	drowning=1,
	sounds = default.node_sound_wood_defaults(),
})


minetest.register_node("afterearth:tire", {
	description = "Tire",
	tiles = {"afterearth_rubber.png"},
	groups = {snappy=3,flammable=2,dig_immediate=3,fall_damage_add_percent=-75,bouncy=100},
	drowning=1,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates =true,
	selection_box = {
		type = "fixed",
		fixed = {{-0.5,-0.5,-0.5,0.5,-0.31,0.5}},
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, -0.3125, -0.3125, 0.375},
			{-0.4375, -0.5, -0.375, -0.375, -0.3125, 0.375},
			{-0.5, -0.5, -0.25, -0.4375, -0.3125, 0.25},
			{-0.25, -0.5, 0.4375, 0.25, -0.3125, 0.5},
			{-0.375, -0.5, 0.375, 0.375, -0.3125, 0.4375},
			{-0.3125, -0.5, 0.3125, 0.375, -0.3125, 0.375},
			{-0.25, -0.5, -0.5, 0.25, -0.3125, -0.4375},
			{-0.375, -0.5, -0.4375, 0.375, -0.3125, -0.375},
			{-0.3125, -0.5, -0.375, 0.375, -0.3125, -0.3125},
			{0.4375, -0.5, -0.25, 0.5, -0.3125, 0.25},
			{0.375, -0.5, -0.375, 0.4375, -0.3125, 0.375},
			{0.3125, -0.5, -0.3125, 0.375, -0.3125, 0.3125},
			{0.25, -0.5, 0.1875, 0.3125, -0.3125, 0.3125},
			{-0.3125, -0.5, 0.25, -0.1875, -0.3125, 0.3125},
			{-0.3125, -0.5, 0.1875, -0.25, -0.3125, 0.25},
			{0.1875, -0.5, -0.3125, 0.3125, -0.3125, -0.25},
			{0.25, -0.5, -0.25, 0.3125, -0.3125, -0.1875},
			{-0.3125, -0.5, -0.3125, -0.1875, -0.3125, -0.25},
			{-0.3125, -0.5, -0.25, -0.25, -0.3125, -0.1875},
			{0.1875, -0.5, 0.25, 0.25, -0.3125, 0.3125},
		}
	},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("afterearth:bag_empty", {
	description = "Empty plastic bag",
	stack_max=10,
	inventory_image = "afterearth_bag.png",
	wield_image = "afterearth_bag.png",
	tiles = {"eafterearth_plastic_block.png"},
	groups = {snappy=2,flammable=2,dig_immediate=3},
	drowning=1,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates =true,
	walkable=false,
	selection_box = {
		type = "fixed",
		fixed = {{-0.3125, -0.5, -0.1875, 0.25, 0.25, 0.1875}}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{0.1875, -0.5, -0.125, 0.25, 0.125, 0.125},
			{-0.3125, -0.5, -0.125, -0.25, 0.125, 0.125},
			{-0.25, -0.5, 0.125, 0.1875, 0.25, 0.1875},
			{-0.25, -0.5, -0.1875, 0.1875, 0.25, -0.125},
			{-0.25, -0.5, -0.125, 0.1875, -0.4375, 0.125},
			{0.1875, 0.1875, -0.125, 0.25, 0.25, 0.125},
			{-0.3125, 0.1875, -0.125, -0.25, 0.25, 0.125},
		}
	},
	sounds = default.node_sound_leaves_defaults(),
allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local n=player:get_player_name()
		if n~=minetest.get_meta(pos):get_string("owner") and minetest.is_protected(pos,n) then
			return 0
		end
		return stack:get_count()
	end,
allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local n=player:get_player_name()
		if n~=minetest.get_meta(pos):get_string("owner") and minetest.is_protected(pos,n) then
			return 0
		end
		return stack:get_count()
	end,
allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local n=player:get_player_name()
		if n~=minetest.get_meta(pos):get_string("owner") and minetest.is_protected(pos,n) then
			return 0
		end
		return count
	end,
can_dig = function(pos, player)
		return minetest.get_meta(pos):get_inventory():is_empty("main")
	end,
after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta=minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("infotext", "Plastic bag")
		meta:get_inventory():set_size("main", 4)
		meta:set_string("formspec",
		"size[8,5]" ..
		"list[context;main;2,0;4,1;]" ..
		"list[current_player;main;0,1;8,4;]" ..
		"listring[current_player;main]" ..
		"listring[current_name;main]")
end,
on_use=function(itemstack, user, pointed_thing)
	local pos=user:get_pos()
	pos.y=pos.y+1.5
	local def=minetest.registered_nodes[minetest.get_node(pos).name]
	if def and def.drowning==0 then
		itemstack:take_item(1)
		user:get_inventory():add_item("main", "afterearth:bag")
	end
	return itemstack
end})

minetest.register_craftitem("afterearth:bag", {
	description = "Plastic bag",
	stack_max=10,
	inventory_image = "afterearth_bag.png",
	groups={not_in_creative_inventory=1},
on_use=function(itemstack, user, pointed_thing)
	itemstack:take_item(1)
	user:get_inventory():add_item("main", "afterearth:bag_empty")
	user:set_breath(11)
	return itemstack
end})

minetest.register_node("afterearth:plastic_block", {
	description = "Plastic block",
	tiles = {"eafterearth_plastic_block.png"},
	groups = {crumbly = 2,snappy=2,flammable=2},
	drowning=1,
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("afterearth:waste", {
	description = "Waste",
	tiles = {"afterearth_waste.png"},
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults(),
	drowning=1,
})



minetest.register_node("afterearth:trash", {
	description = "Trash",
	drop="",
	tiles = {"afterearth_trash.png"},
	groups = {crumbly = 3,snappy=3,flammable=2},
	sounds = default.node_sound_dirt_defaults(),
	after_dig_node = function(pos, node, metadata, digger)
		local inv=digger:get_inventory()
		if not inv or not inv:room_for_item("main", "afterearth:trash") then
			minetest.set_node(pos,node)
			return
		end
		for s, v in pairs(afterearth.trashdrops) do
			if math.random(1,afterearth.trashdropscount)==1 then
				local it=v
				if minetest.registered_tools[v] then
					it=v .. " 1 " ..(math.random(40,60)*1000)
				end
				inv:add_item("main", it)
				break
			end
		end
		if math.random(1,2)==1 then
			inv:add_item("main", "afterearth:bag_empty")
		end
		local tool=inv:get_stack(digger:get_wield_list(), digger:get_wield_index()):get_name()
		if minetest.registered_tools[tool] then return end
		local a=0
		if math.random(1,10)<3 then return end
		for i=0,20,1 do
			if math.random(1,2)==1 then
				break
			end
			a=i
		end
		digger:punch(digger,a,{full_punch_interval=1,damage_groups={fleshy=4}})
	end
})

minetest.register_node("afterearth:waste2", {
	description = "Waste",
	tiles = {"afterearth_waste.png"},
	groups = {crumbly = 3},
	walkable=false,
	drowning=1,
	sounds = default.node_sound_dirt_defaults(),
	after_dig_node = function(pos)
		local a=0
		local c={
			{x=1,z=0},
			{x=-1,z=0},
			{x=0,z=1},
			{x=0,z=-1},
			{x=1,z=1},
			{x=-1,z=-1},
			{x=1,z=-1},
			{x=-1,z=1}
		}
		minetest.after(1, function(pos,c)
			for v, s in pairs(c) do
				if minetest.get_node({x=pos.x+s.x,y=pos.y,z=pos.z+s.z}).name=="afterearth:waste2" then
					a=a+1
					if a>1 then
						minetest.set_node(pos, {name = "afterearth:waste2"})
						return
					end
				end
			end
		end,pos,c)
	end
})

minetest.register_node("afterearth:air", {
	description = "Air",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drawtype = "airlike",
	drowning=1,
	groups = {not_in_creative_inventory=1},
	paramtype = "light",
	sunlight_propagates =true,
})

minetest.register_node("afterearth:air2", {
	description = "Hot air",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drawtype = "airlike",
	damage_per_second = 1,
	drowning=1,
	groups = {not_in_creative_inventory=1,igniter=1},
	paramtype = "light",
	sunlight_propagates =true,
})

minetest.register_node("afterearth:air3", {
	description = "Air",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drawtype = "airlike",
	drowning=1,
	groups = {not_in_creative_inventory=1},
	paramtype = "light",
	sunlight_propagates =true,
	post_effect_color = {a=250, r=0,g=0,b=0},
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
	on_timer = function (pos, elapsed)
		for i, ob in pairs(minetest.get_objects_inside_radius(pos, 2)) do
			return true
		end
		minetest.remove_node(pos)
		return true
	end,
})

minetest.register_node("afterearth:waste3", {
	description = "Toxic sludge",
	drawtype = "liquid",
	tiles = {"afterearth_source2.png"},
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	is_ground_content = false,
	drowning = 1,
	liquidtype = "source",
	liquid_range = 1,
	damage_per_second = 11,
	liquid_alternative_flowing = "afterearth:waste3b",
	liquid_alternative_source = "afterearth:waste3",
	liquid_viscosity = 15,
	post_effect_color = {a=240, r=100,g=120,b=0},
	groups = {liquid = 4,crumbly = 1, sand = 1},
	alpha = 245,
	pointable = false,
	diggable = false,
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("afterearth:waste3b", {
	description = "Toxic sludge",
	drawtype = "flowingliquid",
	tiles = {"afterearth_source2.png"},
	special_tiles = {
		{
			name = "afterearth_source2.png",
			backface_culling = false,
		},
		{
			name = "afterearth_source2.png",
			backface_culling = true,
		},
	},
	alpha = 245,
	post_effect_color = {a=240, r=100,g=120,b=0},
	paramtype = "light",
	pointable = false,
	diggable = false,
	paramtype2 = "flowingliquid",
	walkable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	damage_per_second = 11,
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "afterearth:waste3b",
	liquid_alternative_source = "afterearth:waste3",
	liquid_viscosity = 1,
	liquid_range = 1,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {liquid = 4, not_in_creative_inventory = 1},
	sounds = default.node_sound_water_defaults(),
})


minetest.register_node("afterearth:source", {
	description = "Sludge",
	drawtype = "liquid",
	tiles = {"afterearth_source.png"},
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	is_ground_content = false,
	drowning = 1,
	liquidtype = "source",
	liquid_range = 2,
	liquid_alternative_flowing = "afterearth:source2",
	liquid_alternative_source = "afterearth:source",
	liquid_viscosity = 15,
	post_effect_color = {a=240, r=100,g=120,b=0},
	groups = {liquid = 4,crumbly = 1, sand = 1},
	alpha = 245,
	pointable = false,
	diggable = false,
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("afterearth:source2", {
	description = "Sludge",
	drawtype = "flowingliquid",
	tiles = {"afterearth_source.png"},
	special_tiles = {
		{
			name = "afterearth_source.png",
			backface_culling = false,
		},
		{
			name = "afterearth_source.png",
			backface_culling = true,
		},
	},
	alpha = 245,
	post_effect_color = {a=240, r=100,g=120,b=0},
	paramtype = "light",
	pointable = false,
	diggable = false,
	paramtype2 = "flowingliquid",
	walkable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "afterearth:source2",
	liquid_alternative_source = "afterearth:source",
	liquid_viscosity = 1,
	liquid_range = 2,
	post_effect_color = {a = 103, r = 30, g = 76, b = 90},
	groups = {liquid = 4, not_in_creative_inventory = 1},
	sounds = default.node_sound_water_defaults(),
})


afterearth.spawn_dust=function(pos)
		if not (pos and afterearth.storm.dir and minetest.is_protected(pos,"")==false) then return end
		local drop=minetest.get_node_drops(minetest.get_node(pos).name)[1]
		local n=minetest.registered_nodes[minetest.get_node(pos).name]
		if not (n and n.walkable) or drop=="" or type(drop)~="string" then return end
		local t=n.tiles
		if not t[1] then return end
		local tx={}
		local tt={}
		tt.t1=t[1]
		tt.t2=t[1]
		tt.t3=t[1]

		if t[2] then tt.t2=t[2] tt.t3=t[2] end
		if t[3] and t[3].name then tt.t3=t[3].name
		elseif t[3] then tt.t3=t[3]
		end
		if type(tt.t3)=="table" then return end
		tx[1]=tt.t1
		tx[2]=tt.t2
		tx[3]=tt.t3
		tx[4]=tt.t3
		tx[5]=tt.t3
		tx[6]=tt.t3
	afterearth.new_dust={t=tx,drop=drop}
	local e=minetest.add_entity(pos, "afterearth:dust")
	e:set_velocity({x=afterearth.storm.dir.x*5, y=2, z=afterearth.storm.dir.z*5})
	e:set_acceleration({x=afterearth.storm.dir.x*5, y=-1, z=afterearth.storm.dir.z*5})
	afterearth.new_dust=nil
	minetest.remove_node(pos)
end

minetest.register_entity("afterearth:duster",{
	hp_max = 1000,
	physical =true,
	weight = 0,
	collisionbox = {-0.1,-0.1,-0.1,0.1,0.1,0.1},
	visual = "sprite",
	visual_size = {x=1,y=1},
	pointable=false,
	textures ={"afterearth_air.png"},
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},
	is_visible = true,
	makes_footstep_sound = false,
	on_activate=function(self, staticdata)
		if not (afterearth.new_dust and afterearth.storm.dir) then
			self.object:remove()
			return self
		end
		self.d=afterearth.storm.dir
		return self
	end,
	on_step=function(self, dtime)
		self.time=self.time+dtime
		self.time2=self.time2+dtime
		if self.time2<0.1 then return self end
		self.time2=0
		local pos=self.object:get_pos()
		local pos2={x=pos.x+self.d.x,y=pos.y,z=pos.z+self.d.z}
		local u=minetest.registered_nodes[minetest.get_node(pos2).name]
		if not self.atta and u and u.walkable and minetest.get_item_group(u.name,"cracky")==0 and not minetest.is_protected(pos2,"") then
			afterearth.spawn_dust(pos2)
			self.object:remove()
		elseif self.time>3 or u and u.walkable then
			self.object:remove()
		elseif self.atta then
			local v=self.object:get_velocity()
			local pos2={x=pos.x+self.d.x,y=pos.y-1,z=pos.z+self.d.z}
			local u2=minetest.registered_nodes[minetest.get_node(pos2).name]
			if (u2 and u2.walkable) or (v.x+v.z==0) then
				self.atta:punch(self.atta,4,{full_punch_interval=1,damage_groups={fleshy=4}})
				self.object:remove()
				return self
			end
		elseif not self.atta then
			for i, ob in pairs(minetest.get_objects_inside_radius(pos, 1)) do
				if not (ob:get_luaentity() and ob:get_luaentity().dust) then
					self.object:move_to({x=pos.x,y=pos.y+1,z=pos.z})
					self.object:set_properties({collisionbox={-0.5,-0.5,-0.5,0.5,0.5,0.5}})
					ob:set_attach(self.object, "",{x = 0, y = 0, z = 0}, {x = 0, y =0, z = 0})
					self.atta=ob
					self.time=-30
					self.object:set_velocity({x=self.d.x*15, y=1, z=self.d.z*15})
					self.object:set_acceleration({x=0, y=-0.2, z=0})
					return self
				end
			end

		end
		return self
	end,
	time=0,
	time2=0,
	dust=1,
})



minetest.register_entity("afterearth:dust",{
	hp_max = 1000,
	physical =true,
	weight = 0,
	collisionbox = {-0.5,-0.5,-0.5,0.5,0.5,0.5},
	visual = "cube",
	visual_size = {x=1,y=1},
	textures ={"air.png"},
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},
	is_visible = true,
	makes_footstep_sound = true,
	on_punch2=function(self)
		minetest.add_item(self.object:get_pos(),self.drop)
		self.object:remove()
		return self
	end,
	on_activate=function(self, staticdata)
		if not (afterearth.new_dust and afterearth.storm.dir) then self.object:remove() return self end
		self.drop=afterearth.new_dust.drop
		self.object:set_properties({textures = afterearth.new_dust.t})
		self.d=afterearth.storm.dir
		return self
	end,
	on_step=function(self, dtime)
		self.time=self.time+dtime
		if self.time<self.timer then return self end
		self.time=0
		self.timer2=self.timer2-1
		local pos=self.object:get_pos()
		local u=minetest.registered_nodes[minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name]
		for i, ob in pairs(minetest.get_objects_inside_radius({x=pos.x+self.d.x,y=pos.y-1,z=pos.z+self.d.z}, 2)) do
			if not (ob:get_luaentity() and ob:get_luaentity().dust) then
				ob:punch(ob,9,{full_punch_interval=1,damage_groups={fleshy=9}})
				break
			end
		end
		if u and u.walkable then
			local n=minetest.registered_nodes[minetest.get_node(pos).name]
			if n and n.buildable_to and minetest.registered_nodes[self.drop] then
				minetest.set_node(pos,{name=self.drop})
				self.object:remove()
			else
				self.on_punch2(self)
			end
			return self
		elseif self.timer2<0 then
			self.on_punch2(self)
		end
		return self
	end,
	time=0,
	timer=2,
	timer2=10,
	dust=1,
})
