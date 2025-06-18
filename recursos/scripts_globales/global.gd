extends Node

var player_score:int = 0

var vida_enemigo1:int = 3
var puntaje_enemigo1:int = 10
var velocidad_bala_enemigo1:float = 300.0
var dmg_bala_enemigo1:int = 1

func _update_score(new_score):
	var a = player_score
	var b = new_score
	player_score = a + b
