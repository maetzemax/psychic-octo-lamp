extends Node

enum GAMESTATE { MAIN_MENU = 0, FIGHTING = 1, PAUSE = 2, DEATH = 3, ROUND_END = 4 }

const MAIN_MENU = 0
const FIGHTING = 1
const PAUSE = 2
const DEATH = 3
const ROUND_END = 4

static var active_game_state: GAMESTATE = FIGHTING

func _unhandled_input(event: InputEvent):
	if event:
		match GameManager.active_game_state:
			GameManager.FIGHTING:
				if Input.is_action_just_pressed("ui_cancel"):
					GameManager.active_game_state = GameManager.PAUSE
			GameManager.PAUSE:
				if Input.is_action_just_pressed("ui_cancel"):
					GameManager.active_game_state = GameManager.FIGHTING
					
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
