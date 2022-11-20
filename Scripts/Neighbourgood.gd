extends Node

enum ObjectState {NORMAL, DESTROYED}
const gnome = preload("res://Scenes/GardenGnome.tscn")
const window = preload("res://Scenes/window.tscn")
const grass = preload("res://Scenes/grass.tscn")

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
	
	func update_house_points(new_points: int):
		 current_beauty_points = new_points


var objects = [
	window,
	grass
]
var houses : Array = []
var current_house : HouseClass = null
var houses_data = [
	{
		"owner_name": "John",
		"house_name": "John's House",
		"position": Vector2(497, 170)
	},
	{
		"owner_name": "David",
		"house_name": "David's House",
		"position": Vector2(100, 250)
	},
]

func _ready():
	randomize()
	for i in range(houses_data.size()):
		var new_house = HouseClass.new()
		new_house.houseName = houses_data[i]["house_name"]
		new_house.owner_name = houses_data[i]["owner_name"]
		new_house.current_beauty_points = randi() % 60 + 25
		new_house.local_position = houses_data[i]["position"]
		load_house_objects(new_house)
		houses.append(new_house)
		
func load_house_objects(house: HouseClass):
	for i in range(2):
		var no = HouseObject.new()
		no.instance_id = no.get_instance_id()
		no.object_name = "garden_gnome"
		no.scene = gnome
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
	
func update_current_house_points(new_points: int):
	if current_house == null:
		return
	for h in houses:
		if h.houseName == current_house.houseName:
			h.current_beauty_points = new_points
	current_house.current_beauty_points = new_points
	
func set_current_house(house_name: String):
	for h in houses:
		if h.houseName == house_name:
			current_house = h

func update_current_house_item_state(obj):
	if current_house == null:
		return
	var objects = current_house.house_objects
	for o in objects:
		if o.instance_id == obj.object_id:
			o.object_state = ObjectState.DESTROYED
			
