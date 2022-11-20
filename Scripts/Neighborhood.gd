extends Node


onready var attack_ui = $CanvasLayer/AttackUI
onready var character = $Character
onready var houses_node = $Houses
const houseNode = preload("res://Scenes/House.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	attack_ui.hide()
	attack_ui.connect("flee_from_fight", self, "go_back_to_map")
	character.position = PlayerGlobalData.player_neighbour_pos
	var houses = Neighbourgood.houses
	
	for h in houses:
		var new_house = houseNode.instance()
		new_house.load_data(h)
		houses_node.add_child(new_house)
		new_house.position = h.local_position
		new_house.connect("on_house_entered", self, "_on_HouseDetectRadius_body_entered")
		
	
func _process(_delta):
	PlayerGlobalData.player_neighbour_pos = character.position

func go_back_to_map():
	attack_ui.hide()
	character.allow_movement()

func _on_HouseDetectRadius_body_entered(house):
	print(house.houseName)
	Neighbourgood.set_current_house(house.houseName)
	print(Neighbourgood.current_house.is_player_house)
	character.stop_movement()
	character.go_to_idle()
	attack_ui.set_house_label()
	attack_ui.load_options_for_player_house()
	attack_ui.show()
	attack_ui.set_focus_on_attacks()
