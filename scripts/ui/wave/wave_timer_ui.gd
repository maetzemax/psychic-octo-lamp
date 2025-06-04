extends Label

func _process(_delta: float):
	if WaveService:
		text = str(max(0, WaveService.current_wave_time))
