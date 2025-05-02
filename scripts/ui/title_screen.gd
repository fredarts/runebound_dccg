extends Control
## TitleScreen – Ken-Burns + navegação de botões com estilos
## Godot Engine 4.4 – GDScript

@export var backgrounds: Array[Texture2D]
@export var ken_duration := 10.0
@export var fade_duration := 1.0

# --- Estilos de Botão Exportáveis ---
@export var button_gradient_cores: Array[Color] = [Color(0.3, 0.6, 1.0), Color(0.1, 0.3, 0.7)]
@export var button_shadow_offset: Vector2 = Vector2(2, 2)
@export var button_shadow_color: Color = Color(0, 0, 0, 0.5)
@export var button_highlight_color: Color = Color(1, 1, 1, 0.2) # Note: This is simulated with color lerp on hover
@export var button_border_color: Color = Color(0.2, 0.4, 0.8)
@export var button_border_width: int = 2
@export var button_corner_radius: int = 5

var _idx: int = 0
var _showing_a: bool = true

func _ready() -> void:
	assert(backgrounds.size() >= 2, "Necessário ≥ 2 backgrounds")

	# ---- inicializa camadas ----
	$BgLayerA.texture = backgrounds[0]
	$BgLayerA.modulate.a = 1.0
	$BgLayerB.texture = backgrounds[1]
	$BgLayerB.modulate.a = 0.0

	# ---- timer ----
	$KenTimer.one_shot = true
	$KenTimer.wait_time = ken_duration
	$KenTimer.timeout.connect(_on_ken_timer_timeout)

	# ---- animações ----
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)
	$AnimationPlayer.play("KenA")
	$KenTimer.start()

	# ---- aplica estilo aos botões e conecta sinais ----
	for button in $"Overlay/BtnPanel".get_children():
		if button is Button:
			_apply_button_style(button)
			# Connect using the bind method (still valid in Godot 4)
			button.pressed.connect(_on_button_pressed.bind(button.name))

func _apply_button_style(button: Button) -> void:
	var normal_style := StyleBoxFlat.new()

	# Gradiente
	normal_style.bg_color = button_gradient_cores[0] # Start color
	normal_style.bg_color_2 = button_gradient_cores[1] # End color
	normal_style.bg_color_is_gradient = true
	# Set vertical direction for the gradient
	normal_style.gradient_filter_vector = Vector2(0, 1) # Vertical gradient

	# Borda
	normal_style.border_color = button_border_color
	normal_style.border_width_all = button_border_width
	normal_style.corner_radius_all = button_corner_radius
	normal_style.shadow_color = button_shadow_color
	normal_style.shadow_offset = button_shadow_offset

	button.add_theme_stylebox_override("normal", normal_style)

	# Style for "hover" state (simulated highlight)
	var hover_style := normal_style.duplicate()
	# Slightly lighten the gradient colors on hover
	hover_style.bg_color = button_gradient_cores[0].lerp(Color.WHITE, 0.2)
	hover_style.bg_color_2 = button_gradient_cores[1].lerp(Color.WHITE, 0.2)
	hover_style.bg_color_is_gradient = true
	hover_style.gradient_filter_vector = Vector2(0, 1) # Vertical gradient
	hover_style.shadow_offset = button_shadow_offset + Vector2(1, 1)
	button.add_theme_stylebox_override("hover", hover_style)

	# Style for "pressed" state (sinking effect)
	var pressed_style := normal_style.duplicate()
	# Reverse the gradient colors and reduce shadow for pressed effect
	pressed_style.bg_color = button_gradient_cores[1] # Start color
	pressed_style.bg_color_2 = button_gradient_cores[0] # End color
	pressed_style.bg_color_is_gradient = true
	pressed_style.gradient_filter_vector = Vector2(0, 1) # Vertical gradient
	pressed_style.shadow_offset = Vector2.ZERO
	button.add_theme_stylebox_override("pressed", pressed_style)


func _on_ken_timer_timeout() -> void:
	_idx = (_idx + 1) % backgrounds.size()
	if _showing_a:
		$BgLayerB.texture = backgrounds[_idx]
	else:
		$BgLayerA.texture = backgrounds[_idx]
	$AnimationPlayer.play("CrossFade")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name != "CrossFade":
		return
	_showing_a = not _showing_a
	$BgLayerA.modulate.a = 1.0 if _showing_a else 0.0
	$BgLayerB.modulate.a = 0.0 if _showing_a else 1.0
	$AnimationPlayer.play("KenA" if _showing_a else "KenB")
	$KenTimer.start(ken_duration)


func _on_button_pressed(button_name: String) -> void:
	match button_name:
		"LoginBtn":
			# Ensure the scenes exist at these paths
			get_tree().change_scene_to_file("res://scenes/LoginScreen.tscn")
		"CreateBtn":
			get_tree().change_scene_to_file("res://scenes/CreateAccount.tscn")
		"OptionsBtn":
			get_tree().change_scene_to_file("res://scenes/OptionsScreen.tscn")
		_:
			printerr("Botão não reconhecido: ", button_name)
