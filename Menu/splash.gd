extends Control


@export var fade_duration := 1.5  
@export var display_time := 2.0    
@export var next_scene_path := "res://Menu/menu.tscn"

@onready var logo := $"Button-dark"

func _ready():
	logo.modulate.a = 0.0  # Comienza totalmente transparente
	fade_in()

func fade_in():
	var tween = create_tween()
	tween.tween_property(logo, "modulate:a", 1.0, fade_duration)
	tween.tween_callback(Callable(self, "wait_and_fade_out"))

func wait_and_fade_out():
	await get_tree().create_timer(display_time).timeout
	fade_out()

func fade_out():
	var tween = create_tween()
	tween.tween_property(logo, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(Callable(self, "load_next_scene"))

func load_next_scene():
	get_tree().change_scene_to_file(next_scene_path)
