extends Node


signal to_next_level(level: int, upgrade: Upgrade)
signal to_upgrade_screen(upgrades)
signal remaining_progress(count: int, total: int)

@export var upgrade_count = 3

@onready var upgrades = Upgrades.new()

var level = 1
var total_monsters = 1
var remaining_monsters = total_monsters

func _ready():
	remaining_progress.emit(remaining_monsters, total_monsters)


func get_random_upgrades():
	var next_upgrades = []
	for i in upgrade_count:
		next_upgrades.append(upgrades.random())
	return next_upgrades

func _on_monster_death():
	update_remaining_monsters(remaining_monsters - 1)
	
func update_remaining_monsters(new_value):
	remaining_monsters = clamp(new_value, 0, total_monsters)
	remaining_progress.emit(remaining_monsters, total_monsters)
	if remaining_monsters <= 0:
		transition_to_upgrade_screen()
		
func transition_to_upgrade_screen():
	to_upgrade_screen.emit(get_random_upgrades())
		
func transition_to_next_level(upgrade: Upgrade):
	level += 1
	update_remaining_monsters(total_monsters)
	to_next_level.emit(level, upgrade)
