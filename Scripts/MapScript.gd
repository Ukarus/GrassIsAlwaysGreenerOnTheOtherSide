extends Node2D


func _ready():
	$Panel/House1Sprite/Label.connect("house_selected", self, "go_to_house")


func go_to_house(house):
	print(house)
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://Scenes/VandalismUI.tscn")
