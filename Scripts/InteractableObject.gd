extends StaticBody2D

export (int) var points = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func destroy_object():
	$AnimationPlayer.play("die")
	print("destroying object")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
