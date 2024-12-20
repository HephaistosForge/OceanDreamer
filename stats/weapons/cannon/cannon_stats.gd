extends WeaponStats
class_name CannonStats

@export_group("Cannon")

@export var turn_speed = ""
@export var size = ""
@export var clip_delay = ""
@export var intra_clip_delay = ""

@export var burst_count = ""
@export var spray_count = ""

@export var modulate = Color(1, 1, 1, 0)

@export_group("Cannonball")

@export var shot_velocity = ""
@export var shot_damage = ""
@export var shot_knockback = ""
@export var shot_size = ""
@export var shot_range = ""

@export var shot_bounce_count = ""
@export var shot_pierce_count = ""
@export var shot_fragmentate_count = ""

@export var shot_homingness = ""
@export var shot_explosiveness = ""
@export var shot_wiggleness = ""
@export var shot_mutativeness = ""

@export var shot_modulate: Color = Color(1, 1, 1, 0)

func dps() -> float:
	var damage_per_click = shot_damage * spray_count * (shot_pierce_count + shot_bounce_count + 1) \
		+ shot_fragmentate_count * shot_damage/4 
	var average_reload = (clip_delay + (burst_count - 1) * intra_clip_delay) / burst_count
	return damage_per_click / average_reload
	
