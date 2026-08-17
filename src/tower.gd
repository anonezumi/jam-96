extends Node2D

@export var cooldown: float = 1.0
@export var shot_speed: float = 5.0
@export var attack_range: float = 150.0
@export var cooldown_poss: float = 0.2
@export var shot_speed_poss: float = 10.0
@export var bullet: PackedScene
@export var bullet_poss: PackedScene
@export var tower_type: TowerType
var time_since_fire = cooldown
var possessed = false

enum TowerType {
	LIGHTNING,
	WAVE
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
	if possessed and tower_type == TowerType.LIGHTNING:
		point_head(get_viewport().get_mouse_position())
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
				point_head(target.position)
				time_since_fire += cooldown
				var bullet_inst = bullet.instantiate()
				add_child(bullet_inst)
				var vel = position.direction_to(target.position) * shot_speed
				bullet_inst.set_velocity(vel)

func point_head(target: Vector2):
	var angle = position.angle_to_point(target)
	# divide the circle into 6 slices, with one on the x-axis
	var ind = floori((angle/PI) * 3.0)
	var head_sprite = null
	var flip = false
	match ind:
		0:
			head_sprite = preload("res://assets/pee shoter/downleft.png")
			flip = true
		1:
			head_sprite = preload("res://assets/pee shoter/down.png")
		2:
			head_sprite = preload("res://assets/pee shoter/downleft.png")
		-1:
			head_sprite = preload("res://assets/pee shoter/upleft.png")
			flip = true
		-2:
			head_sprite = preload("res://assets/pee shoter/up.png")
		-3, 3: # edge case for exactly pi - idk when it returns -pi vs pi but gonna add this
			head_sprite = preload("res://assets/pee shoter/upleft.png")
	var head = find_child("Head")
	head.texture = head_sprite
	if flip:
		head.scale.x = -abs(head.scale.x)
	else:
		head.scale.x = abs(head.scale.x)

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
