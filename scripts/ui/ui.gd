extends CanvasLayer

@onready var death_menu: Control = $DeathScreen
@onready var pause_menu: Control = $PauseMenu
@onready var ingame_overlay: Control = $IngameOverlay
var health_bar: ProgressBar

var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	health_bar = ingame_overlay.get_node("ProgressBar")
	health_bar.max_value = player.data.health
	health_bar.value = player.data.health

func _process(_delta: float):
	match GameManager.active_game_state:
		GameManager.DEATH:
			death_menu.visible = true
			pause_menu.visible = false
			ingame_overlay.visible = false
		GameManager.PAUSE:
			death_menu.visible = false
			pause_menu.visible = true
			ingame_overlay.visible = false
		GameManager.FIGHTING:
			death_menu.visible = false
			pause_menu.visible = false
			ingame_overlay.visible = true
			
			health_bar.value = player.data.health

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
