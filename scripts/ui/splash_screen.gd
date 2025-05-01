extends Control

func _ready():
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)
	$AnimationPlayer.play("fade")

func _on_animation_finished(anim_name):
	if anim_name == "fade":
		get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
