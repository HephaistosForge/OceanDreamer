extends CanvasLayer

var UPGRADE_DIALOG_SCENE = preload("res://ui_scenes/ingame_ui/upgrade_dialog.tscn")

func _ready():
	var ship = get_tree().get_first_node_in_group("ship")
	ship.hp_changed.connect(_on_hp_changed)
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.to_upgrade_screen.connect(_on_level_manager_to_upgrade_screen)
	level_manager.to_next_level.connect(_on_level_manager_to_next_level)
	level_manager.remaining_progress.connect(_on_level_manager_remaining_progress)
	
func _on_hp_changed(new_value, old_value, max_value):
	find_child("HP").text = str(new_value) + " HP"
	var bar = find_child("HpBar")
	var tween = create_tween()
	tween.parallel().tween_property(bar, "value", new_value, 0.1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	bar.max_value = max_value
	
func _on_level_manager_to_next_level(level, _upgrade):
	find_child("Level").text = "Level " + str(level)

func _on_level_manager_remaining_progress(count: Variant, total: Variant) -> void:
	var label = $CenterContainer/Top/HBoxContainer/EnemyKillCountRequirementLabel
	label.text = str(count) + "/" + str(total)


func _on_level_manager_to_upgrade_screen(upgrades) -> void:
	var dialog = UPGRADE_DIALOG_SCENE.instantiate()
	dialog.show_and_pick_upgrades(upgrades)
	$CenterContainer/Expander/HBoxContainer/LeftHalf.add_child(dialog)
