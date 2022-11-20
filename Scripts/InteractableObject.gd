extends StaticBody2D

# beauty_points
export (int) var points = 3
export (int) var resistance = 1
export (String) var object_name = "interactive_object"

enum ObjectState {NORMAL, DESTROYED}
var current_state = ObjectState.NORMAL

var object_id = 0
var is_destroyed : bool = false
onready var animated_sprite = $AnimatedSprite


signal object_destroyed

func _ready():
	if animated_sprite != null:
		animated_sprite.play("normal")
		
func load_destroyed():
	is_destroyed = true
	$AnimationPlayer.play("die")

func destroy_object():
	$FCTManager.show_value(points)
	emit_signal("object_destroyed", self)
	$AnimationPlayer.play("die")

func damage(item):
	if !is_destroyed and item.can_interact_with_object(object_name):
		resistance -= 1
		$AnimationPlayer.play("dmg")
		if resistance <= 0:
			current_state = ObjectState.DESTROYED
			is_destroyed = true
			destroy_object()
		
