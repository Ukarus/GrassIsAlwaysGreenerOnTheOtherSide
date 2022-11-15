extends Node


var axe = preload("res://Scenes/Items/Axe.tscn")
var rock = preload("res://Scenes/Items/Rock.tscn")
var player_neighbour_pos = Vector2(170, 258)

# Array 
var inventory = []


# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.append(axe)
	inventory.append(rock)
	
