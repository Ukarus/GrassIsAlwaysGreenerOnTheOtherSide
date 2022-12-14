extends StaticBody2D

# beauty_points
export (int) var points = 3
export (int) var resistance = 1
export (int) var max_resistance = 1
export (int) var days_to_recover = 1
export (String) var object_name = "interactive_object"
export (bool) var multiple_hits = false
export (int) var price_to_repair = 5

enum ObjectState {NORMAL, DESTROYED}
onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
onready var sound_stream = $AudioStreamPlayer
var current_state = ObjectState.NORMAL
var object_id = 0
var is_destroyed : bool = false

signal object_destroyed

func _ready():
#	current_resistance = max_resistance
	if animated_sprite != null:
		animated_sprite.play("normal")
		
func load_destroyed():
	#$AnimationPlayer.play("die")
	if !multiple_hits:
		animated_sprite.play("broken")
		is_destroyed = true
		current_state = ObjectState.DESTROYED
	else:
		animated_sprite.play("broken"+String(resistance))
		if resistance <= 0:
			is_destroyed = true
			current_state = ObjectState.DESTROYED

func damage_object(res):
# $FCTManager.show_value(points)
#	emit_signal("object_destroyed", points)
	animated_sprite.play("broken"+String(res))
	# Update resistance in data
	for o in Neighbourgood.current_house.house_objects:
		if o.object_name == name:
			o.resistance = resistance

func destroy_object():
	if sound_stream != null:
		sound_stream.play()
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
			if sound_stream != null:
				sound_stream.play()
			damage_object(resistance)
		if item.has_durability:
			item.reduce_durability()
		$AnimationPlayer.play("dmg")
		if resistance <= 0 or (multiple_hits and resistance <= 1):
			current_state = ObjectState.DESTROYED
			is_destroyed = true
			destroy_object()

