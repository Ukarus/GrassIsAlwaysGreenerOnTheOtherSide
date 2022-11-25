extends Node


onready var attack_ui = $CanvasLayer/AttackUI
onready var character = $Character
onready var houses_node = $Houses
onready var currency_label = $CanvasLayer/VandalCurrencyLabel
onready var shop_list = $CanvasLayer/ShopList
onready var shop_items = PlayerGlobalData.shop_items
const houseNode = preload("res://Scenes/House.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	shop_list.hide()
	attack_ui.hide()
	attack_ui.connect("flee_from_fight", self, "go_back_to_map")
	character.position = PlayerGlobalData.player_neighbour_pos
	currency_label.text = "Vandal Currency: ${t}".format({"t": PlayerGlobalData.vandal_currency})
	var houses = Neighbourgood.houses
	
	for h in houses:
		var new_house = houseNode.instance()
		new_house.load_data(h)
		houses_node.add_child(new_house)
		new_house.position = h.local_position
		new_house.connect("on_house_entered", self, "_on_HouseDetectRadius_body_entered")
	
	for i in shop_items:
		shop_list.add_item("{name} x1 ${price}".format({"name": i.item_name, "price": i.price}))
	shop_list.add_item("Back")
	
func _process(_delta):
	PlayerGlobalData.player_neighbour_pos = character.position
	currency_label.text = "Vandal Currency: ${t}".format({"t": PlayerGlobalData.vandal_currency})

func go_back_to_map():
	attack_ui.hide()
	character.allow_movement()

func _on_HouseDetectRadius_body_entered(house):
	Neighbourgood.set_current_house(house.houseName)
	character.stop_movement()
	character.go_to_idle()
	attack_ui.set_house_label()
	attack_ui.load_options()
	attack_ui.show()
	attack_ui.set_focus_on_attacks()


func _on_ShopArea_body_entered(_body):
	shop_list.show()
	character.stop_movement()
	character.go_to_idle()
	shop_list.grab_focus()
	shop_list.select(0)

func _on_ShopList_item_activated(index):
	var option = shop_list.get_item_text(index)
	if option == "Back":
		shop_list.hide()
		character.allow_movement()
	# if we select an item to buy
	else:
		PlayerGlobalData.buy_item(PlayerGlobalData.shop_items[index].item_name, 1)
