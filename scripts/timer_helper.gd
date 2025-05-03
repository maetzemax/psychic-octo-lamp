extends Node

class_name TimerHelper

signal timeout

@export var wait_time: float = 1.0
@export var autostart: bool = false
@export var one_shot: bool = true

var _timer: Timer

func _ready():
	_timer = Timer.new()
	_timer.wait_time = wait_time
	_timer.one_shot = one_shot
	_timer.timeout.connect(_on_timeout)
	add_child(_timer)

	if autostart:
		start()

func start():
	_timer.start()

func stop():
	_timer.stop()

func _on_timeout():
	emit_signal("timeout")
