extends Node



var click_sound = preload("res://Assets/Sounds/click1.ogg")
var rollover_sound = preload("res://Assets/Sounds/rollover1.ogg")
var audio_stream : AudioStreamPlayer

func play_sound(sound_name: String):
	if sound_name == 'click1':
		audio_stream.set_stream(click_sound)
		audio_stream.play()
	elif sound_name == 'rollover':
		audio_stream.set_stream(rollover_sound)
		audio_stream.play()
