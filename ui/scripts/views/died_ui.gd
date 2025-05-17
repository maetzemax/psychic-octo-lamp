extends Panel


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	GameManager.set_active_game(GameManager.ACTIVE)
