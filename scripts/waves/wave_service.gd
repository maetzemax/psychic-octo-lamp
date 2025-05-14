extends Node

class_name WaveService

var current_wave = 1
static var current_wave_time: int = 30

@export var max_waves: int = 20
@export_range(1, 2, 0.01) var scaling: float = 1.02
@export var waves: Array[WaveData]

var active_wave: WaveData
var _wave_time: int = 30

var timer: TimerHelper = TimerHelper.new()

func _ready():
	active_wave = waves[randi_range(0, waves.size() - 1)]
	timer.wait_time = _wave_time
	timer.timeout.connect(_on_cooldown_timer_timeout)
	timer.autostart = true
	add_child(timer)
	
func _process(delta: float) -> void:
	current_wave_time = int(timer.time_left)
	
func start_wave():
	active_wave = waves[randi_range(0, waves.size() - 1)]
	var enemies = active_wave.enemies.duplicate().all(scale)
	active_wave.enemies = enemies
	current_wave += 1
	timer.wait_time = _wave_time
	timer.start()
	GameManager.active_game_state = GameManager.FIGHTING
	
func scale(enemy: EnemyData):
	enemy.attack_damage *= scaling
	enemy.health *= scaling
	
func _on_cooldown_timer_timeout():
	scaling += 0.1
	_wave_time += 3
	GameManager.active_game_state = GameManager.ROUND_END
