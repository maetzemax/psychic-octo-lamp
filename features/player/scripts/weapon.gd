extends Node2D

class_name Weapon

const LAYER_WORLD = 1 << 0
const LAYER_ENEMY_MELEE = 1 << 2
const LAYER_ENEMY_RANGED = 1 << 3

@export var data: WeaponData

@onready var player: CharacterBody2D

var attack_cooldown := false
var attack_timer: TimerHelper = TimerHelper.new()
var enemy_detection: EnemyDetection

func _ready():
	player = get_parent()
	attack_timer.wait_time = 1.0 / (data.attack_speed * player.data.attack_speed) 
	attack_timer.timeout.connect(_on_attack_timeout)
	add_child(attack_timer)
	enemy_detection = EnemyDetection.new(self)
	
func _physics_process(_delta: float):
	var nearest_enemy = enemy_detection.get_nearest_enemy()
	if nearest_enemy:
		attack(nearest_enemy.global_position)

func attack(target_position: Vector2):
	if attack_cooldown:
		return

	_perform_ranged_attack(target_position)

	attack_cooldown = true
	attack_timer.start()

func _on_attack_timeout():
	attack_cooldown = false

func _perform_ranged_attack(target_position: Vector2):
	var projectile_scene = preload("res://features/projectile/scenes/projectile.tscn")
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.direction = (target_position - global_position).normalized()
	projectile.projectile_speed = data.projectile_speed
	projectile.attack_damage = data.attack_damage
	projectile.collision_mask = LAYER_ENEMY_MELEE | LAYER_ENEMY_RANGED | LAYER_WORLD
	projectile.collision_layer = 32
	get_tree().current_scene.add_child(projectile)
