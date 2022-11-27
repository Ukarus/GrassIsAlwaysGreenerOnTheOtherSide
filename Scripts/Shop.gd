extends StaticBody2D

signal on_shopArea_entered


func _on_ShopArea_body_entered(body):
	emit_signal("on_shopArea_entered", body)
