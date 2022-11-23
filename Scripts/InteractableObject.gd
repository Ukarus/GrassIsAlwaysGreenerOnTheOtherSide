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

func damage_object(resistance):
	$FCTManager.show_value(points)
#	emit_signal("object_destroyed", points)
	$AnimatedSprite.play("broken"+String(resistance))

func destroy_object():
	if !multiple_hits:
		$FCTManager.show_value(points)
		emit_signal("object_destroyed", self)
		$AnimatedSprite.play("broken")
	else:
		$AnimatedSprite.play("broken1")
	

func damage(item):
	if !is_destroyed and item.can_interact_with_object(object_name):
		if !multiple_hits:
			resistance -= 1
			$AnimationPlayer.play("dmg")
			if resistance <= 0:
				current_state = ObjectState.DESTROYED
				is_destroyed = true
				destroy_object()
		else:
			resistance -= 1
			print(resistance)
			damage_object(resistance)
			$AnimationPlayer.play("dmg")
			if resistance <= 1:
				current_state = ObjectState.DESTROYED
				is_destroyed = true
				destroy_object()
			

