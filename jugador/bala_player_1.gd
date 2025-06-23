extends Area2D

func _process(delta):
	position.y -= Global.velocidad_bala_player * delta
	
