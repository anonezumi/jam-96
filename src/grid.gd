extends TileMapLayer

const HEX_WIDTH = 60.0
const HALF_WIDTH = HEX_WIDTH / 2.0
const SHORT_EDGE = 17.0
const HEX_HEIGHT = 70.0 - SHORT_EDGE
const SLOPE = SHORT_EDGE / HALF_WIDTH
const VERT_OFFSET = 20
var walkable_tiles = []
var astar = AStar2D.new()

func _ready() -> void:
	SignalBus.tower_placed.connect(_on_tower_placed)
	for x in range(35):
		walkable_tiles.append([])
		for y in range(24):
			var walkable = get_cell_tile_data(Vector2(x, y)).get_custom_data("walkable")
			walkable_tiles[x].append(walkable)
			if walkable:
				astar.add_point(coords_to_id(x, y), get_center_of_hex(Vector2i(x, y)))
				if y % 2 == 0:
					for id in [coords_to_id(x-1, y-1), coords_to_id(x, y-1), coords_to_id(x-1, y)]:
						if astar.has_point(id):
							astar.connect_points(id, coords_to_id(x, y))
				else:
					for id in [coords_to_id(x+1, y-1), coords_to_id(x, y-1), coords_to_id(x-1, y)]:
						if astar.has_point(id):
							astar.connect_points(id, coords_to_id(x, y))
			else:
				var collider = preload("res://scenes/cell_collider.tscn").instantiate()
				add_child(collider)
				collider.global_position = get_center_of_hex(Vector2i(x, y))

func _on_tower_placed(coords: Vector2i):
	astar.remove_point(coords_to_id(coords.x, coords.y))
	SignalBus.pathfind_recalculate.emit()

func find_path(from_coords: Vector2i, to_coords: Vector2i) -> PackedVector2Array:
	return astar.get_point_path(
		coords_to_id(from_coords.x, from_coords.y), 
		coords_to_id(to_coords.x, to_coords.y))

func coords_to_id(x: int, y: int):
	return (x << 8) + y

func get_center_of_hex(coords: Vector2i) -> Vector2:
	if coords.y % 2 == 1:
		return Vector2(coords.x * HEX_WIDTH  + HEX_WIDTH,
					   coords.y * HEX_HEIGHT + VERT_OFFSET) + position
	else:
		return Vector2(coords.x * HEX_WIDTH  + HALF_WIDTH,
					   coords.y * HEX_HEIGHT + VERT_OFFSET) + position

func get_hex_coords(pos: Vector2) -> Vector2i: # shameless hex grid code from stackoverflow
		pos -= position
		var row = floori(pos.y / HEX_HEIGHT)
		var column
		
		# odd rows are offset by a half width
		if row % 2 == 1:
			column = floor((pos.x - HALF_WIDTH) / HEX_WIDTH)
		else:
			column = floor(pos.x / HEX_WIDTH)
		
		# obtain positions relative to the rectangle grid
		var relY = pos.y - (HEX_HEIGHT * row)
		var relX = pos.x - (HEX_WIDTH * column)
		
		# undo what we did
		if row % 2 == 1:
			relX -= HALF_WIDTH
		
		if relY < (-SLOPE * relX) + SHORT_EDGE: # above the left edge
			row -= 1
			if row % 2 == 1:
				column -= 1
		
		if relY < (SLOPE * relX) - SHORT_EDGE: # above the right edge
			row -= 1
			if row % 2 == 0:
				column += 1
		
		return Vector2i(column, row)
