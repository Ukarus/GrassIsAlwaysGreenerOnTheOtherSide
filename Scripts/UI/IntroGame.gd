extends TextureRect


onready var start_button = $ButtonsContainer/StartButton
onready var exit_button = $ButtonsContainer/ExitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/Movement Test Scene.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
