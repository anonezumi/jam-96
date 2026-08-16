extends Node2D

@export var cooldown: float = 1.0
@export var shot_speed: float = 5.0
@export var attack_range: float = 150.0
@export var bullet: PackedScene
var time_since_fire = cooldown

enum TowerType {
	LIGHTNING,
	WATER
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_fire -= delta
	if time_since_fire <= 0:
		var target = get_target()
		if target != self: # target is self if none in range
			time_since_fire += cooldown
			var bullet_inst = bullet.instantiate()
			add_child(bullet_inst)
			var vel = position.direction_to(target.position) * shot_speed
			bullet_inst.set_velocity(vel)

func get_target() -> Node2D: # returns self if no target found
	var closest_enemy
	var closest_distance = attack_range
	for enemy in $"../Enemies".get_children():
		var distance = position.distance_to(enemy.position)
		if distance < closest_distance:
			closest_enemy = enemy
			closest_distance = distance
	if closest_distance != attack_range:
		return closest_enemy
	else:
		return self
