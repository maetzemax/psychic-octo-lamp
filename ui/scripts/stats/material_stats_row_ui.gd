extends StatsRowBase

func _ready():
	super._ready()
	if material_service:
		amount_label.text = str(material_service.get_materials())
		material_service.materials_changed.connect(_on_material_changed)

func _on_material_changed(newCount: int):
	amount_label.text = str(newCount)
