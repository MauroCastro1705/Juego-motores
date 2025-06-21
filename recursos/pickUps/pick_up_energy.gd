extends Area2D


func _process(delta):
	position.y -= 20.0 * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		body._energy_pickup()#Metodo en el player.
		print("energy pickup")
		Global.current_pickups_on_screen -= 1
		queue_free()#limpiamos de pantalla
