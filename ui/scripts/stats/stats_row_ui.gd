extends PanelContainer

class_name StatsRowBase

@onready var player: CharacterBody2D
@onready var material_service: MaterialService
@onready var amount_label: Label

@export var icon: CompressedTexture2D
@export var label_text: String

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	amount_label = get_node("HBoxContainer/Amount")
	material_service = get_node("/root/MaterialService")
	$HBoxContainer/TextureRect .texture = icon
	$HBoxContainer/Label.text = label_text
