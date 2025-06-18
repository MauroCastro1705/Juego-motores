extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		body._energy_pickup()#Metodo en el player.
		print("energy pickup")
		queue_free()#limpiamos de pantalla
