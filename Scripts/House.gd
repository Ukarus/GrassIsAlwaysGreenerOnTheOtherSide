extends StaticBody2D

export (int) var max_beauty_points = 100
export (String) var ownerName = "John"
export (String) var houseName = "House1"
export (PackedScene) var garden_scene 

var current_beauty_points : int = 30
var is_player_house : bool = false
# List of the current objects the house has
var objects = []

signal on_house_entered

func _on_HouseDetectRadius_body_entered(_body):
	# send information about the current house
	emit_signal("on_house_entered", self)

func decrease_beauty_points(points: int):
	current_beauty_points -= points

func load_data(houseData):
	ownerName = houseData.owner_name
	current_beauty_points = houseData.current_beauty_points
	houseName = houseData.houseName
	is_player_house = houseData.is_player_house
