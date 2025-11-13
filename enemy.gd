extends RigidBody2D
var screen_size = 0
var life = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	add_to_group("enemies")
	pass # Replace with function body.

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("heros"):
		area.take_damage(1) 

func take_damage(amount: int):
	life -= amount
	if life <= 0:
		queue_free()
