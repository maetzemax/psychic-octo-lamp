extends Node2D

class_name EnemyAttackService

var player: CharacterBody2D

var enemy: Enemy
var attack_range: float
var target_pos: Vector2

func _init(enemy: Enemy):
	self.enemy = enemy
	attack_range = enemy.data.attack_range * 10

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
func resolve_attack(type: ATTACK.TYPE):
	if not player or not enemy:
		return

	match type:
		ATTACK.DEFAULT:
			pass
		ATTACK.ZICK_ZACK:
			pass
		ATTACK.DASH:
			pass
		ATTACK.CHARGE:
			pass
		ATTACK.BURST:
			pass
		ATTACK.STAR:
			pass
