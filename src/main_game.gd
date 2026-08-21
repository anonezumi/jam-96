extends Node

@export var enemies: Array[PackedScene]
@export var difficulty_factors: Array[float] # multiplies the spawn time for each enemy
@export var spawn_time: float = 1.0
@export var spawnrate_doubletime = 60.0
@export var health_doubletime = 60.0
@export var speed_doubletime = 240.0

var wave_started = false
var time_to_spawn = spawn_time
var total_time = 0.0

func _process(delta: float) -> void:
	if not wave_started:
		return
	time_to_spawn -= delta
	total_time += delta
	if time_to_spawn <= 0:
		var enemy_ind = randi() % enemies.size()
		var spawnrate_mod = difficulty_factors[enemy_ind] / (2**(total_time/spawnrate_doubletime))
		time_to_spawn += spawn_time * spawnrate_mod
		
		var enemy = enemies[enemy_ind].instantiate()
		
		var enemy_spawn_location = $EnemySpawn/PathFollow2D
		enemy_spawn_location.progress_ratio = randf()
		enemy.position = enemy_spawn_location.position
		
		enemy.speed *= (2**(total_time/speed_doubletime))
		
		var health_node = enemy.find_child("Health")
		health_node.health = floori(health_node.health * (2**(total_time/health_doubletime)))
		
		$Enemies.add_child(enemy)

func _on_start_wave_pressed() -> void:
	$InputOverlay/StartWave.visible = false
	wave_started = true
