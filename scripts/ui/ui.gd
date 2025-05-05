extends CanvasLayer

@onready var death_menu: Control = $DeathScreen

@onready var pause_menu: Control = $PauseMenu

func _process(delta: float):
	match GameManager.active_game_state:
		GameManager.DEATH:
			death_menu.visible = true
			pause_menu.visible = false
		GameManager.PAUSE:
			death_menu.visible = false
			pause_menu.visible = true
		_:
			death_menu.visible = false
			pause_menu.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				GameManager.active_game_state = GameManager.PAUSE

func _on_try_again_pressed() -> void:
	GameManager.active_game_state = GameManager.FIGHTING
	get_tree().reload_current_scene()

func _on_return_pressed() -> void:
	GameManager.active_game_state = GameManager.FIGHTING
