extends KinematicBody2D

var speed = 300
var directions = ["idle_down","idle_up","idle_left","idle_right"]
var dir = 0
var state_machine
var can_move = true

# TODO: Current attacks (vandalic actions) on a list
# TODO: pass info of current attacks to attackUI

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.start("idle_down")

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
		move_down()
	elif Input.is_action_pressed("move_up"):
		move_up()
	elif Input.is_action_pressed("move_left"):
		move_left()
	elif Input.is_action_pressed("move_right"):
		move_right()
	else:
		state_machine.travel(directions[dir])
	pass


func move_down():
	var velocity = move_and_slide(Vector2(0.0,1.0) * speed)
	# Check that we're moving
	if velocity.length_squared() > 0.5:
		state_machine.travel("walk_down")
	else:
		state_machine.travel("idle_down")
	dir = 0
	pass

func move_up():
	var velocity = move_and_slide(Vector2(0.0,-1.0) * speed)
	# Check that we're moving
	if velocity.length_squared() > 0.5:
		state_machine.travel("walk_up")
	else:
		state_machine.travel("idle_up")
	dir = 1
	pass

func move_left():
	var velocity = move_and_slide(Vector2(-1.0,0.0) * speed)
	# Check that we're moving
	if velocity.length_squared() > 0.5:
		state_machine.travel("walk_left")
	else:
		state_machine.travel("idle_left")
	dir = 2
	pass

func move_right():
	var velocity = move_and_slide(Vector2(1.0,0.0) * speed)
	if velocity.length_squared() > 0.5:
		state_machine.travel("walk_right")
	else:
		state_machine.travel("idle_right")
	dir = 3
	pass
