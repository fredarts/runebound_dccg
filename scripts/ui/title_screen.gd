extends Control

@export var backgrounds: Array[Texture]
@export var ken_duration := 10.0      # quanto tempo dura o zoom
@export var fade_duration := 1.0      # duração do cross-fade

var _idx := 0
var _showing_a := true

func _ready() -> void:
	assert(backgrounds.size() >= 2)
	$BgLayerA.texture = backgrounds[0]
	$BgLayerB.modulate.a = 0.0
	$AnimationPlayer.play("KenA")          # Loop OFF nos clipes
	$KenTimer.timeout.connect(_on_ken_done)
	$KenTimer.start(ken_duration)

func _on_ken_done() -> void:
	# escolhe próxima imagem
	_idx = (_idx + 1) % backgrounds.size()

	if _showing_a:
		$BgLayerB.texture = backgrounds[_idx]
	else:
		$BgLayerA.texture = backgrounds[_idx]

	# faz cross-fade
	$AnimationPlayer.play("CrossFade")
	$AnimationPlayer.animation_finished.connect(
		_on_cross_done, CONNECT_ONE_SHOT)

func _on_cross_done(anim_name: String) -> void:
	if anim_name == "CrossFade":
		_showing_a = !_showing_a
		$AnimationPlayer.play("KenA" if _showing_a else "KenB")
		$KenTimer.start(ken_duration)   # reinicia o mesmo timer


# ------------ Botões ---------------
func _on_LoginBtn_pressed():
	get_tree().change_scene_to_file("res://scenes/LoginScreen.tscn")

func _on_CreateBtn_pressed():
	get_tree().change_scene_to_file("res://scenes/CreateAccount.tscn")

func _on_OptionsBtn_pressed():
	get_tree().change_scene_to_file("res://scenes/OptionsScreen.tscn")
