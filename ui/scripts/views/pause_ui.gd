extends Panel

@onready var wave_service: WaveService

func _on_continue_pressed() -> void:
	wave_service.start_wave()
