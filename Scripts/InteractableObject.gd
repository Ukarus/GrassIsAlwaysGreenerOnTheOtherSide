extends StaticBody2D

export (int) var points = 3
export (int) var resistance = 1


signal poup_points

func destroy_object():
	$FCTManager.show_value(points)
	$AnimationPlayer.play("die")

func damage():
	resistance -= 1
	$AnimationPlayer.play("dmg")
	if resistance <= 0:
		destroy_object()
		
