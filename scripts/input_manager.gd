extends Node

signal movement_input_changed(direction: Vector2)

var _up: bool
var _down: bool
var _left: bool
var _right: bool

func _input(_event: InputEvent):
	_up = Input.is_action_pressed("walk_up")
	_down = Input.is_action_pressed("walk_down")
	_left = Input.is_action_pressed("walk_left")
	_right = Input.is_action_pressed("walk_right")
	
	var direction = Vector2(
		(_right as float) - (_left as float),
		(_down as float) - (_up as float)
	)
	
	movement_input_changed.emit(direction)
