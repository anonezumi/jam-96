extends CharacterBody2D

@export var target: Vector2i
@export var speed = 300.0
@onready var tilemap = $"/root/MainGame/TileMap"
var path: PackedVector2Array
var stopped = false
const TOLERANCE = 5
var dbg = false
var my_tile

func _ready() -> void:
	SignalBus.pathfind_recalculate.connect(find_path)
	find_path()

func find_path():
	my_tile = tilemap.tile_at_position(global_position)
	path = tilemap.find_path(my_tile.coords, target).duplicate()
	if not path:
		stopped = true
		print("no path sad")

func _physics_process(delta: float) -> void:
	if stopped or dbg:
		return
	my_tile = tilemap.tile_at_position(global_position)
	if my_tile.center == path[0]:
		path.remove_at(0)
		if not path:
			stopped = true
			return
	
	velocity = global_position.direction_to(path[0]) * speed
	
	move_and_slide()

func _draw() -> void:
	if dbg:
		if len(path) == 1:
			draw_circle(global_position, 10, Color.ORANGE, false)
			return
		var rect_path = path.duplicate()
		for i in len(rect_path):
			rect_path[i] = rect_path[i] - position
		draw_polyline(rect_path, Color.ORANGE)
