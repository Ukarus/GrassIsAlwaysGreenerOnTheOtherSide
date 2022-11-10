extends StaticBody2D


signal on_house_entered

func _on_HouseDetectRadius_body_entered(body):
	emit_signal("on_house_entered", body)
