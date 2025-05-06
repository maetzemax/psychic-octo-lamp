extends Resource

class_name EnemyData

@export_category("Model")
@export var model: PackedScene

@export_category("Base")
@export var health: int

@export_category("Movement")
@export var move_type: MOVEMENT.TYPE
@export var move_speed: float = 5.0

@export_category("Attack")
@export var attack_type: ATTACK.TYPE
@export var attack_damage: int
@export var attack_range: float
@export var attack_speed: float = 1.0
@export var projectile_speed: float = 30
