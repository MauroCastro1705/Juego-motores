extends CharacterBody2D

@export var max_speed: float = 200.0     # Velocidad máxima
@export var aceleracion: float = 500.0   # Qué tan rápido acelera
@export var frenado: float = 600.0      # Qué tan rápido se frena
@export var vida_player:int = 3
@export var vida_escudo:int = 1
var vida_actual
@onready var player_murio:bool = false

@onready var sprite_nave = $PlayerShip
@onready var sprite_explosion = $AnimatedSprite2D
#armas
@onready var cañon1 = $Marker2D #para instanciar balas
@onready var cañon2 = $Marker2D2
var usar_cañon1 := true 
@onready var fire_rate_timer = $fire_rate
var disparando := false
@onready var energy_timer = $max_energy_timer

var fire_rate_normal = 0.4
var fire_rate_max_energy = 0.2

#max energy mode
@onready var max_energy_bar = $max_energy_bar
var se_entro_en_max_energy_mode:bool = false
@onready var max_energy_label = $energy_label


@onready var timer_escudo = $Timer_escudo
@onready var area_escudo = $escudo
var tiempo_recarga_escudo:float = 5.0
@onready var barra_escudo = $escudo/ProgressBar
var se_desactivo_el_escudo:bool = false
#bala
@export var bala_player:PackedScene

func _ready() -> void:
	_set_barra_escudo()
	se_desactivo_el_escudo = false
	timer_escudo.wait_time = tiempo_recarga_escudo
	fire_rate_timer.wait_time = fire_rate_normal
	max_energy_bar.visible = false
	max_energy_label.visible = false
	Global.player_actual_life = Global.player_max_life
	sprite_explosion.visible = false
	

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("derecha") - Input.get_action_strength("izquierda")
	input_vector.y = Input.get_action_strength("abajo") - Input.get_action_strength("arriba")
	_handle_movement(input_vector, delta)
	_handle_disparar()
	move_and_slide()
	_handle_barra_escudo()
	_handle_max_energy()
	_game_over()
	
func _handle_movement(input_vector, delta):
	if input_vector != Vector2.ZERO:
		if not AudioManager.MovimientoAudio.playing:
			AudioManager.MovimientoAudio.play()
		velocity = velocity.move_toward(input_vector * max_speed, aceleracion * delta)
	else:
		if AudioManager.MovimientoAudio.playing:
			AudioManager.MovimientoAudio.stop()
		velocity = velocity.move_toward(Vector2.ZERO, frenado * delta)


##DISPARO·····
func _handle_disparar():
	if Input.is_action_pressed("disparar"):
		if not disparando:
			disparando = true
			fire_rate_timer.start()
			_disparar_balas()
	elif disparando:
		disparando = false
		fire_rate_timer.stop()

func _on_fire_rate_timeout() -> void:
	_disparar_balas()
	AudioManager.disparoAudio.play()

func _disparar_balas():
	var bala = bala_player.instantiate()
	
	var salida : Marker2D
	if usar_cañon1:
		salida = cañon1
	else:
		salida = cañon2
	bala.global_position = salida.global_position
	get_tree().current_scene.add_child(bala)
	AudioManager.disparoAudio.play()
	usar_cañon1 = not usar_cañon1 # Cambiar para el siguiente disparo

##ESCUDO·····
func _on_timer_timeout() -> void:
	_activar_escudo()

func _on_escudo_area_entered(area: Area2D) -> void:
	if area.is_in_group("bala_enemigo"):
		area.queue_free()
		_check_escudo()

func _check_escudo():
	vida_escudo -= 1
	if vida_escudo == 0:
		timer_escudo.start()
		timer_escudo.wait_time = tiempo_recarga_escudo
		se_desactivo_el_escudo = true
		call_deferred("_desactivar_escudo")

func _activar_escudo():
	$escudo/Escudo_imagen.visible = true
	$escudo/CollisionShape2D.disabled = false
	area_escudo.monitoring = true
	vida_escudo = 1
	barra_escudo.visible = false
	se_desactivo_el_escudo = false
	print("volvio escudo")

func _desactivar_escudo():
	$escudo/Escudo_imagen.visible = false
	$escudo/CollisionShape2D.disabled = true
	area_escudo.monitoring = false
	print("perdí escudo")

func _set_barra_escudo():
	barra_escudo.min_value = 0.0
	barra_escudo.max_value = tiempo_recarga_escudo

func _handle_barra_escudo():
	if se_desactivo_el_escudo and timer_escudo.time_left > 0:
		barra_escudo.visible = true
		barra_escudo.max_value = timer_escudo.wait_time
		barra_escudo.value = timer_escudo.time_left
	else:
		barra_escudo.visible = false

##PICK UPS·····

func _regenerar_escudo_pickup():
	AudioManager.PowerupAudio.play()
	if not timer_escudo.is_stopped():
		timer_escudo.stop()
	call_deferred("_activar_escudo")
	print("Escudo regenerado con pickup(player)")

func _regenerar_vida_pickup():
	Global.player_actual_life  += 1
	AudioManager.PowerupAudio.play()
	#mostrar en pantalla la vida?
	
func _energy_pickup():
	energy_timer.start()
	AudioManager.PowerupAudio.play()

	fire_rate_timer.wait_time = fire_rate_max_energy

func _on_max_energy_timer_timeout() -> void:
	fire_rate_timer.wait_time = fire_rate_normal
	max_energy_bar.visible = false
	energy_timer.stop()

func _handle_max_energy():
	if energy_timer.time_left > 0:
		max_energy_bar.visible = true
		max_energy_bar.max_value = energy_timer.wait_time
		max_energy_bar.value = energy_timer.time_left
		max_energy_label.visible = true
	else:
		max_energy_bar.visible = false
		max_energy_label.visible = false


func _titilar_rojo():
	sprite_nave.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite_nave.modulate = Color(1, 1, 1) 

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bala_enemigo"):
		Global.player_actual_life -= 1	
		_titilar_rojo()
		area.queue_free()
		_check_muerte_player()
		
func _check_muerte_player():
	if Global.player_actual_life  == 0:
		print("player murio")
		player_murio = true
		sprite_nave.hide() 
		sprite_explosion.show()
		sprite_explosion.play("muerte")
		await sprite_explosion.animation_finished	# Esperar que termine la animación antes de destruir

func _game_over():
	if player_murio:
		pass
