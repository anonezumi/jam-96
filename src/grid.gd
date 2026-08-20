extends TileMapLayer

const HEX_WIDTH = 120.0
const HALF_WIDTH = HEX_WIDTH / 2.0
const SHORT_EDGE = 34
const HEX_HEIGHT = 140.0 - SHORT_EDGE
const SLOPE = SHORT_EDGE / HALF_WIDTH
const VERT_OFFSET = 64
const LENGTH = HEX_HEIGHT - SHORT_EDGE
const HEX_OFFSETS: PackedVector2Array = [
	Vector2(0, LENGTH),
	Vector2(HALF_WIDTH, LENGTH/2.0),
	Vector2(HALF_WIDTH, -LENGTH/2.0),
	Vector2(0, -LENGTH),
	Vector2(-HALF_WIDTH, -LENGTH/2.0),
	Vector2(-HALF_WIDTH, LENGTH/2.0)
]
var tiles = []
var astar = AStar2D.new()

class Tile:
	var coords: Vector2i = Vector2i(-1, -1)
	var walkable: bool = false
	var placeable: bool = false
	var has_enemy: bool = false
	var tower = null
	var id: int = -1
	var center: Vector2 = Vector2(-1, -1)

func coords_to_id(x: int, y: int):
	return (x << 8) + y

func init_tile(x: int, y: int) -> Tile:
	var tile = Tile.new()
	tile.coords = Vector2i(x, y)
	tile.walkable = get_cell_tile_data(Vector2(x, y)).get_custom_data("walkable")
	tile.placeable = get_cell_tile_data(Vector2(x, y)).get_custom_data("placeable")
	tile.id = coords_to_id(x, y)
	if y % 2 == 1:
		tile.center = Vector2(x * HEX_WIDTH  + HEX_WIDTH,
					   y * HEX_HEIGHT + VERT_OFFSET) + position
	else:
		tile.center = Vector2(x * HEX_WIDTH  + HALF_WIDTH,
					   y * HEX_HEIGHT + VERT_OFFSET) + position
	return tile

func _ready() -> void:
	for x in range(18):
		tiles.append([])
		for y in range(12):
			var tile = init_tile(x, y)
			tiles[x].append(tile)
			if tile.walkable:
				astar.add_point(tile.id, tile.center)
				if y % 2 == 0:
					for id in [coords_to_id(x-1, y-1), coords_to_id(x, y-1), coords_to_id(x-1, y), coords_to_id(x-1, y+1)]:
						if astar.has_point(id):
							astar.connect_points(id, tile.id)
				else:
					for id in [coords_to_id(x, y-1), coords_to_id(x-1, y)]:
						if astar.has_point(id):
							astar.connect_points(id, tile.id)
			else:
				var collider = preload("res://scenes/cell_collider.tscn").instantiate()
				add_child(collider)
				collider.global_position = tile.center

func _process(_delta: float) -> void:
	# optimize this somehow
	for a in tiles:
		for t in a:
			t.has_enemy = false
	if get_node_or_null(^"/root/MainGame/Enemies") == null:
		return
	for enemy in $"/root/MainGame/Enemies".get_children():
		tile_at_position(enemy.global_position).has_enemy = true

func place_tower(tower: PackedScene, price: int):
	var tile = tile_at_position(get_viewport().get_mouse_position())
	if not tile.placeable:
		if tile.tower == null:
			return
		SignalBus.change_possessed.emit(tile.tower)
		return
	if tile.has_enemy: return
	if Global.money < price: return
	var tower_inst = tower.instantiate()
	$"..".add_child(tower_inst)
	tower_inst.position = tile.center + tower_inst.offset
	tile.placeable = false
	tile.tower = tower_inst
	Global.change_money.emit(-price)
	astar.remove_point(tile.id)
	SignalBus.pathfind_recalculate.emit()

func find_path(from_coords: Vector2i, to_coords: Vector2i) -> PackedVector2Array:
	return astar.get_point_path(
		coords_to_id(from_coords.x, from_coords.y), 
		coords_to_id(to_coords.x, to_coords.y))

func tile_at_position(pos: Vector2) -> Tile: # shameless hex grid code from stackoverflow
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
		
		if len(tiles) > column and len(tiles[0]) > row:
			return tiles[column][row]
		return null
