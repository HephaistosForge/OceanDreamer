extends Resource
class_name Stats

const SKIP_PROPERTIES = ["name", "upgrades_directory"]

# ===============================================================
# Public
# ===============================================================

func eval():
	for property in _get_property_names_to_upgrade():
		set(property, _eval_curr_value(property))
		print(get(property))

func merge(other: Stats) -> void:
	if other == null:
		return
	for property in _get_property_names_to_upgrade():
		var before = _eval_curr_value(property)
		var after = _eval_formula(other.get(property), before) 
		set(property, after)
		print("property ", property, ": ", before, " -> ", after)
	
func merged(other: Stats) -> Stats:
	var duplicated = duplicate(true)
	duplicated.merge(other)
	return duplicated

func changes_on_upgrade(upgrade: Stats, filter_unchanged=true): 
	var new = merged(upgrade)
	var diff = {}
	for property in _get_property_names_to_upgrade():
		var curr = _eval_curr_value(property)
		var next = new._eval_curr_value(property)
		if curr is Stats:
			diff[property] = curr.changes_on_upgrade(upgrade.get(property))
		else:
			if not filter_unchanged or curr != next:
				diff[property] = [curr, next]
	return diff

# ===============================================================
# Private
# ===============================================================

func _get_property_names_to_upgrade() -> Array[String]:
	var names: Array[String] = []
	for property in get_property_list():
		if property["name"] in SKIP_PROPERTIES:
			continue
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			names.append(property["name"])
	return names
	
func _eval_float(formula, x):	
	if x == null:
		x = 0.0
	if formula == "" or formula == null:
		return x
	var expression = Expression.new()
	expression.parse(formula, ["x"])
	print(formula, " x: ", x)
	return expression.execute([x])
	
func _eval_color(new, previous) -> Color:
	if new is Color and previous is Color:
		return previous.blend(new)
	if new is Color:
		return new
	if previous is Color:
		return previous
	return Color.WHITE
	
func _eval_formula(formula, value):
	if value is Stats:
		return value.merged(formula)
	if formula is Stats:
		return formula
	if value is Color or formula is Color:
		return _eval_color(formula, value)
	return _eval_float(formula, value)
	
func _eval_curr_value(property: String):
	var value = get(property)
	if value is Stats:
		value.eval()
	if value is String:
		return _eval_formula(value, 0.0)
	return value
