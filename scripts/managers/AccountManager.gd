# AccountManager.gd  –  Godot 4.4 / GDScript 2.0
class_name AccountManager
extends Node

const SAVE_PATH := "user://accounts.json"
var _accounts: Dictionary = {}      # username → { username, password }
var _current_user: String = ""      # username da sessão

# ----------------– Carregar / salvar -----------------
func _ready() -> void:
	_load_accounts()

func _load_accounts() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_accounts = {}
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f:
		_accounts = JSON.parse_string(f.get_as_text()) as Dictionary
		f.close()

func _save_accounts() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(_accounts))
		f.close()

# ----------------– API pública -----------------------
func username_taken(username: String) -> bool:
	return _accounts.has(username)

func create_account(username: String, password: String) -> Dictionary:
	if username.length() < 3:
		return { "ok": false, "msg": "Usuário precisa de 3+ caracteres." }
	if username_taken(username):
		return { "ok": false, "msg": "Nome já em uso." }
	_accounts[username] = { "username": username, "password": password }
	_save_accounts()
	return { "ok": true, "msg": "Conta criada!" }

func login(username: String, password: String) -> Dictionary:
	if not username_taken(username):
		return { "ok": false, "msg": "Usuário não encontrado." }
	if _accounts[username].password != password:
		return { "ok": false, "msg": "Senha incorreta." }
	_current_user = username
	return { "ok": true, "msg": "Login OK!" }

func logout() -> void:
	_current_user = ""

func is_logged() -> bool:
	return _current_user != ""

func current_username() -> String:
	return _current_user
