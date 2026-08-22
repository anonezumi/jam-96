extends Node2D

@export var cooldown: float = 1.0
@export var shot_speed: float = 5.0
@export var attack_range: float = 150.0
@export var cooldown_poss: float = 0.2
@export var shot_speed_poss: float = 10.0
@export var shot_speed_special: float = 10.0
@export var bullet: PackedScene
@export var bullet_poss: PackedScene
@export var bullet_special: PackedScene
@export var tower_type: TowerType
@export var offset: Vector2
var time_to_fire = cooldown
var possessed = false

enum TowerType {
	LIGHTNING,
	WAVE,
	BOMB
}

func _ready():
	SignalBus.change_possessed.connect(on_change_possessed)

func on_change_possessed(tower: Node2D):
	self.possessed = tower == self
	self.find_child("PossessedEffect").visible = self.possessed
	if self.possessed and (time_to_fire > cooldown_poss):
		time_to_fire = cooldown_poss

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_to_fire -= delta
	if possessed and tower_type == TowerType.LIGHTNING:
		point_head(get_viewport().get_mouse_position())
	if time_to_fire <= 0:
		if possessed:
			time_to_fire += cooldown_poss
			var bullet_inst = bullet_poss.instantiate()
			add_child(bullet_inst)
			if tower_type == TowerType.LIGHTNING:
				var direction = position.direction_to(get_viewport().get_mouse_position())
				bullet_inst.position = direction * 30 # FIXME
				bullet_inst.set_velocity(direction * shot_speed_poss)
			elif tower_type == TowerType.BOMB:
				bullet_inst.global_position = get_viewport().get_mouse_position()
		else:
			var target = get_target()
			if target != self: # target is self if none in range
				time_to_fire += cooldown
				var bullet_inst = bullet.instantiate()
				add_child(bullet_inst)
				if tower_type == TowerType.LIGHTNING:
					point_head(target.position)
					var direction = position.direction_to(target.position)
					bullet_inst.position = direction * 96 # FIXME
					bullet_inst.set_velocity(direction * shot_speed)
				if tower_type == TowerType.BOMB:
					bullet_inst.set_target(target.position, shot_speed)
			else:
				time_to_fire = 0

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
	head.rotation = -(PI/6) + angle - (ind*PI)/3.0

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

func shoot_special():
	var bullet_inst = bullet_special.instantiate()
	add_child(bullet_inst)
	if tower_type == TowerType.LIGHTNING:
		var direction = position.direction_to(get_viewport().get_mouse_position())
		bullet_inst.position = direction * 30 # FIXME
		bullet_inst.set_velocity(direction * shot_speed_special)
	elif tower_type == TowerType.BOMB:
		bullet_inst.global_position = get_viewport().get_mouse_position()
