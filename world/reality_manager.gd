extends Node2D

@onready var ship = get_tree().get_first_node_in_group("ship")
@onready var camera = get_tree().get_first_node_in_group("camera")

func _ready():
	$Bathtub.modulate = Color(1, 1, 1, 0)

func _on_level_manager_to_next_level(level: int, upgrade: Stats) -> void:
	transition(false)


func _on_level_manager_to_upgrade_screen(stats, upgrades) -> void:
	transition(true)
	
	
func transition(to_reality: bool):
	#ship.disabled = not to_reality
	var factor = 1/2.5 if to_reality else 2.5
	var camera_offset = Vector2(-700 if to_reality else 0, 0)
	var target_color = Color.WHITE if to_reality else Color(1, 1, 1, 0)
	$Bathtub.global_position = ship.global_position
	$Bathtub/FakeShip.ship = ship if to_reality else null
	
	if to_reality:
		handle_cannons(to_reality)
	
	#ship.global_position = $Bathtub/HandJoint.global_position
	
	var tween = create_tween()
	tween.tween_property(camera, "zoom", camera.zoom * factor, 1) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($Bathtub, "modulate", target_color, 1) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(camera, "offset", camera_offset, 1) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(ship, "scale", ship.scale / factor, 1) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		
	if not to_reality:
		tween.tween_callback(handle_cannons.bind(to_reality))
	 
func handle_cannons(to_reality):
	for cannon in get_tree().get_nodes_in_group("cannon"):
		cannon.can_shoot = not to_reality
	
