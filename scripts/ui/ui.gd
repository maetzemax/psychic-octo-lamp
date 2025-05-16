extends CanvasLayer

@export var wave_service: WaveService

@onready var death_menu: Control = $DeathScreen
@onready var pause_menu: Control = $PauseMenu

@onready var ingame_overlay: Control = $IngameOverlay
var health_label: Label
var material_label: Label
var wave_label: Label
var wave_time_label: Label

@onready var round_end_menu: Control = $RoundEndScreen

var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	health_label = ingame_overlay.get_node("VBoxContainer/Health")
	material_label = ingame_overlay.get_node("VBoxContainer/Material")
	wave_label = ingame_overlay.get_node("Wave")
	wave_time_label = ingame_overlay.get_node("WaveTime")

func _process(_delta: float):	
	match GameManager.active_game_state:
		GameManager.DEATH:
			death_menu.visible = true
			pause_menu.visible = false
			ingame_overlay.visible = false
			round_end_menu.visible = false
		GameManager.PAUSE:
			death_menu.visible = false
			pause_menu.visible = true
			ingame_overlay.visible = false
			round_end_menu.visible = false
			pause_menu.get_node("VBoxContainer/Return").grab_focus()
		GameManager.ROUND_END:
			death_menu.visible = false
			pause_menu.visible = false
			ingame_overlay.visible = false
			round_end_menu.visible = true
			round_end_menu.get_node("NextRound").grab_focus()
		GameManager.FIGHTING:
			death_menu.visible = false
			pause_menu.visible = false
			ingame_overlay.visible = true
			round_end_menu.visible = false
			
			if player:
				health_label.text = "HEALTH: " + str(player.data.health)
			
			if MaterialService.count:
				material_label.text = "MATERIAL: " + str(MaterialService.count)
			
			if wave_service:
				wave_label.text = "WAVE: " + str(wave_service.current_wave)
				wave_time_label.text = str(wave_service.current_wave_time)

func _on_try_again_pressed() -> void:
	GameManager.active_game_state = GameManager.FIGHTING
	MaterialService.reset()
	wave_service.reset()
	get_tree().reload_current_scene()

func _on_return_pressed() -> void:
	GameManager.active_game_state = GameManager.FIGHTING

func _on_next_round_pressed() -> void:
	wave_service.start_wave()
