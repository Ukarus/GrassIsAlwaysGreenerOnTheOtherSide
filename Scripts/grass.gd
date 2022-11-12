extends StaticBody2D

export (int) var points = 1
export (int) var resistance = 3


signal poup_points

func destroy_object():
	$FCTManager.show_value(points)
	$AnimationPlayer.play("die")

func damage():
	print (resistance)
	resistance -= 1
	$AnimationPlayer.play("dmg") #y objeto es lanzallamas
	if resistance <= 0:
		destroy_object()
		
