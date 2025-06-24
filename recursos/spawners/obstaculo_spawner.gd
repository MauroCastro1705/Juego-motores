extends Node2D
@export var obstaculo1:PackedScene
#@export var obstaculo2:PackedScene

@onready var spawn_timer = $spawn_timer
@onready var zona_spawn = $Area2D

func _ready() -> void:
	spawn_timer.start()
	Global.asteroides_actuales_on_screen = 0



func _posicion_aleatoria_en_area() -> Vector2:
	var shape = zona_spawn.get_node("CollisionShape2D").shape
	var extents = shape.extents
	var local_pos = Vector2(
		randf_range(-extents.x, extents.x),
		randf_range(-extents.y, extents.y)
	)
	return zona_spawn.global_position + local_pos



func _instanciar_obstaculo_aleatorio():
	var numero = randi_range(1, 2) #numero aleatorio para enemigos


	match numero:
		1:_instanciar_obstaculo(obstaculo1)
		2:_instanciar_obstaculo(obstaculo1)


func _instanciar_obstaculo(obstaculo):
	if Global.asteroides_actuales_on_screen < Global.max_asteroides_on_screen :
		var nuevo_obstaculo = obstaculo.instantiate()
		nuevo_obstaculo.global_position = _posicion_aleatoria_en_area()
		get_tree().current_scene.add_child(nuevo_obstaculo)
		Global.asteroides_actuales_on_screen += 1
	else:
		print("maxima cant de obstaculos")


func _on_spawn_timer_timeout() -> void:
	_instanciar_obstaculo_aleatorio()
	spawn_timer.start()
	print("cantidad de obstaculos ", Global.asteroides_actuales_on_screen)
