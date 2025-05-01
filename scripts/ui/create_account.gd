extends Control
@onready var _user       := $VBox/VBoxContainer/UserEdit
@onready var _pass       := $VBox/VBoxContainer/PassEdit
@onready var _confirm    := $VBox/VBoxContainer/ConfirmEdit
@onready var _msg        := $VBox/VBoxContainer/MsgLabel
@onready var _create_btn := $VBox/VBoxContainer/CreateBtn
var account_manager
func _ready() -> void:
	account_manager = AccountManager.new()
	_user.text_changed.connect(_validate)
	_create_btn.pressed.connect(_on_create_pressed)
	$VBox/VBoxContainer/BackBtn.pressed.connect(_on_back)
func _validate(new_text: String = "") -> void:
	_msg.text = ""
	if new_text.length() > 0 and new_text.length() < 3:
		_msg.text = "Mínimo 3 caracteres."
	elif account_manager.username_taken(new_text):
		_msg.text = "Nome já existe."
func _on_create_pressed() -> void:
	_msg.text = ""
	if _user.text.length() < 3:
		_msg.text = "Usuário muito curto."
		return
	if _pass.text == "":
		_msg.text = "Senha vazia."
		return
	if _pass.text != _confirm.text:
		_msg.text = "Senhas não conferem."
		return
	var res = account_manager.create_account(_user.text, _pass.text)
	_msg.text = res.msg
	if res.ok:
		_msg.add_theme_color_override("font_color", Color.GREEN)
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/LoginScreen.tscn")
func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
