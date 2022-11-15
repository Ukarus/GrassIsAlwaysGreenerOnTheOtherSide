extends Node

export (int) var garden_timer = 30
onready var timer_label = $CanvasLayer/GardenAttackUI/TimerContainer/CountdownLabel
onready var house_label = $CanvasLayer/GardenAttackUI/HouseContainer/Label
onready var house_bar = $CanvasLayer/GardenAttackUI/HouseContainer/CenterContainer/HouseBar
onready var interactive_objects = $InteractiveObjects
onready var character = $Character
onready var item_ui = $CanvasLayer/GardenAttackUI/ItemRectangle/ItemTexture

func _ready():
	# TODO: Fix this thing
	set_camera_limits()
	var current_house = Neighbourgood.current_house
	if current_house != null:
		house_bar.value = current_house.current_beauty_points
		house_label.text = current_house.name
		
	for o in interactive_objects.get_children():
		o.connect("object_destroyed", self, "update_house_points")
	var inventory = PlayerGlobalData.inventory
	character.add_items_to_inventory(inventory)
	character.equip_item("Axe")
	character.connect("changed_item_equipped", self, "set_item_texture")
	item_ui.texture = character.item_equipped.texture
	
func update_house_points(points: int):
	var new_points = Neighbourgood.get_new_beauty_points(points)
	house_bar.value = new_points
	Neighbourgood.update_current_house_points(new_points)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if garden_timer == 0:
		get_tree().change_scene("res://Scenes/Movement Test Scene.tscn")
	timer_label.text = "{t}".format({"t": garden_timer})

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
