extends Node2D



func _ready() -> void:
	Global.player_score = 0
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	_borrar_balas(area)
		
func _borrar_balas(area):
	if area.is_in_group("bala_enemigo") or area.is_in_group("bala_player") or area.is_in_group("obstaculo"):
		area.queue_free()
		print("borrado = ", area)
