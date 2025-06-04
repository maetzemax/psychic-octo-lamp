extends Panel

func _on_continue_pressed() -> void:
	GameManager.set_active_game(GameManager.ACTIVE)
