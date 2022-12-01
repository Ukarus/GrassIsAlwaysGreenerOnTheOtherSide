extends Control

onready var text_label = $TutorialPanel/TextLabel
onready var button = $TutorialPanel/Button
onready var img_panel = $ImagePanel
export (Array, Dictionary) var dialogue = [] 
var dialogue_index = 0
var current_dialogue: Dictionary = {}

signal tutorial_done

func _ready():
	img_panel.hide()

func show_dialogue():
#	get_focus_owner()
	current_dialogue = dialogue[dialogue_index]
	if current_dialogue["image"] == null:
		img_panel.hide()
	else:
		img_panel.show()
		img_panel.get_node("TextureRect").texture = current_dialogue["image"]
	text_label.text = current_dialogue["text"]

func next_dialogue():
	if dialogue_index + 1 > dialogue.size() - 1:
		emit_signal("tutorial_done")
		return
	else:
		dialogue_index = dialogue_index + 1
		show_dialogue()

func _on_Button_button_up():
	next_dialogue()
