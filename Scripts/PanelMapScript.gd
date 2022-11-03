extends Panel



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var can_be_clicked = false
signal house_selected


func _on_Panel_gui_input(event):
	if can_be_clicked and event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		emit_signal("house_selected")

