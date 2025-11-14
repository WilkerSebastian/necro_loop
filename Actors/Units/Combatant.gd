class_name Combatant
extends CharacterBody2D

enum Team { PLAYER, ENEMY }

@export var ally_color: Color = Color.BLUE
@export var enemy_color: Color = Color.RED

var visual_node: Node

@export var team: Team = Team.ENEMY:
	set(value):
		team = value
		if is_inside_tree():
			_update_visuals()
	get:
		return team

@export var health: float = 100.0
@export var speed: float = 150.0
@export var attack_damage: float = 10.0

var target = null

func _ready():
	visual_node = $Visual
	if visual_node == null:
		push_warning("Combatant não encontrou o nó filho 'Visual'!")
		return
		
	_update_visuals()

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


func set_team(new_team: Team):
	self.team = new_team

func take_damage(damage_amount):
	health -= damage_amount
	if health <= 0:
		die()

func die():
	queue_free()
