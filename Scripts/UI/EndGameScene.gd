extends CanvasLayer


export (bool) var player_won = false
export (String) var winner_name 

# Called when the node enters the scene tree for the first time.
func _ready():
	var pw = true if TimeTracker.winner.owner_name == "Player" else false
	if pw:
		$Control/Label.text = "You won"
	else:
		$Control/Label.text = "You lost against {n}\n Better luck next time!".format({"n": TimeTracker.winner.owner_name})


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
