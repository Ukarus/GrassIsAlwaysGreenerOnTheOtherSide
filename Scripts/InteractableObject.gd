extends StaticBody2D

export (int) var points = 3


func destroy_object():
	$AnimationPlayer.play("die")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
