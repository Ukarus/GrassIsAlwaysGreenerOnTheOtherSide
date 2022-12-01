extends Node

enum ObjectState {NORMAL, DESTROYED}
export (int) var garden_timer = 30
export (int) var min_objects = 4
export (int) var max_objects = 10
var gnome = preload("res://Scenes/Objects/GardenGnome.tscn")

var x_left = 96
var x_right = 923
var y_up = 96
var y_down = 475
var y_mid = 322

var objects = []

# Night Filter Colors  - Morning         - Afternoon       - Night
var filter_color = [Color("#ffffff"),Color("#f0dcc8"),Color("#82828c")]

onready var grass_tilemap = $Grass
onready var timer_label = $CanvasLayer/GardenAttackUI/TimerContainer/CountdownLabel
onready var house_label = $CanvasLayer/GardenAttackUI/HouseContainer/Label
onready var house_bar = $CanvasLayer/GardenAttackUI/HouseContainer/HouseBar
onready var day_label = $CanvasLayer/GardenAttackUI/TimeDateContainer/DayLabel
onready var daytime_label = $CanvasLayer/GardenAttackUI/TimeDateContainer/DayTimeLabel
onready var night_filter = $NightFilter
onready var interactive_objects = $InteractiveObjects
onready var character = $Character
onready var item_ui = $CanvasLayer/GardenAttackUI/ItemRectangle/ItemTexture

func _ready():
	randomize()
	set_camera_limits()
	load_house_ui_info()
#	load_house_objects()
	load_objects()
	# Add inventory to player
	character.add_items_to_inventory(PlayerGlobalData.inventory)
	character.equip_item("Axe")
	character.connect("changed_item_equipped", self, "set_item_texture")
	set_item_texture(character.item_equipped.texture)
	
	for i in character.inventory:
		i.connect("item_depleted", self, "set_item_depleted")
	# DEBUG: list objects
	for o in objects:
		print(o.object_name + ": " + ObjectState.keys()[o.object_state])
	
	# Connect signals of the interactive objects
	for o in interactive_objects.get_children():
		o.connect("object_destroyed", self, "update_house_points")
	update_time_ui()

func set_item_depleted(item_name: String):
	character.set_item_depleted(item_name)

# Update daytime labels and filter
func update_time_ui():
	day_label.text = "Days Left: %d" % TimeTracker.get_days_to_contest()
	daytime_label.text = TimeTracker.get_current_time()
	night_filter.color = filter_color[TimeTracker.current_time]

# Kick player from house when catched:
func kick_player():
	# Add neighbor anger
	Neighbourgood.current_house.owner_anger += randi()%5+1
	# Finish turn
	finish_turn()

func finish_turn():
	# Add anger to neighbour
	Neighbourgood.current_house.owner_anger += randi()%5+1
	TimeTracker.end_turn()
	get_tree().change_scene("res://Scenes/Movement Test Scene.tscn")

func load_objects():
	for o in objects:
		# Search objects in the scene by name
		var obj_instance = interactive_objects.get_node(o.object_name)
		if !o.multiple_hits:
			if o.object_state == ObjectState.DESTROYED:
				obj_instance.is_destroyed = true
				obj_instance.animated_sprite.play("broken")
		else:
			# handle multi hits objects
			obj_instance.resistance = o.resistance
			if o.resistance == o.max_resistance:
				obj_instance.animated_sprite.play("normal")
			elif o.resistance <= 1:
				obj_instance.animated_sprite.play("broken1")
				obj_instance.is_destroyed = true
			else:
				obj_instance.animated_sprite.play("broken"+String(o.resistance))
	pass

func load_house_objects():
	for o in objects:
		var pos = Vector2(x_left + randi() % (x_right - x_left), y_up + randi() % (y_down - y_up))
		if pos.y < y_mid:
			var dir = "left" if randf() < 0.5 else "right"
			if dir == "left":
				pos.x = 71 + randi() % (173 - 71)
			else:
				pos.x = 847 + randi() % (948 - 847)
		var new_object = o.scene.instance()
		new_object.object_id = o.instance_id
		new_object.position = pos
		if o.object_state == ObjectState.DESTROYED:
			new_object.load_destroyed()
		interactive_objects.add_child(new_object)

func randomize_items():
	var n_objects = min_objects + randi() % (max_objects - min_objects)
	for _i in range(10):
		var pos = Vector2(x_left + randi() % (x_right - x_left), y_up + randi() % (y_down - y_up))
		if pos.y < y_mid:
			var dir = "left" if randf() < 0.5 else "right"
			if dir == "left":
				pos.x = 71 + randi() % (173 - 71)
			else:
				pos.x = 847 + randi() % (948 - 847)
		var new_gnome = gnome.instance()
		new_gnome.position = pos
		interactive_objects.add_child(new_gnome)
		

func paint_random_grass():
	for _i in range(10):
		var pos = Vector2(randi() % 27 + 2, randi() % 17 + 2)
		grass_tilemap.set_cell(pos.x, pos.y, 1)

#func update_house_points(points: int):
func update_house_points(obj):
	var new_points = Neighbourgood.get_new_beauty_points(obj.points)
	house_bar.value = new_points
	Neighbourgood.update_current_house_item_state(obj)
	Neighbourgood.current_house.update_house_points(new_points)
	PlayerGlobalData.add_vandal_currency(obj.points)
	# Destroy object in data
	for o in objects:
		if o.object_name == obj.name:
			o.object_state = ObjectState.DESTROYED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if garden_timer == 0:
		finish_turn()
	timer_label.text = "{t}".format({"t": garden_timer})
	
func load_house_ui_info():
	var current_house = Neighbourgood.current_house
	if current_house != null:
		house_bar.value = current_house.current_beauty_points
		house_label.text = current_house.houseName
		objects = current_house.house_objects

func set_camera_limits():
	var map_limits = $Grass.get_used_rect()
	var map_cellsize = $Grass.cell_size
	character.set_camera_limits(
		map_limits.position.x * map_cellsize.x,
		map_limits.end.x * map_cellsize.x,
		map_limits.position.y * map_cellsize.y,
		(map_limits.end.y * map_cellsize.y) + map_cellsize.y
	)

func set_item_texture(texture: Texture):
	item_ui.texture = texture

func _on_Timer_timeout():
	garden_timer -= 1
