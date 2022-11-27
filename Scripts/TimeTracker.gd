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
var attacks_alerts = []

signal neighbour_attacked_player
	
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
		# Simulate attacks to player here just for testing
		if current_time == day_time.MORNING:
			current_time = day_time.AFTERNOON
			#simulate_attacks_to_player()
		elif current_time == day_time.AFTERNOON:
			current_time = day_time.NIGHT
			#simulate_attacks_to_player()
	print(get_current_time())
	
	
func next_day():
	# Day has passed, calculate houses attack
	current_day += 1
	var attacks_today = 0
	var max_attacks_day = 2
	
	# Fix broken objects in neighbours houses
	fix_objects()
	
	# TODO: Check if player house != null
	var player_house = Neighbourgood.get_player_house()
	var attacks_alerts = []
	# Attacks to player
	print("houses: "+str(Neighbourgood.houses.size()))
	simulate_attacks_to_player()
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

func reset_attack_alerts():
	attacks_alerts = []

func fix_objects():
	for house in Neighbourgood.houses:
		print(house.owner_name)
		# Skip Player house
		if house.is_player_house:
			continue
		else:
			# Find broken object
			for object in house.house_objects:
				print(object.object_name)
				if object.object_state == Neighbourgood.ObjectState.DESTROYED:
					object.days_broken += 1
					if object.days_broken == object.days_to_recover:
						object.object_state == Neighbourgood.ObjectState.NORMAL
						object.days_broken = 0
	pass

func simulate_attacks_to_player():
	var attacks_today = 0
	var max_attacks_day = 2
	# TODO: Check if player house != null
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
			attacks_alerts.append({
				"neighbour_name": house.owner_name,
				"dmg": str(house.owner_power)
			})
			print(house.owner_name + " has attacked your house for "+ str(house.owner_power) + " damage.")
#	if attacks_alerts.size() > 0:
#		print('attacking player')
#		emit_signal("neighbour_attacked_player")
