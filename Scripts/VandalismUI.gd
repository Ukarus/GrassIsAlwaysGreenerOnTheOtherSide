extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/ItemList.grab_focus()
	pass # Replace with function body.

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_up"):
		print("ui up")
	if event.is_action_pressed("ui_down"):
		print("ui down")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Action1_pressed():
	#TODO: Change to scene that shows the vignettes, 
	# then determine how much damage have you done
	# and if the vandalism was successful
	$NeighborBar.value = $NeighborBar.value - 10
