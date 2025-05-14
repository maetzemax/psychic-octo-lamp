extends Node

class_name WaveService

var current_wave: int  = 1
var current_wave_time: int = 0

@export var waves: Array[WaveData]
var active_wave: WaveData

var timer: TimerHelper

func _ready():
	start_wave()

func _process(delta: float):
	if timer:
		current_wave_time = int(timer.time_left)
	
func start_wave():
	active_wave = waves[current_wave - 1]
	setup_timer()
	GameManager.active_game_state = GameManager.FIGHTING

func reset():
	current_wave = 1

func _on_cooldown_timer_timeout():
	current_wave += 1
	GameManager.active_game_state = GameManager.ROUND_END

func setup_timer():
	timer = TimerHelper.new()
	timer.wait_time = active_wave.wave_time
	timer.timeout.connect(_on_cooldown_timer_timeout)
	timer.autostart = true
	add_child(timer)
