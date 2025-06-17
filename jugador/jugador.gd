extends CharacterBody2D

@export var max_speed: float = 300.0     # Velocidad máxima
@export var aceleracion: float = 900.0   # Qué tan rápido acelera
@export var frenado: float = 800.0      # Qué tan rápido se frena
@onready var marker = $Marker2D #para instanciar balas
@onready var marker2 = $Marker2D2
@onready var timer_escudo = $Timer

#bala
@export var bala:PackedScene

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("derecha") - Input.get_action_strength("izquierda")
	input_vector.y = Input.get_action_strength("abajo") - Input.get_action_strength("arriba")
	_handle_movement(input_vector, delta)
	move_and_slide()	
	_disparar()

func _handle_movement(input_vector, delta):
	if input_vector != Vector2.ZERO:
		# move_toward = interpola
		velocity = velocity.move_toward(input_vector * max_speed, aceleracion * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, frenado * delta)

func _disparar():
	if Input.is_action_just_pressed("disparar"):
		pass
