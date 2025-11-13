extends RigidBody2D
var life = 12

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("heros")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func take_damage(amount: int):
	life -= amount
	if life <= 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.take_damage(1) 
