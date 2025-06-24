extends Node2D



func _ready() -> void:
	Global.player_score = 0
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	check_obj(area)
		

func check_obj(area):
	if area.is_in_group("bala_enemigo") or area.is_in_group("bala_player"):
		area.queue_free()
	if area.is_in_group("obstaculo"):
		area.asteroide_sale_area()
	if area.is_in_group("pick-up"):
		area.queue_free()
