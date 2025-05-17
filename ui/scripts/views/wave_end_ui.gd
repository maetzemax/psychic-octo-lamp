extends Panel

@onready var player: CharacterBody2D
@onready var wave_service: WaveService

func _on_continue_pressed():
	wave_service.start_wave()
