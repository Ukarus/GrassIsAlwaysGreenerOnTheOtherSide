extends Node

export (int) var garden_timer = 30
export (int) var min_objects = 4
export (int) var max_objects = 10
var gnome = preload("res://Scenes/GardenGnome.tscn")

var x_left = 96
var x_right = 923
var y_up = 96
var y_down = 475
var y_mid = 322


onready var grass_tilemap = $Grass
onready var timer_label = $CanvasLayer/GardenAttackUI/TimerContainer/CountdownLabel
onready var house_label = $CanvasLayer/GardenAttackUI/HouseContainer/Label
onready var house_bar = $CanvasLayer/GardenAttackUI/HouseContainer/CenterContainer/HouseBar
onready var interactive_objects = $InteractiveObjects
onready var character = $Character
onready var item_ui = $CanvasLayer/GardenAttackUI/ItemRectangle/ItemTexture

func _ready():
	randomize()
	set_camera_limits()
	var current_house = Neighbourgood.current_house
	if current_house != null:
		house_bar.value = current_house.current_beauty_points
		house_label.text = current_house.name
	paint_random_grass()
	randomize_items()	
	# Add inventory to player
	character.add_items_to_inventory(PlayerGlobalData.inventory)
	character.equip_item("Axe")
	character.connect("changed_item_equipped", self, "set_item_texture")
	set_item_texture(character.item_equipped.texture)
	# Connect signals of the interactive objects
	for o in interactive_objects.get_children():
		o.connect("object_destroyed", self, "update_house_points")
	

func randomize_items():
	var n_objects = min_objects + randi() % (max_objects - min_objects)
	for i in range(10):
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
	for i in range(10):
		var pos = Vector2(randi() % 27 + 2, randi() % 17 + 2)
		grass_tilemap.set_cell(pos.x, pos.y, 1)

func update_house_points(points: int):
	var new_points = Neighbourgood.get_new_beauty_points(points)
	house_bar.value = new_points
	Neighbourgood.update_current_house_points(new_points)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if garden_timer == 0:
		get_tree().change_scene("res://Scenes/Movement Test Scene.tscn")
	timer_label.text = "{t}".format({"t": garden_timer})
	
	if Input.is_action_just_pressed("ui_select"):
		for i in interactive_objects.get_children():
			i.queue_free()
		randomize_items()

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
