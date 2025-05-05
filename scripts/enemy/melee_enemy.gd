extends Enemy

var attack_indicator: MeshInstance2D = MeshInstance2D.new()
var indicator_target_radius := 0.0
var indicator_current_radius := 0.0
const SCALE_SPEED := 6.0

func _ready():
	super._ready()
	_reset_attack_indicator()
	add_child(attack_indicator)

func _process(delta):
	if is_attacking:
		indicator_current_radius = lerp(indicator_current_radius, indicator_target_radius, delta * SCALE_SPEED)
		_update_attack_indicator_mesh(indicator_current_radius)

func _start_attack():
	super._start_attack()
	attack_indicator.visible = true
	indicator_target_radius = attack_range
	indicator_current_radius = 0.0
	_update_attack_indicator_mesh(0.0)

func _update_attack_indicator_mesh(radius: float):
	var circle_mesh = SphereMesh.new()
	# -1 == half player size
	circle_mesh.radius = radius - 16
	circle_mesh.height = (radius - 16) * 2.0
	attack_indicator.mesh = circle_mesh

func _reset_attack_indicator():
	attack_indicator.visible = false
	attack_indicator.modulate = Color("8a8a8a66")
	attack_indicator.show_behind_parent = true
	indicator_current_radius = 0.0
	indicator_target_radius = 0.0
	_update_attack_indicator_mesh(0.0)
	
func _perform_attack():
	if player and position.distance_to(player.global_position) < attack_range:
		player.reduce_health(data.attack_damage)
	is_attacking = false
	_reset_attack_indicator()
