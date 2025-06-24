extends RigidBody2D

var vida_asteroide:int = 3
@onready var explosion = $AnimatedSprite2D
@onready var asteroide = $SpaceMeteors001
var numero1 = randf_range(0.02, 0.08)
var numero2 = randf_range(0.02, 0.08)

func _ready() -> void:
	explosion.visible = false

func _physics_process(_delta: float) -> void:
	apply_central_impulse(Vector2(numero1,numero2))


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bala_enemigo") or area.is_in_group("bala_player"):
		area.queue_free()
		asteroide_muere()
		

func asteroide_muere():
	vida_asteroide -= 1
	_titilar_rojo()
	if vida_asteroide == 0:
		explosion_asteroide()
		
func _titilar_rojo():
	asteroide.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	asteroide.modulate = Color(1, 1, 1) 

func explosion_asteroide():
	print("muere asteroide")
	Global.asteroides_actuales_on_screen -= 1
	asteroide.visible = false 
	explosion.visible = true
	explosion.play("muerte")
	AudioManager.ExplosionEnemigo.play()
	await explosion.animation_finished	# Esperar que termine la animación antes de destruir
	queue_free()
