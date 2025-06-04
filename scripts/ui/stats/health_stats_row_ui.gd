extends StatsRowBase

func _process(_delta: float) -> void:
	if player:
		amount_label.text = str(player.data.current_health)
