extends RigidBody2D

var vida_asteroide:int = 3



func _physics_process(_delta: float) -> void:
	apply_central_impulse(Vector2(0.05,0.07))

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bala_enemigo") or area.is_in_group("bala_player"):
		area.queue_free()
		asteroide_muere()

func asteroide_muere():
	vida_asteroide -= 1
	if vida_asteroide == 0:
		queue_free()
