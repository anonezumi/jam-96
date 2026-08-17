extends Node

@export var enemies: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_timer_timeout() -> void:
	# should prolly have a more sophisticated enemy choosing algorithm lol
	var enemy = enemies[randi() % enemies.size()].instantiate()
	
	var enemy_spawn_location = $EnemySpawn/PathFollow2D

	enemy_spawn_location.progress_ratio = randf()
	
	enemy.position = enemy_spawn_location.position
	
	$Enemies.add_child(enemy)
