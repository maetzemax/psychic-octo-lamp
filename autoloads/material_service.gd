extends Node

signal materials_changed(new_count: int)

var count: int = 0

func add_materials(amount: int) -> void:
	if amount <= 0:
		return
	count += amount
	materials_changed.emit(count)

func reduce_materials(amount: int) -> bool:
	if amount <= 0 or amount > count:
		return false
	count = max(count - amount, 0) 
	materials_changed.emit(count)
	return true

func reset() -> void:
	count = 0
	materials_changed.emit(count)
