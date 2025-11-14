extends Combatant
class_name Warrior

@export var max_follow_distance: float = 150.0 
@export var min_follow_distance: float = 75.0  

var follow_target: CharacterBody2D

var detection_area: Area2D

func _ready():
	super._ready() 
	
	detection_area = $DetectionArea
	detection_area.body_entered.connect(_on_enemy_entered)
	detection_area.body_exited.connect(_on_enemy_exited)
	
	if team == Team.PLAYER:
		target = get_tree().get_first_node_in_group("player")
		detection_area.monitoring = true
	else:
		command_idle(global_position)
		detection_area.monitoring = false

func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	if team == Team.PLAYER:
		if is_instance_valid(target):
			_run_combat_logic()
		elif is_instance_valid(follow_target):
			_run_follow_logic()
	
	elif team == Team.ENEMY:
		if is_instance_valid(target):
			_run_combat_logic()
		else:
			pass

	move_and_slide()
	
func _run_combat_logic():
	var distance_to_target = global_position.distance_to(target.global_position)
	
	if distance_to_target > attack_range:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		if attack_timer.is_stopped():
			_perform_attack()

func _run_follow_logic():
	var dir = global_position.direction_to(follow_target.global_position)
	var dist = global_position.distance_to(follow_target.global_position)
	
	if dist > max_follow_distance:
		velocity = dir * speed
	elif dist < min_follow_distance:
		velocity = dir * -1 * speed
	
	
func _perform_attack():
	
	if not is_instance_valid(target):
		return

	attack_timer.start()
	var bodies = $MeleeHitbox.get_overlapping_bodies()
	
	for body in bodies:
		if body == target:
			if body.has_method("take_damage"):
				var is_same_team = false
				
				if "team" in body:
					is_same_team = (body.team == self.team)

				if not is_same_team:
					body.take_damage(attack_damage)
					break
		return
	
func _on_enemy_entered(body):
	if team == Team.PLAYER and body.is_in_group("enemies"):
		if not is_instance_valid(target):
			target = body

func _on_enemy_exited(body):
	if body == target:
		target = null
