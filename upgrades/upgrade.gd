class_name Upgrade

var upgrade: Dictionary

var default_icon = preload("res://assets/icons/default.svg")
var used_keys = {"name": 0, "tier": 0}

func _init(upgrade: Dictionary):
	self.upgrade = upgrade
	
func of(key: String) -> Variant:
	used_keys[key] = 0
	var value = upgrade.get(key)
	if value == null:
		if key.begins_with("factor_"):
			return 1
		if key.begins_with("delta_"):
			return 0
	return value
	
func icon() -> Texture2D:
	var icon = of("icon")
	if icon == null:
		return default_icon
	return load(icon)
	
func has(key: String) -> bool:
	return upgrade.has(key)
	
func get_color() -> Color:
	var c = of("color")
	if c == null:
		return Color.WHITE
	return Color(c[0], c[1], c[2], c[3])
	
func fma(suffix: String, val: float):
	if of("set_" + suffix) != null:
		return of("set_" + suffix)
	return val * of("factor_" + suffix) + of("delta_" + suffix)
	
func assert_all_keys_were_used():
	for key in upgrade:
		if upgrade[key] != null:
			assert(key in used_keys, "key " + key + " was never used")
