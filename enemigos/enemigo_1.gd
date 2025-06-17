extends CharacterBody2D

@export var move_speed: float = 100.0
@export var move_range: float = 200.0   # Rango de movimiento de lado a lado
@export var fire_rate: float = 1.5   # Tiempo entre disparos
@export var bala_enemigo: PackedScene   # Escena de bala exportada
@onready var vida_local = Global.vida_enemigo1

var movement_direction := 1 # 1 = derecha, -1 = izquierda
var start_position_x: float # Para controlar el rango de movimiento

func _ready():
	start_position_x = global_position.x
	$Timer_disparo.wait_time = fire_rate
	$Timer_disparo.start()

func _physics_process(_delta):
	# Movimiento lateral
	var movement= Vector2(movement_direction * move_speed, 0)
	velocity = movement
	move_and_slide()
	_calcular_distancia()

func _calcular_distancia():
	# Cambiar dirección si llega al límite del rango
	var distance = global_position.x - start_position_x
	if abs(distance) > move_range:
		movement_direction *= -1

func _shoot():
	if bala_enemigo:
		var bala = bala_enemigo.instantiate()
		bala.global_position = global_position
		get_tree().current_scene.add_child(bala)

func _on_timer_disparo_timeout() -> void:
	_shoot()


func _on_area_damage_body_entered(body: Node2D) -> void:
	if body.is_in_group("bala_player"):
		vida_local -= 1
		_check_muerte()
		
func _check_muerte():
	if vida_local == 0:
		queue_free()
		Global._update_score(Global.puntaje_enemigo1)
	
