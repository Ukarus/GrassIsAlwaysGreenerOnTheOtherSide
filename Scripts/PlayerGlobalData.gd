extends Node


var axe = preload("res://Scenes/Items/Axe.tscn")
var rock = preload("res://Scenes/Items/Rock.tscn")
var flamethrower = preload("res://Scenes/Items/flamethrower.tscn")
var eggs = preload("res://Scenes/Items/eggs.tscn")
var spray = preload("res://Scenes/Items/spray.tscn")
var player_neighbour_pos = Vector2(170, 258)

var available_items = [
	axe,
	rock,
	flamethrower,
	eggs,
	spray
]

# Array 
var inventory = [
	axe,
	rock,
	flamethrower,
	eggs,
	spray
]

# Add a new item to the inventory
func add_item_to_inventory(item_name: String):
	for item in available_items:
		if item.item_name == item_name:
			inventory.append(item)

func remove_item_from_inventory(item_name: String):
	var index = 0
	for i in inventory.size():
		var item = inventory[i].instance()
		if item.item_name == item_name:
			index = i
			break
	inventory.pop_at(index)
			
