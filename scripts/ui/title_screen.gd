extends Control
## TitleScreen – Ken-Burns + navegação de botões
## Godot 4.4 – GDScript 2.0

@export var backgrounds: Array[Texture2D]
@export var ken_duration := 10.0    # s
@export var fade_duration := 1.0    # s

var _idx: int      = 0
var _showing_a: bool = true

func _ready() -> void:
	assert(backgrounds.size() >= 2, "Necessário ≥ 2 backgrounds")

	# ---- inicializa camadas ----
	$BgLayerA.texture    = backgrounds[0]
	$BgLayerA.modulate.a = 1.0
	$BgLayerB.texture    = backgrounds[1]
	$BgLayerB.modulate.a = 0.0

	# ---- timer ----
	$KenTimer.one_shot  = true
	$KenTimer.wait_time = ken_duration
	$KenTimer.timeout.connect(_on_ken_timer_timeout)

	# ---- animações ----
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)
	$AnimationPlayer.play("KenA")
	$KenTimer.start()

	# ---- conecta botões uma única vez ----
	$"Overlay/BtnPanel/LoginBtn".pressed.connect(_on_LoginBtn_pressed)
	$"Overlay/BtnPanel/CreateBtn".pressed.connect(_on_CreateBtn_pressed)
	$"Overlay/BtnPanel/OptionsBtn".pressed.connect(_on_OptionsBtn_pressed)

# ─────────── KenTimer ───────────
func _on_ken_timer_timeout() -> void:
	_idx = (_idx + 1) % backgrounds.size()
	if _showing_a:
		$BgLayerB.texture = backgrounds[_idx]
	else:
		$BgLayerA.texture = backgrounds[_idx]
	$AnimationPlayer.play("CrossFade")

# ─────────── animação terminó ───
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name != "CrossFade": return
	_showing_a = !_showing_a
	$BgLayerA.modulate.a = 1.0 if _showing_a else 0.0
	$BgLayerB.modulate.a = 0.0 if _showing_a else 1.0
	$AnimationPlayer.play("KenA" if _showing_a else "KenB")
	$KenTimer.start(ken_duration)

# ─────────── botões ─────────────
func _on_LoginBtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LoginScreen.tscn")

func _on_CreateBtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/CreateAccount.tscn")

func _on_OptionsBtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/OptionsScreen.tscn")
