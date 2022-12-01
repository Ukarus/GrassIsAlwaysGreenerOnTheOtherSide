extends CanvasLayer


export (bool) var player_won = false
#export (String) var winner_name 
onready var btn = $Control/Button

const bad_ending = preload("res://Images/Ending/bad_ending.png")
const good_ending = preload("res://Images/Ending/good_ending.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	btn.grab_focus()
	var winner_name = ""
	if TimeTracker.winner != null:
		winner_name = TimeTracker.winner.owner_name
	else:
		winner_name = "Jonas"
		
	if winner_name == "Player":
		$Control/TextureRect.texture = good_ending
	else:
		$Control/TextureRect.texture = bad_ending


func _on_Button_button_up():
	get_tree().quit()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
