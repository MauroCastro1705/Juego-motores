extends CanvasLayer

func _ready():
	$ColorRect.visible = false
	$PanelContainer.visible = false
	$TextEdit.visible = false
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("BotonPausa"):
		get_tree().paused = not get_tree().paused
		$ColorRect.visible = not $ColorRect.visible
		$PanelContainer.visible = not $PanelContainer.visible
		$TextEdit.visible = not $TextEdit.visible
		
		
func _on_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://niveles/nivel-1.tscn")

func _on_volver_al_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
