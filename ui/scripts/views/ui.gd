extends CanvasLayer

@export var active_ui_scene: PackedScene
@export var paused_ui_scene: PackedScene

@export var wave_service: WaveService
@export var wave_end_ui_scene: PackedScene

func _ready():
	_on_game_state_changed(GameManager.ACTIVE)
	GameManager.on_active_game_state_changed.connect(_on_game_state_changed)

func _on_game_state_changed(state: GameManager.GAMESTATE):
	_remove_node_children()
	
	match state:
		GameManager.ACTIVE:
			var active_ui: Control = active_ui_scene.instantiate()
			add_child(active_ui)
		GameManager.PAUSED:
			var paused_ui: Control = paused_ui_scene.instantiate()
			add_child(paused_ui)
		GameManager.DIED:
			pass
		GameManager.WAVE_END:
			var wave_end_ui: Control = wave_end_ui_scene.instantiate()
			wave_end_ui.wave_service = wave_service
			add_child(wave_end_ui)

func _remove_node_children():
	for child in get_children():
		child.queue_free()
