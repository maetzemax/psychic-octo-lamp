extends Button

@onready var player = get_tree().get_first_node_in_group("Player")
@export var attribute: PlayerData.ATTRIBUTES

var _current_price = 5

func _ready():
	pressed.connect(_on_upgrade_pressed)

func _process(_delta: float):
	_resolve_current_price()

func _on_upgrade_pressed():
	if not player:
		return
	
	match attribute:
		PlayerData.ATTRIBUTES.HEALTH:
			player.data.health += 1
			player.data.health_price += 5
		PlayerData.ATTRIBUTES.ARMOR:
			player.data.armor += 1
			player.data.armor_price += 5
		PlayerData.ATTRIBUTES.DAMAGE:
			player.data.damage += 0.01
			player.data.damage_price += 5
		PlayerData.ATTRIBUTES.ATTACK_SPEED:
			player.data.attack_speed += 0.01
			player.data.attack_speed_price += 5
		PlayerData.ATTRIBUTES.ATTACK_RANGE:
			player.data.attack_range += 0.01
			player.data.attack_range_price += 5
		PlayerData.ATTRIBUTES.MOVEMENT_SPEED:
			player.data.movement_speed += 0.01
			player.data.movement_speed_price += 5

	MaterialService.reduce_materials(_current_price)

func _resolve_current_price():
	match attribute:
		PlayerData.ATTRIBUTES.HEALTH:
			_current_price = player.data.health_price
		PlayerData.ATTRIBUTES.ARMOR:
			_current_price = player.data.armor_price
		PlayerData.ATTRIBUTES.DAMAGE:
			_current_price = player.data.damage_price
		PlayerData.ATTRIBUTES.ATTACK_SPEED:
			_current_price = player.data.attack_speed_price
		PlayerData.ATTRIBUTES.ATTACK_RANGE:
			_current_price = player.data.attack_range_price
		PlayerData.ATTRIBUTES.MOVEMENT_SPEED:
			_current_price = player.data.movement_speed_price
			
	disabled = MaterialService.get_materials() < _current_price
	tooltip_text = "Item price: " + str(_current_price)
