extends Node


var axe = preload("res://Scenes/Items/Axe.tscn")
var rock = preload("res://Scenes/Items/Rock.tscn")
var flamethrower = preload("res://Scenes/Items/flamethrower.tscn")
var eggs = preload("res://Scenes/Items/eggs.tscn")
var spray = preload("res://Scenes/Items/spray.tscn")
var player_neighbour_pos = Vector2(170, 258)

# Array 
var inventory = []


# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.append(axe)
	inventory.append(rock)
	inventory.append(flamethrower)
	inventory.append(eggs)
	inventory.append(spray)
