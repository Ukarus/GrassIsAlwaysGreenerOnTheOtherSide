extends Sprite

export (String) var item_name
export (Array, String) var objects_to_interact
export (bool) var has_durability = false
export (int) var durability = 5
export (int) var max_durability = 5
export (int) var price = 5
onready var audio_stream = $AudioStreamPlayer2D

signal item_depleted

func _ready():
	print(audio_stream)
	
func can_interact_with_object(object_name: String) -> bool:
	return object_name in objects_to_interact

func reduce_durability():
	durability -= 1
	
	if durability < 1:
		emit_signal("item_depleted", item_name)

func play_sound():
	if audio_stream != null:
		audio_stream.play()
