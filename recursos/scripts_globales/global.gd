extends Node

#game variables
var max_pickups_on_screen:int = 4
var current_pickups_on_screen:int


#player variables
var player_score:int = 0
var velocidad_bala_player:float = 310.0

#enemy varaibles
var vida_enemigo1:int = 3
var puntaje_enemigo1:int = 10
var velocidad_bala_enemigo1:float = 300.0
var dmg_bala_enemigo1:int = 1

func _update_score(new_score):
	var a = player_score
	var b = new_score
	player_score = a + b
