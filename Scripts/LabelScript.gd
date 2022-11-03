extends Label


var can_be_clicked = false
signal house_selected


func _on_Label_mouse_entered():
	can_be_clicked = true


func _on_Label_mouse_exited():
	can_be_clicked = false


func _on_Label_gui_input(event):
	if can_be_clicked and event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		emit_signal("house_selected", {
			"house": "House 1",
			"health": "70"
		})
