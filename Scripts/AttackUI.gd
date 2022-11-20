extends Control

export (PackedScene) var garden_scene

var options = [
	"Attack",
	"Stats",
	"Back"
]
var player_options = [
	"Stats",
	"Back"
]
onready var item_list = $VSplitContainer/ItemList
onready var house_label = $VSplitContainer/Label
onready var house_bar = $VSplitContainer/PopularityBar
enum SUBMENUS {OPTIONS, ATTACK, STATS}
var active_submenu = SUBMENUS.OPTIONS

signal flee_from_fight

# Called when the node enters the scene tree for the first time.
func _ready():
	add_options()
	set_focus_on_attacks()
	
	
func set_house_label():
	var current_house = Neighbourgood.current_house
	house_label.text = current_house.houseName
	house_bar.value = current_house.current_beauty_points
	house_bar.max_value = 100 

func set_focus_on_attacks():
	item_list.grab_focus()
	item_list.select(0)

func load_options_for_player_house():
	var current_house = Neighbourgood.current_house
	if current_house.is_player_house:
		item_list.clear()
		for o in player_options:
			item_list.add_item(o)
		

func add_options():
	for a in options:
		item_list.add_item(a)
				

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if active_submenu == SUBMENUS.ATTACK or active_submenu == SUBMENUS.STATS:
			active_submenu = SUBMENUS.OPTIONS
			item_list.clear()
			add_options()
			load_options_for_player_house()
			set_focus_on_attacks()
		elif active_submenu == SUBMENUS.OPTIONS:
			emit_signal("flee_from_fight")
			
# TODO: Check for amount of attacks that can be done
func _on_ItemList_item_activated(index):
	var option = item_list.get_item_text(index)
	
	if option == "Attack":
		get_tree().change_scene_to(garden_scene)
	elif option == "Back":
		emit_signal("flee_from_fight")
	elif option == "Stats":
		active_submenu = SUBMENUS.STATS
		item_list.clear()
		item_list.add_item("Placeholder stat")
		set_focus_on_attacks()
