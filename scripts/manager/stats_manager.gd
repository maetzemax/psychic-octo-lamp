extends Node

enum STAT { HEALTH, ARMOR, DAMAGE, ATTACK_SPEED, ATTACK_RANGE, MOVEMENT_SPEED }

signal stat_upgrade(stat: STAT)
signal price_update

var player

func _ready() -> void:
	stat_upgrade.connect(_stat_upgrade)

func _stat_upgrade(stat: STAT):
	player = get_tree().get_first_node_in_group("Player")
	
	if not player:
		push_error("NO PLAYER")
		
	MaterialService.reduce_materials(resolve_current_price(stat))
	
	match stat:
		STAT.HEALTH:
			player.data.health += 1
			player.data.health_price += 5
		STAT.ARMOR:
			player.data.armor += 1
			player.data.armor_price += 5
		STAT.DAMAGE:
			player.data.damage += 0.01
			player.data.damage_price += 5
		STAT.ATTACK_SPEED:
			player.data.attack_speed += 0.01
			player.data.attack_speed_price += 5
		STAT.ATTACK_RANGE:
			player.data.attack_range += 0.01
			player.data.attack_range_price += 5
		STAT.MOVEMENT_SPEED:
			player.data.movement_speed += 0.01
			player.data.movement_speed_price += 5

	price_update.emit()

func resolve_current_price(stat: STAT) -> int:
	player = get_tree().get_first_node_in_group("Player")
	
	if not player:
		push_error("NO PLAYER")

	match stat:
		STAT.HEALTH:
			return player.data.health_price
		STAT.ARMOR:
			return player.data.armor_price
		STAT.DAMAGE:
			return player.data.damage_price
		STAT.ATTACK_SPEED:
			return player.data.attack_speed_price
		STAT.ATTACK_RANGE:
			return player.data.attack_range_price
		STAT.MOVEMENT_SPEED:
			return player.data.movement_speed_price
		_:
			return 0
