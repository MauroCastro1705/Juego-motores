extends Control
@onready var cant_vidas = $Label2

func _process(_delta: float) -> void:
	cant_vidas.text = str(Global.player_actual_life)
