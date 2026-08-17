extends CharacterBody2D

@export var target: Vector2i
@export var speed = 300.0
@onready var tilemap = $"/root/MainGame/TileMap"
var path: PackedVector2Array
var stopped = false
const TOLERANCE = 1

func _ready() -> void:
	path = tilemap.find_path(tilemap.get_hex_coords(self.global_position), target).duplicate()

func _physics_process(delta: float) -> void:
	if stopped:
		return
	if global_position.distance_to(path[0]) <= TOLERANCE:
		path.remove_at(0)
		if not path:
			stopped = true
			return

	velocity = global_position.direction_to(path[0]) * speed

	move_and_slide()
