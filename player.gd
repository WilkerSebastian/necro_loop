extends Area2D

@export var speed = 400
var screen_size = 0
var life = 12

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("heros")
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
	else:
		$AnimatedSprite2D.stop()

func take_damage(amount: int):
	life -= amount
	if life <= 0:
		queue_free()
