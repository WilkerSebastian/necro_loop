extends CharacterBody2D

@export var speed = 300.0

@onready var anim_player = $AnimatedSprite2D

const Combatant = preload("res://Actors/Units/Combatant.gd")

var team = Combatant.Team.PLAYER

func _process(delta: float):

	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		direction.y = -1

	if Input.is_action_pressed("move_down"):
		direction.y = 1

	if Input.is_action_pressed("move_left"):
		direction.x = -1

	if Input.is_action_pressed("move_right"):
		direction.x = 1

	velocity = direction.normalized() * speed * delta
	
	move_and_slide()
	
	update_animation()
	
	update_flip()
	
func take_damage(_damage_amount):
	
	print("Rodolfo foi atingido! Fim de Jogo.")
	
	get_tree().reload_current_scene()
	
func update_animation():
	if velocity.length() > 0 and anim_player.animation != "run":
		anim_player.play("run")
			
	else: 
		if anim_player.animation != "idle":
			anim_player.play("idle")

func update_flip():
	
	if velocity.x == 0:
		return
		
	if velocity.x > 0:
		anim_player.flip_h = false
		
	elif velocity.x < 0:
		anim_player.flip_h = true
