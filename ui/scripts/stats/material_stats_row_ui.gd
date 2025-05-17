extends StatsRowBase

func _process(delta: float) -> void:
	if material_service:
		amount_label.text = str(material_service.get_materials())
