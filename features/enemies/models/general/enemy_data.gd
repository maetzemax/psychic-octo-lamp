extends Resource

class_name EnemyData

@export_category("Model")
@export var model: PackedScene

@export_category("Base")
@export var health: int = 10

@export_category("Movement")
@export var movement_type: MOVEMENT.TYPE = MOVEMENT.FOLLOW
@export var movement_speed: float = 1.0

@export_category("Attack")
@export var attack_ability: ATTACK.ABILITY = ATTACK.DEFAULT_MELEE
@export var attack_damage: int = 10
@export var attack_speed: float = 1.0
