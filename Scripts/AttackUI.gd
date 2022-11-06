extends Control


var attacks = [
	"Kick gnomes",
	"Burn Pine"
]
var options = [
	"Vandal Attack",
	"Stats",
	"Back"
]
onready var item_list = $VSplitContainer/ItemList
enum SUBMENUS {OPTIONS, ATTACK, STATS}
var active_submenu = SUBMENUS.OPTIONS

signal flee_from_fight

# Called when the node enters the scene tree for the first time.
func _ready():
	add_options()
	set_focus_on_attacks()

func set_focus_on_attacks():
	item_list.grab_focus()
	item_list.select(0)
	
func add_attacks():
	for a in attacks:
		item_list.add_item(a)

func add_options():
	for a in options:
		item_list.add_item(a)
				

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if active_submenu == SUBMENUS.ATTACK or active_submenu == SUBMENUS.STATS:
			active_submenu = SUBMENUS.OPTIONS
			item_list.clear()
			add_options()
			set_focus_on_attacks()
		elif active_submenu == SUBMENUS.OPTIONS:
			emit_signal("flee_from_fight")
			
# TODO: Check for amount of attacks that can be done
func _on_ItemList_item_activated(index):
	var option = item_list.get_item_text(index)
	print(option)
	if option == "Vandal Attack":
		active_submenu = SUBMENUS.ATTACK
		item_list.clear()
		add_attacks()
		set_focus_on_attacks()
	elif option == "Back":
		emit_signal("flee_from_fight")
	elif option == "Stats":
		active_submenu = SUBMENUS.STATS
		item_list.clear()
		item_list.add_item("Placeholder stat")
		set_focus_on_attacks()
		print("showing stats")
	else:
		print("attacking")
#		$Bar/TextureProgress.value -= 1
