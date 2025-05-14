extends Node

class_name MaterialService

static var count: int = 0

static func add_material(amount: int):
	count += amount

static func reduce_material(amount: int):
	count = max(count - amount, 0)

static func reset():
	count = 0
