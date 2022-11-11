extends Node

export (int) var garden_timer = 30
onready var timer_label = $GardenAttackUI/CountdownLabel
onready var house_label = $GardenAttackUI/HouseContainer/Label
onready var house_bar = $GardenAttackUI/HouseContainer/CenterContainer/HouseBar

func _ready():
	pass
	# TODO: Fix this thing
#	var current_house = Neighbourgood.current_house
#	if current_house != null:
#		house_bar.value = current_house.current_beauty_points
#		house_bar.max_value = current_house.max_beauty_points
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if garden_timer == 0:
		get_tree().change_scene("res://Scenes/Movement Test Scene.tscn")
	timer_label.text = "{t}".format({"t": garden_timer})


func _on_Timer_timeout():
	garden_timer -= 1
