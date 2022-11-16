extends StaticBody2D

# beauty_points
export (int) var points = 3
export (int) var resistance = 1
export (String) var object_name = "interactive_object"
var is_destroyed : bool = false


signal object_destroyed

func _ready():
	if $AnimatedSprite != null:
		$AnimatedSprite.play("normal")

func destroy_object():
	$FCTManager.show_value(points)
	emit_signal("object_destroyed", points)
	$AnimationPlayer.play("die")

func damage(item):
	if !is_destroyed and item.can_interact_with_object(object_name):
		resistance -= 1
		$AnimationPlayer.play("dmg")
		if resistance <= 0:
			is_destroyed = true
			destroy_object()
		
