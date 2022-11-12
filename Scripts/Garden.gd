extends Node

export (int) var garden_timer = 30
onready var timer_label = $GardenAttackUI/CountdownLabel
onready var house_label = $GardenAttackUI/HouseContainer/Label
onready var house_bar = $GardenAttackUI/HouseContainer/CenterContainer/HouseBar
onready var interactive_objects = $InteractiveObjects

func _ready():
	# TODO: Fix this thing
	var current_house = Neighbourgood.current_house
	if current_house != null:
		house_bar.value = current_house.current_beauty_points
		house_label.text = current_house.name
		
	for o in interactive_objects.get_children():
		o.connect("object_destroyed", self, "update_house_points")
#		house_bar.max_value = current_house.max_beauty_points
	
func update_house_points(points: int):
	var new_points = Neighbourgood.current_house.current_beauty_points - points
	house_bar.value = new_points
	Neighbourgood.update_current_house_points(new_points)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if garden_timer == 0:
		get_tree().change_scene("res://Scenes/Movement Test Scene.tscn")
	timer_label.text = "{t}".format({"t": garden_timer})


func _on_Timer_timeout():
	garden_timer -= 1
