extends CharacterBody2D

@export var move_speed: float = 100.0
@export var move_range: float = 200.0   # Rango de movimiento de lado a lado
@export var fire_rate: float = 1.5   # Tiempo entre disparos
@export var bala_enemigo: PackedScene   # Escena de bala exportada
@onready var vida_local = Global.vida_enemigo1
@onready var sprite_explosion = $AnimatedSprite2D
@onready var sprite_nave = $SpaceShips001
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


func _check_muerte():
	if vida_local == 0:
		Global.current_enemy_on_screen -= 1
		sprite_nave.hide() 
		sprite_explosion.show()
		sprite_explosion.play("muerte")
		AudioManager.ExplosionEnemigo.play()
		Global._update_score(Global.puntaje_enemigo1)
		await sprite_explosion.animation_finished	# Esperar que termine la animación antes de destruir
		queue_free()


func _on_area_damage_area_entered(area: Area2D) -> void:
	if area.is_in_group("bala_player"):
		AudioManager.hitEnemigo.play()
		vida_local -= 1
		_titilar_rojo()
		_check_muerte()
		
func _titilar_rojo():
	sprite_nave.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite_nave.modulate = Color(1, 1, 1) 
