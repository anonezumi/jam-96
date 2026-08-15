extends Control

# painstakingly found parameters
const HEX_WIDTH = 60.0
const HALF_WIDTH = HEX_WIDTH / 2.0
const SHORT_EDGE = 17.0
const HEX_HEIGHT = 70.0 - SHORT_EDGE
const SLOPE = SHORT_EDGE / HALF_WIDTH

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		$"../TileMap".erase_cell(get_hex_coords(get_viewport().get_mouse_position()))


func get_hex_coords(pos: Vector2) -> Vector2i: # shameless hex grid code from stackoverflow
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
