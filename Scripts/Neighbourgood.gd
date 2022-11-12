extends Node

class HouseClass:
	var name = ""
	var current_beauty_points = 0

var houses : Array = []
var current_house = null

func add_house(house):
	var new_house = HouseClass.new()
	new_house.name = house.houseName
	new_house.current_beauty_points = house.current_beauty_points
	houses.append(new_house)
	
func update_current_house_points(new_points: int):
	if current_house == null:
		return
	for h in houses:
		if h.name == current_house.name:
			h.current_beauty_points = new_points
	current_house.current_beauty_points = new_points
	
func set_current_house(house_name: String):
	for h in houses:
		if h.name == house_name:
			current_house = h
			break
