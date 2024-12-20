extends Control

@onready var icon: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var dps_label: Label = $MarginContainer/HBoxContainer/DPS

var upgrade

func _ready() -> void:
	pass

func set_upgrade(curr_stats: Stats, new_upgrade: Stats):
	upgrade = new_upgrade
	# icon.texture = upgrade.icon()
	label.text = upgrade.name
	var curr_dps = curr_stats.weapon.dps()
	var new_dps = curr_stats.merged(new_upgrade).weapon.dps()
	var increase = new_dps / curr_dps * 100 - 100
	var sign = "+" if increase > 0 else ""
	dps_label.text = sign + str(int(increase)) + "% DPS"
	dps_label.modulate = Color.GREEN if increase > 0 else Color.RED

func _on_mouse_click(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		Audio.play("button_select")
		get_tree().get_first_node_in_group("level_manager").transition_to_next_level(upgrade)

func _on_mouse_entered() -> void:
	Audio.play("button_hover")
