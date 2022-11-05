extends Control


var attacks = [
	"Kick gnomes",
	"Burn Pine",
	"Flee"
]
onready var item_list = $ItemList

signal flee_from_fight

# Called when the node enters the scene tree for the first time.
func _ready():
	for a in attacks:
		item_list.add_item(a)
	item_list.grab_focus()
	item_list.select(0)

func set_focus_on_attacks():
	item_list.grab_focus()

# TODO: Check for amount of attacks that can be done
# TODO: Transition to vandalic action
func _on_ItemList_item_activated(index):
	var attack = attacks[index]
	if attack == "Flee":
		emit_signal("flee_from_fight")
	else:
		
		$Bar/TextureProgress.value -= 1
	pass # Replace with function body.
