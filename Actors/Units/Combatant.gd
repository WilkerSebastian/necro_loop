class_name Combatant
extends CharacterBody2D

enum Team { PLAYER, ENEMY }

enum EnemyState { IDLE, ATTACKING }

@export var health: float = 100.0
@export var attack_damage: float = 10.0
@export var attack_speed: float = 1.0 
@export var attack_range: float = 40.0
@export var speed: float = 150.0

var attack_timer: Timer

var enemy_state = EnemyState.IDLE
var horde_spawn_position = Vector2.ZERO 

var target = null

var visual_node: Node

@export var ally_color: Color = Color.BLUE
@export var enemy_color: Color = Color.RED

@export var team: Team = Team.ENEMY:
	set(value):
		team = value
		if is_inside_tree():
			_update_visuals()
	get:
		return team

func _ready():
	visual_node = $Visual
	if visual_node == null:
		push_warning("Combatant não encontrou o nó filho 'Visual'!")
		return
		
	_update_visuals()
	
	if has_node("AttackTimer"):
		attack_timer = $AttackTimer
		attack_timer.wait_time = 1.0 / attack_speed
		attack_timer.timeout.connect(_perform_attack)
	else:
		push_warning("Combatant não tem um nó filho 'AttackTimer'!")

func _update_visuals():
	
	if visual_node == null:
		return

	if visual_node is ColorRect:
		if team == Team.PLAYER:
			visual_node.color = ally_color
		else:
			visual_node.color = enemy_color
	
	# TODO: trocar por sprites depois:
	# if visual_node is Sprite2D:
	#    if team == Team.PLAYER:
	#        visual_node.texture = load("res://path/to/ally_sprite.png")
	#    else:
	#        visual_node.texture = load("res://path/to/enemy_sprite.png")


func command_attack(new_target):
	target = new_target
	if target:
		enemy_state = EnemyState.ATTACKING
	else:
		command_idle()

func command_idle(idle_position = horde_spawn_position):
	target = null
	enemy_state = EnemyState.IDLE
	horde_spawn_position = idle_position 

func _set_team_value(new_team):
	team = new_team
	
	if team == Team.PLAYER:
		add_to_group("allies")
		remove_from_group("enemies")
  
		collision_layer = 1 << 2 # Camada 3
		collision_mask = 1 | (1 << 3) # Camadas 1 e 4
	else:
		add_to_group("enemies")
		remove_from_group("allies")
		collision_layer = 1 << 3 # camada 4
		collision_mask = 1 | (1 << 2) # camadas 1 e 3

	if is_inside_tree():
		_update_visuals()

func take_damage(damage_amount):
	health -= damage_amount
	if health <= 0:
		die()

func die():
	if team == Team.PLAYER:
		remove_from_group("allies")
	
	queue_free()
	
func _perform_attack():
	pass
