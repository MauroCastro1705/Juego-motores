extends Node2D

@export var enemigo1:PackedScene
@export var enemigo2:PackedScene
@onready var spawn_timer = $spawn_timer
@onready var zona_spawn = $Area2D



func _ready() -> void:
	spawn_timer.start()
	Global.current_enemy_on_screen = 0

func _on_spawn_timer_timeout() -> void:
	if Global.current_enemy_on_screen == 0:
		# Fuerza al menos un enemigo si no hay ninguno en pantalla
		_instanciar_enemigo(enemigo1, true)
	else:
		_instanciar_enemigo_aleatorio()
	
	spawn_timer.start()
	print("cantidad de enemigos ", Global.current_enemy_on_screen)


func _posicion_aleatoria_en_area() -> Vector2:
	var shape = zona_spawn.get_node("CollisionShape2D").shape
	var extents = shape.extents
	var local_pos = Vector2(
		randf_range(-extents.x, extents.x),
		randf_range(-extents.y, extents.y)
	)
	return zona_spawn.global_position + local_pos



func _instanciar_enemigo_aleatorio():
	var numero = randi_range(1, 3) #numero aleatorio para enemigos


	match numero:
		1:_instanciar_enemigo(enemigo1)
		2:_instanciar_enemigo(enemigo1)
		3:_instanciar_jefe()


func _instanciar_jefe():#si se cumple la condicion, se spawnea el jefe
	if Global.player_score > 50:
		_instanciar_enemigo(enemigo2)

func _instanciar_enemigo(enemigo: PackedScene, forzar: bool = false):
	if Global.current_enemy_on_screen < Global.max_enemy1_on_screen or forzar:
		var nuevo_enemigo = enemigo.instantiate()
		nuevo_enemigo.global_position = _posicion_aleatoria_en_area()
		get_tree().current_scene.add_child(nuevo_enemigo)
		Global.current_enemy_on_screen += 1
	else:
		print("máxima cantidad de enemigos")
