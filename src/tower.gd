extends Node2D

@export var cooldown: float = 1.0
@export var shot_speed: float = 5.0
@export var attack_range: float = 150.0
@export var cooldown_poss: float = 0.2
@export var shot_speed_poss: float = 10.0
@export var bullet: PackedScene
@export var bullet_poss: PackedScene
var time_since_fire = cooldown
var possessed = false

enum TowerType {
	LIGHTNING,
	WATER
}

func _ready():
	SignalBus.change_possessed.connect(on_change_possessed)

func on_change_possessed(tower: Node2D):
	self.possessed = tower == self
	self.find_child("PossessedEffect").visible = self.possessed
	if self.possessed and (time_since_fire > cooldown_poss):
		time_since_fire = cooldown_poss

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_fire -= delta
	if time_since_fire <= 0:
		if possessed:
			time_since_fire += cooldown_poss
			var bullet_inst = bullet_poss.instantiate()
			add_child(bullet_inst)
			var vel = position.direction_to(get_viewport().get_mouse_position()) * shot_speed_poss
			bullet_inst.set_velocity(vel)
		else:
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
