extends KinematicBody2D

var speed = 300
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

onready var hitbox = $HitBoxArea
onready var camera = $Camera2D

# TODO: Current attacks (vandalic actions) on a list
# TODO: pass info of current attacks to attackUI

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.start("idle_down")
	move_hitbox("down")
	
func add_items_to_inventory(items: Array):
	for i in items:
		inventory.append(i.instance())
		
func equip_item(item_name: String):
	for i in inventory:
		if i.item_name == item_name:
			item_equipped = i

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
	elif Input.is_action_just_pressed("use_object"):
		print(item_equipped)
		for obj in objects:
			obj.damage(item_equipped)
	else:
		state_machine.travel(directions[dir])
		
func move_hitbox(direction: String):
	hitbox.position = hitbox_dir[direction]

func move_to_direction(direction: String):
	var velocity = move_and_slide(vector_directions[direction] * speed)
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

func _on_HitBoxArea_body_entered(body):
	objects.append(body)

func _on_HitBoxArea_body_exited(body):
	objects.pop_back()
