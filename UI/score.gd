extends Control

@onready var scoreLabel = $Label

func _process(_delta: float) -> void:
	scoreLabel.text = str(Global.player_score)
