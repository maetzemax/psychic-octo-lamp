extends Node

class_name WaveService

@onready var spawner = $Spawner

var current_wave: int  = 1
static var current_wave_time: int = 0

@export var waves: Array[WaveData]
var active_wave: WaveData

var timer: TimerHelper

func _ready():
	start_wave()

func _process(_delta: float):
	if timer:
		current_wave_time = int(timer.time_left)
	
func start_wave():
	if current_wave - 1 == waves.size():
		# TODO: Fix ending
		GameManager.set_active_game(GameManager.DIED)
		return
	active_wave = waves[current_wave - 1]
	setup_timer()
	spawner.setup_timer()
	GameManager.set_active_game(GameManager.ACTIVE)

func reset():
	current_wave = 1

func _on_cooldown_timer_timeout():
	current_wave += 1
	GameManager.set_active_game(GameManager.WAVE_END)

func setup_timer():
	timer = TimerHelper.new()
	timer.wait_time = active_wave.wave_time
	timer.timeout.connect(_on_cooldown_timer_timeout)
	timer.autostart = true
	add_child(timer)
