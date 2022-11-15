extends Node


onready var attack_ui = $CanvasLayer/AttackUI
onready var character = $Character



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	attack_ui.hide()
	attack_ui.connect("flee_from_fight", self, "go_back_to_map")
	character.position = PlayerGlobalData.player_neighbour_pos
	var houses = $Houses.get_children()
	for h in houses:
		#random between 25 and 85
		h.current_beauty_points = randi() % 60 + 25
		h.connect("on_house_entered", self, "_on_HouseDetectRadius_body_entered")
		Neighbourgood.add_house(h)
		
	
func _process(delta):
	PlayerGlobalData.player_neighbour_pos = character.position

func go_back_to_map():
	attack_ui.hide()
	character.allow_movement()

func _on_HouseDetectRadius_body_entered(house):
	Neighbourgood.set_current_house(house.houseName)
	character.stop_movement()
	character.go_to_idle()
	attack_ui.set_house_label()
	attack_ui.show()
	attack_ui.set_focus_on_attacks()
