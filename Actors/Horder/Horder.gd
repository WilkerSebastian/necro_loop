extends Node2D

@export var combatant_scene: PackedScene
@export var unit_count: int = 5

var combatants = []
var current_target = null

func _ready():
	
	$DetectionArea.body_entered.connect(_on_player_entered)
	$DetectionArea.body_exited.connect(_on_player_exited)
	
	$SpawnUnitsTimer.timeout.connect(_spawn_units)
	$SpawnUnitsTimer.start()


func _spawn_units():
	if not combatant_scene:
		push_error("Horde não tem uma 'combatant_scene' definida!")
		return

	for i in unit_count:
		var new_unit = combatant_scene.instantiate()
		
		var spawn_offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	
		add_child(new_unit)
		new_unit.global_position = global_position + spawn_offset
		
		new_unit._set_team_value(Combatant.Team.ENEMY)
		
		combatants.append(new_unit)
		
	print("Horda gerada com %s unidades" % combatants.size())


func _on_player_entered(body):
	
	print("Horda detectou o player!")
	
	current_target = _find_closest_ally(body.global_position)
	
	if current_target:
		print("Horda mandando atacar o alvo: ", current_target.name)
		_command_all_attack()


func _on_player_exited(_body):
	print("Horda perdeu o player de vista.")
	current_target = null
	_command_all_idle()

func _command_all_attack():
	for unit in combatants:
		if is_instance_valid(unit):
			unit.command_attack(current_target)

func _command_all_idle():
	for unit in combatants:
		if is_instance_valid(unit):
			unit.command_idle()

func _find_closest_ally(player_position):
	var allies = get_tree().get_nodes_in_group("allies")
	var closest_ally = null
	var min_distance = INF # Infinito
	
	if allies.size() == 0:
		return get_tree().get_first_node_in_group("player")
	
	for ally in allies:
		var distance = ally.global_position.distance_to(player_position)
		if distance < min_distance:
			min_distance = distance
			closest_ally = ally
			
	return closest_ally
