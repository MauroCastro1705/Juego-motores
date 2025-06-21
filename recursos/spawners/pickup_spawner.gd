extends Node2D

@export var vida:PackedScene
@export var energy:PackedScene
@export var escudo:PackedScene
@onready var spawn_timer = $spawn_timer
@onready var zona_spawn = $Area2D

var timer_vida:float = 30.0
var timer_energy:float = 50.0
var timer_escudo:float = 20.0



func _ready() -> void:
	spawn_timer.start()
	Global.current_pickups_on_screen = 0
	

func _posicion_aleatoria_en_area() -> Vector2:
	var shape = zona_spawn.get_node("CollisionShape2D").shape
	var extents = shape.extents
	var local_pos = Vector2(
		randf_range(-extents.x, extents.x),
		randf_range(-extents.y, extents.y)
	)
	return zona_spawn.global_position + local_pos


func _on_spawn_timer_timeout() -> void:
	_instanciar_pickup_aleatorio()
	print("pick up spawneado")

func _instanciar_pickup_aleatorio():
	var numero = randi_range(1, 3)

	match numero:
		1:_instanciar_pickup(vida)
		2:_instanciar_pickup(escudo)
		3:_instanciar_pickup(energy)


func _instanciar_pickup(pickup):
	if Global.current_pickups_on_screen < Global.max_pickups_on_screen :
		var nuevo_pickup = pickup.instantiate()
		nuevo_pickup.global_position = _posicion_aleatoria_en_area()
		get_tree().current_scene.add_child(nuevo_pickup)
		Global.current_pickups_on_screen += 1
		
	else:
		print("maxima cant de pickups")
