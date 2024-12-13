extends Resource
class_name Upgrade

@export var description: String = ""
@export var tier: int = 0
@export var icon_path: String = "res://assets/icons/default.svg"

# Ship
@export var delta_hp: int = 0
@export var factor_hp: float = 1

@export var delta_ship_size: int = 0
@export var factor_ship_size: float = 1

@export var delta_movement_speed: int = 0
@export var factor_movement_speed: float = 1

@export var delta_max_speed: int = 0
@export var factor_max_speed: float = 1

@export var delta_rotation_speed: int = 0
@export var factor_rotation_speed: float = 1

# Cannon
@export var delta_cannon_rotation_speed: int = 0
@export var factor_cannon_rotation_speed: float = 1

@export var delta_cannon_shooting_delay: int = 0
@export var factor_cannon_shooting_delay: float = 1

@export var delta_cannon_size: int = 0
@export var factor_cannon_size: float = 1

@export var delta_cannon_velocity: int = 0
@export var factor_cannon_velocity: float = 1

# Cannonball
@export var delta_cannon_ball_damage: int = 0
@export var factor_cannon_ball_damage: float = 1

# Cannonball - Not implemented
@export var delta_cannon_ball_knockback: int = 0
@export var factor_cannon_ball_knockback: float = 1

@export var delta_cannon_ball_size: int = 0
@export var factor_cannon_ball_size: float = 1

@export var delta_cannon_ball_flight_range: int = 0
@export var factor_cannon_ball_flight_range: float = 1

# Cannonball effects
@export var delta_cannon_ball_burst_count: int = 0
@export var delta_cannon_ball_spray_count: int = 0
@export var cannon_ball_modulate: Array[float] = [1.0, 1.0, 1.0, 0.0]
@export var delta_cannon_ball_fragmentate_count: int = 0
@export var delta_cannon_ball_bounce_count: int = 0
@export var delta_cannon_ball_pierce_count: int = 0

# Cannonball effects - Not implemented
@export var homing: int = 0
@export var explosive: int = 0
@export var wiggle: int = 0
@export var mutate: int = 0

# Ship Effects - Not implemented
@export var cannon_can_rotate: int = 0
@export var ship_can_move: int = 0
@export var can_cloak: int = 0
@export var shield_count: int = 0
@export var shield_hp: int = 0
@export var shield_duration: int = 0
@export var upgrade_selection_count: int = 0


func icon() -> Texture2D:
	return load(self.icon_path)


func get_color() -> Color:
	var c: Array[float] = self.cannon_ball_modulate
	return Color(c[0], c[1], c[2], c[3])


func fma(value, current_value):
	if value is float:
		return current_value * value
	if value is int:
		return current_value + value
	return current_value
