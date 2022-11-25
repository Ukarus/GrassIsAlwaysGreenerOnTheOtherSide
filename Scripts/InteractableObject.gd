extends StaticBody2D

# beauty_points
export (int) var points = 3
export (int) var resistance = 1
export (String) var object_name = "interactive_object"
export (bool) var multiple_hits = false

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

func damage_object(res):
# $FCTManager.show_value(points)
#	emit_signal("object_destroyed", points)
	animated_sprite.play("broken"+String(res))

func destroy_object():
	if !multiple_hits:
		animated_sprite.play("broken")
		$FCTManager.show_value(points)
		emit_signal("object_destroyed", self)
	else:
		$FCTManager.show_value(points)
		animated_sprite.play("broken1")
		emit_signal("object_destroyed", self)


func damage(item):
	if !is_destroyed and item.can_interact_with_object(object_name):
		resistance -= 1
		if multiple_hits:
			damage_object(resistance)
		if item.has_durability:
			item.reduce_durability()
		$AnimationPlayer.play("dmg")
		if resistance <= 0 or (multiple_hits and resistance <= 1):
			current_state = ObjectState.DESTROYED
			is_destroyed = true
			destroy_object()

