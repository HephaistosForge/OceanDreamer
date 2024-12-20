extends Node2D
class_name Weapon

var stats: WeaponStats : set = set_stats

func set_stats(new_stats: WeaponStats):
	stats = new_stats
	self.scale = Vector2.ONE * stats.size
