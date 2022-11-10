extends Node2D

# Moving camera setting
export(float) var start_rotation = 0.0
export(float) var min_rotation = -90.0
export(float) var max_rotation = 90.0
export(float) var rot_speed = 0.5

# Fixed angle to stop camera from moving
export(bool) var fixed_angle = false
export(float) var angle = 0.0

onready var area: Area2D = $Area2D

var _pos_rot = true
var bias = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	if fixed_angle:
		area.rotation_degrees = angle
	else:
		area.rotation_degrees = start_rotation
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fixed_angle:
		return
	if _pos_rot:
		area.rotation = lerp_angle(area.rotation, deg2rad(max_rotation), rot_speed * delta)
		if abs(area.rotation_degrees - max_rotation) <= bias:
			_pos_rot = false
	else:
		area.rotation = lerp_angle(area.rotation, deg2rad(min_rotation), rot_speed * delta)
		if abs(area.rotation_degrees - min_rotation) <= bias:
			_pos_rot = true
	pass
