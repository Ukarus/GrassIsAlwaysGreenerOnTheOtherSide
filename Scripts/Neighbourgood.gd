extends Node

enum ObjectState {NORMAL, DESTROYED}

class HouseObject:
	var object_name = ""
	var points
	var resistance
	var max_resistance
	var multiple_hits = false
	var is_destroyed
	var days_to_recover
	var days_broken = 0
	var scene
	var object_state = ObjectState.NORMAL
	var instance_id = 0
	var price_to_repair = 0
	
	func destroy():
		object_state = ObjectState.DESTROYED
		# Check if this works
		is_destroyed = true
		resistance = 0
		
	func repair():
		if object_state == ObjectState.DESTROYED:
			object_state = ObjectState.NORMAL
			is_destroyed = false
			resistance = max_resistance
			days_broken = 0

class HouseClass:
	var houseName = ""
	var owner_name = ""
	var owner_anger = 0
	var owner_power = 5
	var current_beauty_points = 0
	# the local position in the neighbourhood scene
	var local_position = Vector2.ZERO
	var house_objects = []
	var is_player_house = false
	var garden_scene : PackedScene
	
	func get_beauty_points():
		var sum = 0
		for o in house_objects:
			if o.object_state == ObjectState.NORMAL:
				sum += o.points
		return sum
	
	func update_house_points(_new_points: int):
		 current_beauty_points = get_beauty_points()
	
	func update_anger(anger: int):
		owner_anger += anger
		owner_anger = clamp(owner_anger,0,100)
		
	func repair_object(object_name: String):
		for o in house_objects:
			if o.object_name == object_name and o.object_status == ObjectState.DESTROYED:
				o.object_state = ObjectState.NORMAL
				o.is_destroyed = false
				o.resistance = o.max_resistance
				o.days_broken = 0
	
	func destroy_all_objects():
		for o in house_objects:
			o.destroy()	
	
	func destroy_random_object():
		randomize()
		var available_objects = []
		for o in house_objects:
			if o.object_status == ObjectState.NORMAL:
				available_objects.append(o)
		var target_object = available_objects[randi() % available_objects.size()]
		target_object.destroy()
		

const OBJECTS_DEF = [
	{
		"name": "garden_gnome",
		"scene": preload("res://Scenes/Objects/GardenGnome.tscn"),
		"points": 2
	},
	{
		"name": "grass",
		"scene": preload("res://Scenes/Objects/grass.tscn"),
		"points": 4
	},
]
var houses : Array = []
var current_house : HouseClass = null
# Store a reference for the player house
var player_house : HouseClass = null

const TUTORIAL_DIALOGUE = [
	{
		"name": "Hello",
		"text": "Welcome to Quilicuma, where you will participate on the most beautifulest gardenest contestest\nThe Objective is having more beauty points than your neighbours at the end of the last day",
		"image": null
	},
	{
		"name": "Hello2",
		"text": "Get closer to any house to vandalize it, buy items to damage the garden on the Shop\n Check the inventory by pressing ESC",
		"image": preload("res://Images/tutorial/house_attack2.PNG")
	},
	{
		"name": "Hello3",
		"text": "Break all the items you can before the timer's up, whenever you break an object you win some vandal currency\nIf you get caugth up you will rise the neighbour's rage bar",
		"image": preload("res://Images/tutorial/attacking_house.PNG")
	},
	{
		"name": "Hello4",
		"text": "Sometimes your neighbours get angry at you and will attack you, go to your house and repair it",
		"image": preload("res://Images/tutorial/repair.PNG")
	},
	{
		"name": "Hello5",
		"text": "Every time you vandalize a house, time will pass.\nRemember, the grass is always greener on YOUR side",
		"image": null
	},
	
]

var is_tutorial_done = false

func _ready():
	randomize()

func load_houses(jaus):
	for h in jaus:
		var new_house = HouseClass.new()
		new_house.houseName = h.houseName
		new_house.owner_name = h.ownerName
		new_house.owner_anger = 60 + randi() % 100 - 60
		new_house.owner_power = 60 + randi() % 100 - 60
		# randomly set's the starting beauty points between 25 and 85
		new_house.current_beauty_points = h.current_beauty_points
		new_house.local_position = h.position
		new_house.is_player_house = h.is_player_house
		new_house.garden_scene = h.garden_scene
		var o = []
		for ob in h.objects:
			var house_object = HouseObject.new()
			house_object.object_name = ob.name
			house_object.points = ob.points
			house_object.days_to_recover = ob.days_to_recover
			house_object.resistance = ob.resistance
			house_object.max_resistance = ob.max_resistance
			house_object.multiple_hits = ob.multiple_hits
			# house_object.scene = ob.scene
			house_object.object_state = ob.current_state
			house_object.price_to_repair = ob.price_to_repair
			house_object.instance_id = house_object.get_instance_id()
			o.append(house_object)
		new_house.house_objects = o
		# load_house_objects(new_house)
		if new_house.is_player_house:
			player_house = new_house
		houses.append(new_house)

func load_house_objects(house):
	var n = 2 + randi() % 6
	# TODO: Have rules so windows are not instanced more than two times
	for _i in range(n):
		var object = OBJECTS_DEF[ (randi() % OBJECTS_DEF.size()) - 1]
		var no = HouseObject.new()
		no.instance_id = no.get_instance_id()
		no.object_name = object["name"]
		no.scene = object["scene"]
		no.points = object["points"]
		no.days_to_recover = object["days_to_recover"]
		no.object_state = ObjectState.NORMAL
		house.house_objects.append(no)

func add_house(house):
	var new_house = HouseClass.new()
	new_house.houseName = house.houseName
	new_house.current_beauty_points = house.current_beauty_points
	houses.append(new_house)
	
func get_new_beauty_points(points):
	if current_house == null:
		return 0
	return current_house.current_beauty_points - points

func get_player_house():
	return player_house
	
func set_current_house(house_name: String):
	for h in houses:
		if h.houseName == house_name:
			current_house = h
			break

func update_current_house_item_state(obj):
	if current_house == null:
		return
	var objects = current_house.house_objects
	for o in objects:
		if o.instance_id == obj.object_id:
			o.object_state = ObjectState.DESTROYED
			
