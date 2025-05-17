extends StatsRowBase

func _process(_delta: float) -> void:
	if material_service:
		amount_label.text = str(material_service.get_materials())
