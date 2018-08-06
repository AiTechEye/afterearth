minetest.register_craft({
	output = "afterearth:plastic_block",
	recipe = {
		{"afterearth:bag_empty","afterearth:bag_empty","afterearth:bag_empty"},
		{"afterearth:bag_empty","afterearth:bag_empty","afterearth:bag_empty"},
		{"afterearth:bag_empty","afterearth:bag_empty","afterearth:bag_empty"},
	}
})
minetest.register_craft({
	output = "afterearth:rubberblock 9",
	recipe = {
		{"afterearth:tire","afterearth:tire","afterearth:tire"},
		{"afterearth:tire","afterearth:tire","afterearth:tire"},
		{"afterearth:tire","afterearth:tire","afterearth:tire"},
	}
})




minetest.register_craft({
	type = "fuel",
	recipe = "afterearth:plastic_block",
	burntime=50,
})
minetest.register_craft({
	type = "fuel",
	recipe = "afterearth:bag",
	burntime=5,
})
minetest.register_craft({
	type = "fuel",
	recipe = "afterearth:bag_empty",
	burntime=5,
})

