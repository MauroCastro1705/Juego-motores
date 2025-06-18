extends CharacterBody2D

@export var max_speed: float = 300.0     # Velocidad máxima
@export var aceleracion: float = 900.0   # Qué tan rápido acelera
@export var frenado: float = 800.0      # Qué tan rápido se frena
@export var vida_player:int = 3
@export var vida_escudo:int = 1

@onready var marker = $Marker2D #para instanciar balas
@onready var marker2 = $Marker2D2
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
	
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("derecha") - Input.get_action_strength("izquierda")
	input_vector.y = Input.get_action_strength("abajo") - Input.get_action_strength("arriba")
	_handle_movement(input_vector, delta)
	_handle_disparar()
	move_and_slide()
	_handle_barra_escudo()
	
func _handle_movement(input_vector, delta):
	
	if input_vector != Vector2.ZERO:
		# move_toward = interpola
		velocity = velocity.move_toward(input_vector * max_speed, aceleracion * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, frenado * delta)

##DISPARO·····
func _handle_disparar():
	if Input.is_action_just_pressed("disparar"):
		#posible logica de fire-rate
		_disparar_balas()

func _disparar_balas():
	if bala_player:
		var bala = bala_player.instantiate()
		bala.global_position = global_position
		get_tree().current_scene.add_child(bala)

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
	if not timer_escudo.is_stopped():
		timer_escudo.stop()
	call_deferred("_activar_escudo")
	print("Escudo regenerado con pickup(player)")
