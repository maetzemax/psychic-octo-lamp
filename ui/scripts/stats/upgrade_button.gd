extends Button

@onready var player = get_tree().get_first_node_in_group("Player")
@export var attribute: PlayerData.ATTRIBUTES

var _current_price: int = 5

func _ready():
	pressed.connect(_on_upgrade_pressed)

func _process(_delta: float):
	disabled = MaterialService.get_materials() < _current_price
	tooltip_text = "Item price: " + str(_current_price)

func _on_upgrade_pressed():
	if not player:
		return
	
	match attribute:
		PlayerData.ATTRIBUTES.HEALTH:
			player.data.health += 1
		PlayerData.ATTRIBUTES.ARMOR:
			player.data.armor += 1
		PlayerData.ATTRIBUTES.DAMAGE:
			player.data.damage += 0.01
		PlayerData.ATTRIBUTES.ATTACK_SPEED:
			player.data.attack_speed += 0.01
		PlayerData.ATTRIBUTES.ATTACK_RANGE:
			player.data.attack_range += 0.01
		PlayerData.ATTRIBUTES.MOVEMENT_SPEED:
			player.data.movement_speed += 0.01

	MaterialService.reduce_materials(_current_price)
	_current_price += 5
