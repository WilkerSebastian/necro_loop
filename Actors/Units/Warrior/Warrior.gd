extends Combatant
class_name Warrior

@export var max_follow_distance: float = 150.0 
@export var min_follow_distance: float = 75.0  

func _ready():
	super._ready() 
	if team == Team.PLAYER:
		target = get_tree().get_first_node_in_group("player")
	else:
		command_idle(global_position)

func _physics_process(_delta):
	velocity = Vector2.ZERO

	if team == Team.PLAYER:
		if target:
			var dir = global_position.direction_to(target.global_position)
			var dist = global_position.distance_to(target.global_position)
			if dist > max_follow_distance:
				velocity = dir * speed
			elif dist < min_follow_distance:
				velocity = dir * -1 * speed
		
	elif team == Team.ENEMY:
		match enemy_state:
			EnemyState.IDLE:
				# TODO: Poderia andar aleatoriamente perto da 'horde_spawn_position'
				pass 
			
			EnemyState.ATTACKING:
				if is_instance_valid(target): 
					var direction = global_position.direction_to(target.global_position)
					velocity = direction * speed
				else:
					command_idle()

	move_and_slide()
