extends PanelContainer

@onready var icon: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var label: Label = $MarginContainer/HBoxContainer/Label

var upgrade

func _ready() -> void:
	pass

func set_upgrade(new_upgrade: Upgrade):
	upgrade = new_upgrade
	icon.texture = upgrade.icon()
	label.text = upgrade.of("description")

func _on_mouse_click(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().get_first_node_in_group("level_manager").transition_to_next_level(upgrade)
		
