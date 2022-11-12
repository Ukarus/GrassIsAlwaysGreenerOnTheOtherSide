extends StaticBody2D

export (int) var points = 3
export (int) var resistance = 1
var is_destroyed : bool = false


signal object_destroyed

func destroy_object():
	$FCTManager.show_value(points)
	emit_signal("object_destroyed", points)
	$AnimationPlayer.play("die")

func damage():
	if !is_destroyed:
		resistance -= 1
		$AnimationPlayer.play("dmg")
		if resistance <= 0:
			is_destroyed = true
			destroy_object()
		
