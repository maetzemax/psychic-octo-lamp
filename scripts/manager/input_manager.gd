extends Node

signal movement_input_changed(direction: Vector2)

var animation_player: AnimationPlayer

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
	
	if _left:
		animation_player.play("walk_left")
	elif _right:
		animation_player.play("walk_right")
	elif _up or _down:
		animation_player.play("walk_right")

func _unhandled_input(event: InputEvent):
	if event:
		match GameManager.active_game_state:
			GameManager.ACTIVE:
				if Input.is_action_just_pressed("ui_cancel"):
					GameManager.set_active_game(GameManager.PAUSED)
			GameManager.PAUSED:
				if Input.is_action_just_pressed("ui_cancel"):
					GameManager.set_active_game(GameManager.ACTIVE)
					
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
