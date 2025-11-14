extends Combatant
class_name Warrior

@export var max_follow_distance: float = 150.0 
@export var min_follow_distance: float = 75.0  

func _ready():
	super._ready()
	if team == Team.PLAYER:
		target = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	
	velocity = Vector2.ZERO

	if team == Team.PLAYER and target:
		
		var direction_to_target = global_position.direction_to(target.global_position)
		var distance_to_target = global_position.distance_to(target.global_position)

		if distance_to_target > max_follow_distance:
			velocity = direction_to_target * speed
		
		elif distance_to_target < min_follow_distance:
			velocity = direction_to_target * -1 * speed

	elif team == Team.ENEMY:
		# TODO: Logica de IA do inimigo
		pass 
	
	move_and_slide()
