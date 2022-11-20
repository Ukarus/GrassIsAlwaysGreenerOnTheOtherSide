extends Node

enum ObjectState {NORMAL, DESTROYED}

class HouseObject:
	var object_name = ""
	var scene
	var object_state = ObjectState.NORMAL
	var instance_id = 0

class HouseClass:
	var houseName = ""
	var owner_name = ""
	var current_beauty_points = 0
	# the local position in the neighbourhood scene
	var local_position = Vector2.ZERO
	var house_objects = []
	var is_player_house = false
	
	func update_house_points(new_points: int):
		 current_beauty_points = new_points


const OBJECTS_DEF = [
	{
		"name": "garden_gnome",
		"scene": preload("res://Scenes/Objects/GardenGnome.tscn")
	},
	{
		"name": "grass",
		"scene": preload("res://Scenes/Objects/grass.tscn")
	},
	{
		"name": "window",
		"scene": preload("res://Scenes/Objects/window.tscn")
	},
	
]
var houses : Array = []
var current_house : HouseClass = null
var houses_data = [
	{
		"owner_name": "John",
		"house_name": "John's House",
		"position": Vector2(497, 170),
		"is_player_house": false
	},
	{
		"owner_name": "David",
		"house_name": "David's House",
		"position": Vector2(100, 250),
		"is_player_house": false
	},
	{
		"owner_name": "Player",
		"house_name": "Player's House",
		"position": Vector2(940, 38),
		"is_player_house": true
	},
]

func _ready():
	randomize()
	for i in range(houses_data.size()):
		var new_house = HouseClass.new()
		new_house.houseName = houses_data[i]["house_name"]
		new_house.owner_name = houses_data[i]["owner_name"]
		# randomly set's the starting beauty points between 25 and 85
		new_house.current_beauty_points = randi() % 60 + 25
		new_house.local_position = houses_data[i]["position"]
		new_house.is_player_house = houses_data[i]["is_player_house"]
		load_house_objects(new_house)
		houses.append(new_house)
		
func load_house_objects(house: HouseClass):
	var n = 2 + randi() % 6
	# TODO: Have rules so windows are not instanced more than two times
	for i in range(n):
		var object = OBJECTS_DEF[ (1 + randi() % OBJECTS_DEF.size()) - 1]
		var no = HouseObject.new()
		no.instance_id = no.get_instance_id()
		no.object_name = object["name"]
		no.scene = object["scene"]
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
	
#func update_current_house_points(new_points: int):
#	if current_house == null:
#		return
#	for h in houses:
#		if h.houseName == current_house.houseName:
#			h.current_beauty_points = new_points
#	current_house.current_beauty_points = new_points
	
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
			
