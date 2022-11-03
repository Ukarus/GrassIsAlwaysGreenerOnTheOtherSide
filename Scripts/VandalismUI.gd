extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Action1_pressed():
	#TODO: Change to scene that shows the vignettes, 
	# then determine how much damage have you done
	# and if the vandalism was successful
	$NeighborBar.value = $NeighborBar.value - 10
