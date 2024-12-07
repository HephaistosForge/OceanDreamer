extends Node2D

@export var tile_size = Vector2(10240, 10240)  # Size of a single background tile
@export var tiles: Array[Sprite2D] = []

@onready var ship = get_tree().get_first_node_in_group("ship")


func _process(delta):
	for tile in tiles:
		var tile_position = tile.global_position
		var ship_position = ship.global_position

		# Reposition horizontally
		if ship_position.x <= tile_position.x - tile_size.x:
			tile.global_position.x -= 2 * tile_size.x
		elif ship_position.x > tile_position.x + tile_size.x:
			tile.global_position.x += 2 * tile_size.x

		# Reposition vertically
		if ship_position.y <= tile_position.y - tile_size.y:
			tile.global_position.y -= 2 * tile_size.y
		elif ship_position.y > tile_position.y + tile_size.y:
			tile.global_position.y += 2 * tile_size.y
