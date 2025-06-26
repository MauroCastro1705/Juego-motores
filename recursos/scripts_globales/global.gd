extends Node

#game variables
var max_pickups_on_screen:int = 4
var current_pickups_on_screen:int


#player variables
var player_score:int = 0
var high_score_guardado = cargar_high_score()
var velocidad_bala_player:float = 310.0
var player_actual_life:int
var player_max_life:int = 3
var player_murio:bool = false

#enemy varaibles
var vida_enemigo1:int = 3
var puntaje_enemigo1:int = 10
var velocidad_bala_enemigo1:float = 300.0
var dmg_bala_enemigo1:int = 1
var max_enemy1_on_screen:int = 4
var current_enemy_on_screen:int  = 0


var puntaje_enemigo2:int = 30

#asteroides
var max_asteroides_on_screen:int = 3
var asteroides_actuales_on_screen:int = 0

func _ready():
	high_score_guardado = cargar_high_score()

func _update_score(new_score):
	var a = player_score
	var b = new_score
	player_score = a + b
	if player_score > high_score_guardado:
		guardar_high_score(player_score)

func guardar_high_score(score: int):
	var data := HighScoreData.new()
	data.score = score
	var path := "user://high_score.tres"
	var result := ResourceSaver.save(data, path)
	if result != OK:
		print("Error al guardar el high score: ", result)
		
func cargar_high_score() -> int:
	var path := "user://high_score.tres"
	if ResourceLoader.exists(path):
		return cargar_data(path)
	else:
		print("No existe archivo de high score todavía.")
	return 0


func cargar_data(path):
	var data := ResourceLoader.load(path) as HighScoreData
	if data:
		return data.score
	else:
		print("No se pudo cargar el recurso.")
