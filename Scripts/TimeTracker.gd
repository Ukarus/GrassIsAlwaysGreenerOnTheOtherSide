extends Node

## Time system definition
var rng = RandomNumberGenerator.new()

enum day_time {MORNING,AFTERNOON,NIGHT}
var max_days = 30
var current_day = 1
var day_actions = 3
var current_time = day_time.MORNING

var min_anger_attack = 25
var rng_attack_threshold = 50
	
func _init():
	#debug 
	#current_time = day_time.NIGHT
	print(get_current_time())
	
func get_current_time():
	return day_time.keys()[current_time]
	
func get_days_to_contest():
	return max_days - current_day

func end_turn():
	if current_time == day_time.NIGHT:
		next_day()
		if current_day > max_days:
			# TODO: Game Over
			pass
		else:
			current_time = day_time.MORNING
	else:
		if current_time == day_time.MORNING:
			current_time = day_time.AFTERNOON
		elif current_time == day_time.AFTERNOON:
			current_time = day_time.NIGHT
	print(get_current_time())
	
	
func next_day():
	# Day has passed, calculate houses attack
	current_day += 1
	var attacks_today = 0
	var max_attacks_day = 2
	var player_house = Neighbourgood.get_player_house()
	# Attacks to player
	print("houses: "+str(Neighbourgood.houses.size()))
	for house in Neighbourgood.houses:
		# Exit if player house
		if house.is_player_house:
			continue
		rng.randomize()
		var anger_threshold = rng.randi_range(min_anger_attack,100)
		# Check attack threshold
		if house.owner_anger >= anger_threshold  && attacks_today < max_attacks_day:
			# Attack player
			player_house.current_beauty_points -= house.owner_power
			house.update_anger(-25)
			attacks_today += 1
			print(house.owner_name + " has attacked your house for "+ str(house.owner_power) + " damage.")
	# Attacks between neighbours
	for house in Neighbourgood.houses:
		rng.randomize()
		var objective = Neighbourgood.houses[rng.randi() % Neighbourgood.houses.size()]
		if objective.houseName == house.houseName || house.is_player_house || objective.is_player_house:
			continue
		else:
			# random for attack
			rng.randomize()
			var rand = rng.randi_range(0,100)
			if rand > rng_attack_threshold:
				#Attack random object
				var target_object = objective.house_objects[rng.randi() % objective.house_objects.size() ]
				target_object.destroy()
				objective.update_house_points(0)
				#objective.current_beauty_points -= house.owner_power
				print(house.owner_name + " has attacked " + objective.owner_name +"'s house and destroyed one "+ target_object.object_name)
	# Restore beauty points
	#for house in Neighbourgood.houses:
	#	if house.is_player_house:
	#		continue
	#	house.increase_beauty_points(house.restore_power)
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

