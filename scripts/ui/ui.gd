extends CanvasLayer

@onready var death_menu: Control = $DeathScreen

func _process(delta: float):
	match GameManager.active_game_state:
		GameManager.DEATH:
			death_menu.visible = true
		_:
			death_menu.visible = false


func _on_try_again_pressed() -> void:
	GameManager.active_game_state = GameManager.FIGHTING
	get_tree().reload_current_scene()
