extends Control
@onready var _user := $VBox/VBoxContainer/UserEdit
@onready var _pass := $VBox/VBoxContainer/PassEdit
@onready var _msg  := $VBox/VBoxContainer/MsgLabel
@onready var _back_btn := $VBox/VBoxContainer/BackBtn
var account_manager = AccountManager.new()

func _ready() -> void:
	_back_btn.pressed.connect(_on_BackBtn_pressed)

func _on_LoginBtn_pressed() -> void:
	var res := account_manager.login(_user.text, _pass.text)
	_msg.text = res.msg
	if res.ok:
		get_tree().change_scene_to_file("res://scenes/HomeScreen.tscn")

func _on_BackBtn_pressed() -> void:
	# Change scene to the title screen
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
