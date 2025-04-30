@tool # permite editar em tempo‑real no Inspector
class_name Card
extends Resource  

@export var id: String                       # ID único por set
@export var name: String                     # Nome da carta
@export var card_set: String 
@export var cost: int = 0                    # Mana/energia
@export var type: String                     # Creature, Spell, Rune…
@export var description: String = ""          # Texto de regra
@export var image_path: String = "res://assets/cards/default.png"
@export var rarity: String = "common"         # common/uncommon/rare/legendary
# --- Atributos específicos de criatura (opcionais) ---
@export var attack: int = 0
@export var toughness: int = 0
# --- Lista de efeitos (strings ou Resources Effect) ---
@export var effects: Array[String] = []

# Campos de runtime (não exportados)
var unique_id: String = ""   # gerado ao instanciar in‑game
var owner_id: int = -1        # player network ID
var location: String = "deck" # deck, hand, battlefield, graveyard

func _init() -> void:
	if unique_id == "":
		unique_id = _generate_unique_id()

# ----------------------- Regras básicas -----------------------------
func can_play(player, game) -> bool:
	if player == null or game == null:
		return false
	if player != game.current_player:
		return false
	if player.mana < cost:
		return false
	if location != "hand":
		return false
	return true

func play(player, game, target = null) -> bool:
	# Subclasses/efeitos específicos devem sobrescrever.
	return true

func requires_target() -> bool:
	return false

# ---------------------- Utilidades ----------------------------------
func to_dict() -> Dictionary:
	return {
		unique_id = unique_id,
		id = id,
		name = name,
		card_set = card_set,
		cost = cost,
		type = type,
		description = description,
		image_path = image_path,
		rarity = rarity,
		attack = attack,
		toughness = toughness,
		location = location,
		owner_id = owner_id,
	}

func _generate_unique_id() -> String:
	return str(Time.get_unix_time_from_system(), "_", randi())
