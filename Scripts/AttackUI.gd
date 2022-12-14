extends Control

export (PackedScene) var garden_scene

var options = [
	"Attack",
	"Back"
]
const REPAIR_OPTIONS = [
	"Repair 5%",
	"Repair 10%",
	"Repair 20%"
]
const PRICE_REPAIR = [
	5,
	10,
	20
]

var player_options = [
	"Repair",
	"Back"
]
onready var item_list = $VSplitContainer/ItemList
onready var house_label = $VSplitContainer/Label
onready var house_bar = $VSplitContainer/PopularityBar
onready var repair_control = $RepairControl
onready var repair_list = $RepairControl/RepairList
#onready var audio_stream = $AudioStreamPlayer
enum SUBMENUS {OPTIONS, ATTACK, STATS}
var active_submenu = SUBMENUS.OPTIONS
var sound_class = preload("res://Scripts/Singletons/SoundManager.gd")
var sound_manager = null

signal flee_from_fight

# Called when the node enters the scene tree for the first time.
func _ready():
	load_options()
	set_focus_on_attacks()
	sound_manager = sound_class.new()
	sound_manager.audio_stream = $AudioStreamPlayer
	
	
func set_house_label():
	var current_house = Neighbourgood.current_house
	house_label.text = current_house.houseName
	house_bar.value = current_house.current_beauty_points
	house_bar.max_value = 100 

func set_focus_on_attacks():
	repair_control.hide()
	item_list.show()
	item_list.grab_focus()
	item_list.select(1)

func load_options():
	var current_house = Neighbourgood.current_house
	
	if current_house != null and current_house.is_player_house:
		item_list.clear()
		for o in player_options:
			item_list.add_item(o)
	else:
		item_list.clear()
		add_options()
		

func add_options():
	for a in options:
		item_list.add_item(a)
				

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if active_submenu == SUBMENUS.ATTACK or active_submenu == SUBMENUS.STATS:
			active_submenu = SUBMENUS.OPTIONS
			item_list.clear()
			load_options()
			set_focus_on_attacks()
		elif active_submenu == SUBMENUS.OPTIONS:
			emit_signal("flee_from_fight")
			
func _on_ItemList_item_activated(index):
	var option = item_list.get_item_text(index)
	sound_manager.play_sound('click1')
	
	if option == "Attack":
		get_tree().change_scene_to(Neighbourgood.current_house.garden_scene)
	elif option == "Back":
		emit_signal("flee_from_fight")
	elif option == "Repair":
		item_list.hide()
		repair_control.show()
		repair_list.clear()
		for o in REPAIR_OPTIONS:
			repair_list.add_item(o)
		repair_list.add_item("Back")
		repair_list.grab_focus()
		repair_list.select(0)


func _on_RepairList_item_activated(index):
	var option = repair_list.get_item_text(index)
	if option == "Back":
		emit_signal("flee_from_fight")
	else:
		var price_to_repair = PRICE_REPAIR[index]
		var currency = PlayerGlobalData.vandal_currency
		if currency - price_to_repair > 0:
			Neighbourgood.player_house.repair_house(price_to_repair)
			house_bar.value = Neighbourgood.player_house.current_beauty_points
			PlayerGlobalData.reduce_vandal_currency(price_to_repair)


func _on_RepairList_item_selected(_index):
	sound_manager.play_sound('rollover')


func _on_ItemList_item_selected(_index):
	sound_manager.play_sound('rollover')
