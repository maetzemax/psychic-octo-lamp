extends Node2D

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		MaterialService.add_material(1)
		queue_free()
