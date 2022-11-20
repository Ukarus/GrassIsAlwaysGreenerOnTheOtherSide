extends StaticBody2D

# beauty_points
export (int) var points = 3
export (int) var max_resistance = 1
export (int) var current_resistance = 1
export (String) var object_name = "interactive_object"
enum ObjectState {NORMAL, DESTROYED}

onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
var current_state = ObjectState.NORMAL
var object_id = 0
var is_destroyed : bool = false


signal object_destroyed

func _ready():
#	current_resistance = max_resistance
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
		current_resistance -= 1
		$AnimationPlayer.play("dmg")
		if current_resistance <= 0:
			current_state = ObjectState.DESTROYED
			is_destroyed = true
			destroy_object()
		
