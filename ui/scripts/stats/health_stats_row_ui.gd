extends StatsRowBase

func _process(delta: float) -> void:
	if player:
		amount_label.text = str(player.data.current_health)
