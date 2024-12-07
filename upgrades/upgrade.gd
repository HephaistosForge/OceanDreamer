class_name Upgrade

var upgrade: Dictionary

var default_icon = preload("res://assets/icons/default.svg")

func _init(upgrade: Dictionary):
	self.upgrade = upgrade
	
func of(key: String) -> Variant:
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
	
func as_fma(suffix: String):
	return func(val): val * of("factor_" + suffix) + of("delta_" + suffix)
