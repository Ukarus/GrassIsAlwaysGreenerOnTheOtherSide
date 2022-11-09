extends Node2D

export (int) var garden_timer = 30
onready var timer_label = $CountdownUI/CountdownLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if garden_timer == 0:
		get_tree().change_scene("res://Scenes/Movement Test Scene.tscn")
	timer_label.text = "{t}".format({"t": garden_timer})


func _on_Timer_timeout():
	garden_timer -= 1
