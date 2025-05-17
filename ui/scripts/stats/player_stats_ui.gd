extends Control

var player: CharacterBody2D

@onready var _material_label: Label = $MarginContainer/VBoxContainer/Material/HBoxContainer/Amount
@onready var _health_label: Label = $MarginContainer/VBoxContainer/Health/HBoxContainer/Amount
@onready var _armor_label: Label = $MarginContainer/VBoxContainer/Armor/HBoxContainer/Amount
@onready var _move_speed_label: Label = $MarginContainer/VBoxContainer/MovementSpeed/HBoxContainer/Amount
@onready var _attack_damage_label: Label = $MarginContainer/VBoxContainer/AttackDamage/HBoxContainer/Amount

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	if player:
		_material_label.text = str(MaterialService.get_materials())
		_health_label.text = str(player.data.current_health)
		_armor_label.text = str(player.data.armor)
		_attack_damage_label.text = str(player.data.damage)
		_move_speed_label.text = str(int(player.data.movement_speed) * 100) + " %"
