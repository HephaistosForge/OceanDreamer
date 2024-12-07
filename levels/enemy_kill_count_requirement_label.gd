extends Label

@export var enemy_kill_count_requirement = 5


func _ready() -> void:
	self.add_to_group("enemy_kill_count_requirement_label")
	update_text(enemy_kill_count_requirement)


func update_text(new_enemy_kill_count_requirement: int) -> void:
	self.text = str(new_enemy_kill_count_requirement)
