extends KinematicBody2D

export(int) var walk_speed = 45
export(int) var run_speed = 100
export(bool) var running = false

export(bool) var _debug = true
onready var debug_line = $Line2D

onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_player: AnimationPlayer = $AnimationPlayer
var patrol_path: Array = []  # Path to objective
var patrol_nodes: Array = [] # Patrolling nodes
var patrol_node = 0
var patrol_mode = true

var directions = ["idle_down","idle_up","idle_left","idle_right"]
var dir = 0

var _velocity: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO
onready var _timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle_down")
	var _ret = _timer.connect("timeout", self, "_get_path")
	var tree = get_tree()
	if tree.has_group("doggo_path"):
		patrol_nodes = tree.get_nodes_in_group("doggo_path")
		navigation_agent.set_target_location(patrol_nodes[patrol_node].global_position)
	
	pass # Replace with function body.

func _physics_process(_delta):
	debug_line.global_position = Vector2.ZERO
	if patrol_nodes:
		navigate()
	pass

func _get_path():
	if patrol_nodes:
		var next_node = patrol_nodes[patrol_node]
		navigation_agent.set_target_location(next_node.global_position)
		
	pass

func navigate():
	if navigation_agent.is_navigation_finished():
		patrol_node += 1
		if patrol_node >= patrol_nodes.size():
			patrol_node = 0
		_get_path()
		return
	
	_direction = global_position.direction_to(navigation_agent.get_next_location())
	if running:
		_velocity = move_and_slide(_direction * run_speed)
	else:
		_velocity = move_and_slide(_direction * walk_speed)
	
	if _debug:
		debug_line.points = navigation_agent.get_nav_path()
	selec_anim()
	
	pass

func selec_anim():
	var mov_dir = _direction.normalized()
	if mov_dir == Vector2.ZERO:
		animation_player.play("idle_down")

	if abs(mov_dir.x) > abs(mov_dir.y):
		if mov_dir.x > 0:
			if running:
				animation_player.play("run_right")
			else:
				animation_player.play("walk_right")
		else:
			if running:
				animation_player.play("run_left")
			else:
				animation_player.play("walk_left")
	else:
		if mov_dir.y > 0:
			if running:
				animation_player.play("run_down")
			else:
				animation_player.play("walk_down")
		else:
			if running:
				animation_player.play("run_up")
			else:
				animation_player.play("walk_up")
