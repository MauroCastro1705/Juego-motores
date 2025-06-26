extends Control
@onready var puntaje = $puntaje
@onready var high_score = $puntaje_alto

func _ready() -> void:
	calcular_puntajes()

func _process(_delta: float) -> void:
	if Global.player_murio:
		calcular_puntajes()

func calcular_puntajes():
	puntaje.text = str(Global.player_score)
	high_score.text = str(Global.cargar_high_score())




func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
