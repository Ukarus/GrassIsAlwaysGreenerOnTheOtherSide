extends Node


onready var attack_ui = $CanvasLayer/AttackUI
onready var character = $Character
onready var houses_node = $Houses
onready var currency_label = $CanvasLayer/VandalCurrencyLabel
onready var shop_list = $CanvasLayer/ShopList
onready var day_label = $CanvasLayer/TimeDateContainer/DayLabel
onready var daytime_label = $CanvasLayer/TimeDateContainer/DayTimeLabel
onready var shop_items = PlayerGlobalData.shop_items
onready var inventory_menu = $CanvasLayer/MenuContainer/PlayerItemsList
onready var menu_container = $CanvasLayer/MenuContainer
onready var popup_container = $CanvasLayer/AlertPanel
const houseNode = preload("res://Scenes/House.tscn")
enum UI_OPTIONS {ATTACK_UI, SHOP_LIST, MENU, NONE}
var current_ui = UI_OPTIONS.NONE


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	popup_container.hide()
	shop_list.hide()
	attack_ui.hide()
	menu_container.hide()
	attack_ui.connect("flee_from_fight", self, "go_back_to_map")
	character.position = PlayerGlobalData.player_neighbour_pos
	currency_label.text = "Vandal Currency: ${t}".format({"t": PlayerGlobalData.vandal_currency})
	if Neighbourgood.houses.size() == 0:
		Neighbourgood.load_houses($Houses.get_children())

	for h in houses_node.get_children():
		h.connect("on_house_entered", self, "_on_HouseDetectRadius_body_entered")	
	
	for i in shop_items:
		shop_list.add_item("{name} x1 ${price}".format({"name": i.item_name, "price": i.price}))
	shop_list.add_item("Back")
	$Shop.connect("on_shopArea_entered", self, "_on_ShopArea_body_entered")
	load_inventory_menu()
	if TimeTracker.attacks_alerts.size() > 0:
		_on_Attack_Alert()
			
func load_inventory_menu():
	inventory_menu.clear()
	var inventory = PlayerGlobalData.inventory
	for i in inventory:
		var item_option = "{name} x{qty}".format({"name": i.item_name, "qty": i.durability})
		if !i.has_durability:
			item_option = "{name} ".format({"name": i.item_name})
		inventory_menu.add_item(item_option)
	inventory_menu.add_item("Back")
	
# Update daytime labels and filter
func update_time_ui():
	day_label.text = "Days Left: %d" % TimeTracker.get_days_to_contest()
	daytime_label.text = TimeTracker.get_current_time()
#	night_filter.color = filter_color[TimeTracker.current_time]
	
func _process(_delta):
	PlayerGlobalData.player_neighbour_pos = character.position
	currency_label.text = "Vandal Currency: ${t}".format({"t": PlayerGlobalData.vandal_currency})
	update_time_ui()
	if (Input.is_action_just_pressed("ui_cancel") and (current_ui == UI_OPTIONS.NONE)):
		current_ui = UI_OPTIONS.MENU
		menu_container.show()
		inventory_menu.grab_focus()
		inventory_menu.select(0)
		character.stop_movement()
		character.go_to_idle()

func go_back_to_map():
	if current_ui == UI_OPTIONS.ATTACK_UI:
		current_ui = UI_OPTIONS.NONE
		attack_ui.hide()
		character.allow_movement()

func _on_HouseDetectRadius_body_entered(house):
	current_ui = UI_OPTIONS.ATTACK_UI
	Neighbourgood.set_current_house(house.houseName)
	character.stop_movement()
	character.go_to_idle()
	attack_ui.set_house_label()
	attack_ui.load_options()
	attack_ui.show()
	attack_ui.set_focus_on_attacks()

func _on_ShopArea_body_entered(_body):
	current_ui = UI_OPTIONS.SHOP_LIST
	shop_list.show()
	character.stop_movement()
	character.go_to_idle()
	shop_list.grab_focus()
	shop_list.select(0)

func _on_Attack_Alert():
	var attack_data = TimeTracker.attacks_alerts
	popup_container.show()
	popup_container.get_node("OkButton").grab_focus()
	var alert_string = ""
	for alert in attack_data:
		alert_string += "{on} has attacked your house for {op} damage\n".format({
		"on": alert["neighbour_name"],
		"op": alert["dmg"]
	})
	popup_container.get_node("AlertLabel").text = alert_string
	TimeTracker.reset_attack_alerts()

func _on_ShopList_item_activated(index):
	var option = shop_list.get_item_text(index)
	if option == "Back":
		shop_list.hide()
		character.allow_movement()
		current_ui = UI_OPTIONS.NONE
	# if we select an item to buy
	else:
		print(current_ui)
		PlayerGlobalData.buy_item(PlayerGlobalData.shop_items[index].item_name, 1)
		load_inventory_menu()


func _on_PlayerItemsList_item_activated(index):
	var option = inventory_menu.get_item_text(index)
	if option == "Back":
		menu_container.hide()
		character.allow_movement()
		current_ui = UI_OPTIONS.NONE

func _on_Button_button_up():
	popup_container.hide()


func _on_OkButton_button_up():
	popup_container.hide()
