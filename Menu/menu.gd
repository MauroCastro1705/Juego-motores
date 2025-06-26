extends Control

func _ready() -> void:
	Global.player_murio = false
	Global.player_gano = false

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://niveles/nivel-1.tscn")




func _on_salir_pressed() -> void:
	get_tree().quit()
	


func _on_controles_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/controles.tscn")
