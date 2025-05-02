extends Resource

class_name EnemyData

@export_category("Model")
@export var model: PackedScene

@export_category("Attributes")
@export var health: int
@export var move_speed: float = 5.0
@export var damage: int
@export var attack_range: float
@export var attack_speed: float = 1.0
