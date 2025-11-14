extends CharacterBody2D

@export var speed = 300.0

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
	
func take_damage(_damage_amount):
	
	print("Rodolfo foi atingido! Fim de Jogo.")
	
	get_tree().reload_current_scene()
