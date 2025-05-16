extends Node

signal materials_changed(new_count: int)

var _materials: int = 0

func get_materials() -> int:
	return _materials

func add_materials(amount: int) -> void:
	if amount <= 0:
		return
	_materials += amount
	materials_changed.emit(_materials)

func reduce_materials(amount: int) -> bool:
	if amount <= 0 or amount > _materials:
		return false
	_materials = max(_materials - amount, 0) 
	materials_changed.emit(_materials)
	return true

func reset() -> void:
	_materials = 0
	materials_changed.emit(_materials)
