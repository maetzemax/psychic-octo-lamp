extends Button

@export var stat: StatsManager.STAT

var _current_price = 5

func _ready():
	_resolve_current_price()
	StatsManager.price_update.connect(_resolve_current_price)
	pressed.connect(_on_upgrade_pressed)

func _on_upgrade_pressed():
	StatsManager.on_stat_upgrade.emit(stat)

func _resolve_current_price():
	_current_price = StatsManager.resolve_current_price(stat)
	
	disabled = MaterialService.get_materials() < _current_price
	tooltip_text = "Item price: " + str(_current_price)
