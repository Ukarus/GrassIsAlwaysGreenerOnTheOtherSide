extends Node

enum ObjectState {NORMAL, DESTROYED}

class HouseObject:
	var object_name = ""
	var points
	var scene
	var object_state = ObjectState.NORMAL
	var instance_id = 0
	
	func destroy():
		object_state = ObjectState.DESTROYED

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
	
	func get_beauty_points():
		var sum = 0
		for o in house_objects:
			if o.object_state == ObjectState.NORMAL:
				sum += o.points
		return sum
	
	func update_house_points(new_points: int):
		 current_beauty_points = get_beauty_points()
	
	func update_anger(anger: int):
		owner_anger += anger
		owner_anger = clamp(owner_anger,0,100)

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
var houses_data = [
	{
		"owner_name": "John",
		"house_name": "John's House",
		"owner_anger": 0,
		"owner_power": 15,
		"position": Vector2(497, 170),
		"is_player_house": false
	},
	{
		"owner_name": "David",
		"house_name": "David's House",
		"owner_anger": 75,
		"owner_power": 7,
		"position": Vector2(100, 250),
		"is_player_house": false
	},
	{
		"owner_name": "Player",
		"house_name": "Player's House",
		"owner_power": 0,
		"owner_anger": 0,
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
		new_house.owner_anger = houses_data[i]["owner_anger"]
		new_house.owner_power = houses_data[i]["owner_power"]
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
		var object = OBJECTS_DEF[ (randi() % OBJECTS_DEF.size()) - 1]
		var no = HouseObject.new()
		no.instance_id = no.get_instance_id()
		no.object_name = object["name"]
		no.scene = object["scene"]
		no.points = object["points"]
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

func get_player_house():
	for h in houses:
		if h.is_player_house:
			return h
	
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
			
