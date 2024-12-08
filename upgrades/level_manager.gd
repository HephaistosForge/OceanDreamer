extends Node

enum GameState { PLAYING, UPGRADING, DEAD }

signal to_next_level(level: int, upgrade: Upgrade)
signal to_upgrade_screen(upgrades: Array[Upgrade])
signal remaining_progress(count: int, total: int)
signal game_over

@export var upgrade_count = 3

@onready var upgrades = Upgrades.new()

var level = 1
var total_monsters = 1
var remaining_monsters = total_monsters
var game_state = GameState.PLAYING


func _ready():
	remaining_progress.emit(remaining_monsters, total_monsters)


func get_random_upgrades():
	var next_upgrades = []
	for i in upgrade_count:
		var upgrade
		while true:
			upgrade = upgrades.random(level)
			if upgrade not in next_upgrades:
				break
		next_upgrades.append(upgrade)
	return next_upgrades

func _on_monster_death(monster):
	update_remaining_monsters(remaining_monsters - monster.xp)
	
func on_player_death(_player):
	game_state = GameState.DEAD
	game_over.emit()
	
	
func update_remaining_monsters(new_value):
	remaining_monsters = clamp(new_value, 0, total_monsters)
	remaining_progress.emit(remaining_monsters, total_monsters)
	if remaining_monsters <= 0:
		transition_to_upgrade_screen()
		
func transition_to_upgrade_screen():
	if game_state == GameState.PLAYING:
		game_state = GameState.UPGRADING
		to_upgrade_screen.emit(get_random_upgrades())
		
func transition_to_next_level(upgrade: Upgrade):
	if game_state == GameState.UPGRADING:
		game_state = GameState.PLAYING
		level += 1
		update_remaining_monsters(total_monsters)
		to_next_level.emit(level, upgrade)
		upgrade.assert_all_keys_were_used()
		Audio.play("level_up")
		Audio.background_music_choice = 0
		Audio._on_background_music_finished()
