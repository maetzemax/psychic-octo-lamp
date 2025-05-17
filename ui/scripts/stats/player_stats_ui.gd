extends Control

@export var is_round_end: bool = false

var player: CharacterBody2D

@onready var _material_label: Label = $MarginContainer/VBoxContainer/Material/Panel/HBoxContainer/Amount
@onready var _health_label: Label = $MarginContainer/VBoxContainer/Health/Panel/HBoxContainer/Amount
@onready var _armor_label: Label = $MarginContainer/VBoxContainer/Armor/Panel/HBoxContainer/Amount
@onready var _attack_damage_label: Label = $MarginContainer/VBoxContainer/AttackDamage/Panel/HBoxContainer/Amount
@onready var _attack_speed_label: Label = $MarginContainer/VBoxContainer/AttackSpeed/Panel/HBoxContainer/Amount
@onready var _attack_range_label: Label = $MarginContainer/VBoxContainer/AttackRange/Panel/HBoxContainer/Amount
@onready var _move_speed_label: Label = $MarginContainer/VBoxContainer/MovementSpeed/Panel/HBoxContainer/Amount

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	if player:
		_material_label.text = str(MaterialService.get_materials())
		_health_label.text = str(player.data.current_health)
		_armor_label.text = str(player.data.armor)
		_attack_damage_label.text = str(player.data.damage)
		_attack_speed_label.text = str(int(player.data.attack_speed) * 100) + " %"
		_attack_range_label.text = str(int(player.data.attack_range) * 100) + " %"
		_move_speed_label.text = str(int(player.data.movement_speed) * 100) + " %"
	
	if !is_round_end:
		get_tree().call_group_flags(
			SceneTree.GROUP_CALL_DEFERRED | SceneTree.GROUP_CALL_REVERSE,
			"UpgradeButton", "hide"
		)
	else:
		get_tree().call_group_flags(
			SceneTree.GROUP_CALL_DEFERRED | SceneTree.GROUP_CALL_REVERSE,
			"UpgradeButton", "show"
		)
