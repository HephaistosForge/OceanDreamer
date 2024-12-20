extends Control

const UPGRADE_ITEM = preload("res://ui_scenes/ingame_ui/upgrade_item.tscn")

func _ready():
	get_tree().get_first_node_in_group("level_manager").to_next_level.connect(_on_next_level)
	
func _on_next_level(level, upgrade):
	queue_free()

func show_and_pick_upgrades(curr_stats, upgrades):
	for upgrade in upgrades:
		var item = UPGRADE_ITEM.instantiate()
		$Panel/MarginContainer/UpgradesList.add_child(item)
		item.set_upgrade.call_deferred(curr_stats, upgrade)
