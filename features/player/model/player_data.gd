extends Resource

class_name PlayerData

enum ATTRIBUTES { HEALTH, ARMOR, DAMAGE, ATTACK_SPEED, ATTACK_RANGE, MOVEMENT_SPEED}

@export var health: int = 20
var current_health: int
@export var armor: int = 0

@export var damage: float = 1.00
@export var attack_speed: float = 1.00
@export var attack_range: float = 1.00

@export var movement_speed: float = 1.0
