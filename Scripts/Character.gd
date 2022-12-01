extends KinematicBody2D

export (int) var speed = 200
var directions = ["idle_down","idle_up","idle_left","idle_right"]
var dir = 0
var state_machine
var can_move = true

var vector_directions = {
	"down": Vector2.DOWN,
	"up": Vector2.UP,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}
var directions_statemachine = {
	"down": 0,
	"up": 1,
	"left": 2,
	"right": 3
}
var hitbox_dir = {
	"down": Vector2(0, 35),
	"up": Vector2(0, -20),
	"right": Vector2(20, 10),
	"left": Vector2(-20, 10),
}
var objects = []
var inventory = []
var item_equipped
var current_item_index = 0

onready var hitbox = $HitBoxArea
onready var camera = $Camera2D
onready var sounds_stream = $SoundsStream
var flamethrower_sound = preload("res://Assets/Sounds/flamethrower2.ogg")
var spray = preload("res://Assets/Sounds/spray1.wav")
export (Rect2) var map_limits

signal changed_item_equipped

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.start("idle_down")
	move_hitbox("down")
	
func add_items_to_inventory(items: Array):
	for i in items:
		inventory.append(i.scene.instance())
		
func equip_item(item_name: String):
	for i in range(inventory.size()):
		if inventory[i].item_name == item_name:
			item_equipped = inventory[i]
			current_item_index = i

func stop_movement():
	can_move = false

func allow_movement():
	can_move = true
	
func go_to_idle():
	state_machine.travel(directions[dir])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !can_move:
		return
		
	if Input.is_action_pressed("move_down"):
		move_to_direction("down")
		move_hitbox("down")
	elif Input.is_action_pressed("move_up"):
		move_to_direction("up")
		move_hitbox("up")
	elif Input.is_action_pressed("move_left"):
		move_to_direction("left")
		move_hitbox("left")
	elif Input.is_action_pressed("move_right"):
		move_to_direction("right")
		move_hitbox("right")
	else:
		state_machine.travel(directions[dir])

	if Input.is_action_just_pressed("use_object"):
		if item_equipped == null:
			return
		play_sound(item_equipped.item_name)
		for obj in objects:
			obj.damage(item_equipped)
	if Input.is_action_just_pressed("next_item"):
		equip_next_item()
	if Input.is_action_just_pressed("previous_item"):
		equip_previous_item()
	
		
func move_hitbox(direction: String):
	hitbox.position = hitbox_dir[direction]

func move_to_direction(direction: String):
	var velocity = move_and_slide(vector_directions[direction] * speed)
	if map_limits != null and map_limits.size != Vector2.ZERO:
		var end = map_limits.end
		var start = map_limits.position
		if velocity.x != 0:
			global_position.x = clamp(global_position.x, start.x, end.x)
		if velocity.y != 0:
			global_position.y = clamp(global_position.y, start.y, end.y)
	# Check that we're moving
	if velocity.length_squared() > 0.5:
		state_machine.travel("walk_" + direction)
	else:
		state_machine.travel("idle_" + direction)
	dir = directions_statemachine[direction]
	
func set_camera_limits(left: float, 
	right: float, 
	up: float, 
	down: float):
	camera.limit_left = left
	camera.limit_right = right
	camera.limit_top = up
	camera.limit_bottom = down
	
func equip_next_item():
	if inventory.size() == 0:
			return
	if current_item_index - 1 < 0:
		current_item_index = inventory.size() - 1
	else:
		current_item_index -= 1
		
	var new_item = inventory[current_item_index]
	item_equipped = new_item
	emit_signal("changed_item_equipped", new_item.texture)
	
func equip_previous_item():
	if inventory.size() == 0:
		return
	if current_item_index + 1 > inventory.size() - 1:
		current_item_index = 0
	else:
		current_item_index += 1
		
	var new_item = inventory[current_item_index]
	item_equipped = new_item
	emit_signal("changed_item_equipped", new_item.texture)

func set_item_depleted(item_name: String):
	PlayerGlobalData.remove_item_from_inventory(item_equipped.item_name)
	var prev_item_index = current_item_index
	equip_next_item()
	inventory.pop_at(prev_item_index)
	

func _on_HitBoxArea_body_entered(body):
	objects.append(body)

func _on_HitBoxArea_body_exited(_body):
	objects.pop_back()

func play_sound(sound_name: String):
	if sound_name == 'flamethrower' and !sounds_stream.playing:
		sounds_stream.set_stream(flamethrower_sound)
		sounds_stream.play()
	elif sound_name == 'spray' and !sounds_stream.playing:
		sounds_stream.set_stream(spray)
		sounds_stream.play()
		
