extends Node

@export var horde_scene: PackedScene

var spawn_points = []

func _ready():
	
	spawn_points = get_tree().get_nodes_in_group("spawn_points")
	
	print(spawn_points)
	
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if spawn_points.is_empty():
		push_warning("HordeSpawner não tem filhos no grupo 'spawn_points'!")
		return
		
	if not horde_scene:
		push_error("HordeSpawner não tem 'horde_scene' definida!")
		return

	var random_point = spawn_points.pick_random()
	
	var new_horde = horde_scene.instantiate()
	
	get_parent().add_child(new_horde)
	
	new_horde.global_position = random_point.global_position
