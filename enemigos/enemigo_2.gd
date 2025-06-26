extends CharacterBody2D

@export var move_speed: float = 100.0
@export var move_range: float = 100.0   # Rango de movimiento de lado a lado
@export var fire_rate: float = 1.5   
@export var bala_enemigo: PackedScene   # Escena de bala exportada
@onready var vida_local = Global.vida_enemigo1
@onready var sprite_explosion = $AnimatedSprite2D
@onready var sprite_nave = $SpaceShips006
var movement_direction := 1 # 1 = derecha, -1 = izquierda
var start_position_x: float 
@export var zigzag_amplitud := 50.0     # qué tan ancho es el zigzag
@export var zigzag_frecuencia := 2.0    
@onready var escudo = $escudo
@export var move_speed_y := 20.0 
var tiempo := 0.0



func _ready():
	start_position_x = global_position.x
	$Timer_disparo.wait_time = fire_rate
	$Timer_disparo.start()
	_randomizar()
	escudo.monitoring = true


func _physics_process(delta):
	tiempo += delta
	var offset_x = sin(tiempo * zigzag_frecuencia) * zigzag_amplitud# Movimiento en zigzag (X)
	var pos_x = start_position_x + offset_x
	
	var pos_y = global_position.y + move_speed_y * delta# desciende en Y
	global_position = Vector2(pos_x, pos_y)

func _randomizar():
	move_speed += randf_range(-10, 10)
	if randf() < 0.5:
		movement_direction = -1
	else:
		movement_direction = 1


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
		Global._update_score(Global.puntaje_enemigo2) #emitimos puntaje nuevo
		await sprite_explosion.animation_finished	# Esperar que termine la animación antes de destruir
		Global.player_gano = true
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


func _on_escudo_area_entered(area: Area2D) -> void:
	if area.is_in_group("bala_player"):
		area.queue_free()
		call_deferred("desactivar_escudo")
		
func desactivar_escudo():
	escudo.visible = false
	escudo.monitoring = false
	$escudo/CollisionShape2D.disabled = true
