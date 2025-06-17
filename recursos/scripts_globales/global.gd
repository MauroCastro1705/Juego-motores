extends Node

var player_score:int = 0

var vida_enemigo1:int = 3
var puntaje_enemigo1:int = 10


func _update_score(new_score):
	var a = player_score
	var b = new_score
	player_score = a + b
