extends Node

#export (String) var item_name
#export (Array, String) var objects_to_interact
#export (bool) var has_durability = false
#export (int) var durability = 5
#export (int) var max_durability = 5
#export (int) var price = 5

class PlayerItem:
	var item_name : String
	var durability : int
	var has_durability : bool
	var price : int
	var scene : PackedScene

var axe = preload("res://Scenes/Items/Axe.tscn")
var rock = preload("res://Scenes/Items/Rock.tscn")
var flamethrower = preload("res://Scenes/Items/flamethrower.tscn")
var eggs = preload("res://Scenes/Items/eggs.tscn")
var spray = preload("res://Scenes/Items/spray.tscn")
var vandal_currency = 0
var player_neighbour_pos = Vector2(170, 258)

var available_items = [
	axe,
	rock,
	flamethrower,
	eggs,
	spray
]
var default_inventory = [
	axe,
	rock
]

var shop_items = []
var inventory = []
var last_house_attacked

func _ready():
	vandal_currency = 10 + randi() % 40
	load_shop_items()
	load_inventory()

func get_player_item(item_scene: PackedScene) -> PlayerItem:
	var new_item = PlayerItem.new()
	var instanced_item = item_scene.instance()
	new_item.item_name = instanced_item.item_name
	new_item.durability = instanced_item.durability
	new_item.has_durability = instanced_item.has_durability
	new_item.price = instanced_item.price
	new_item.scene = item_scene
	return new_item
		
func load_inventory():
	for i in default_inventory:
		var new_item = get_player_item(i)
		inventory.append(new_item)
		
func load_shop_items():
	var si = [
		flamethrower,
		eggs,
		spray
	]
	
	for i in si:
		shop_items.append(get_player_item(i))
	
func add_vandal_currency(currency: int):
	vandal_currency += currency
	
func reduce_vandal_currency(curr: int):
	vandal_currency -= curr

func buy_item(item_name:String, quantity: int):
	var item = null
	for i in inventory:
		if i.item_name == item_name:
			item = i
			break
	if item == null:
		var item_buyed = add_item_to_inventory(item_name)
		if item_buyed != null:
			reduce_vandal_currency(item_buyed.price * quantity)
	# update durability
	else:
		item.durability += quantity
		reduce_vandal_currency(item.price * quantity)

# Add a new item to the inventory
func add_item_to_inventory(item_name: String):
	var item_added = null
	for item in available_items:
		var ii = item.instance()
		if ii.item_name == item_name:
			item_added = get_player_item(item)
			inventory.append(item_added)
			break
	return item_added

func remove_item_from_inventory(item_name: String):
	var index = 0
	for i in inventory.size():
#		var item = inventory[i].instance()
		if inventory[i].item_name == item_name:
			index = i
			break
	inventory.pop_at(index)
			
