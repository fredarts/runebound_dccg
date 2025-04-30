class_name CardDatabase
extends Node

const CARD_DIR := "res://data/cards"
var cards: Dictionary = {}

func _ready() -> void:
	_load_cards()
	print_debug("CardDatabase: loaded %s cards" % cards.size())

func _load_cards() -> void:
	var dir := DirAccess.open(CARD_DIR)
	if dir == null:
		push_error("CardDatabase: directory not found: %s" % CARD_DIR)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		# Ignora arquivos ocultos e diretórios de navegação
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue

		if file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var res: Card = load("%s/%s" % [CARD_DIR, file_name])
			if res and res.id != "":
				cards[res.id] = res
			else:
				push_warning("CardDatabase: invalid card in %s" % file_name)
		file_name = dir.get_next()

	dir.list_dir_end()

func get_card(id: String) -> Card:
	return cards.get(id)

func get_all_cards() -> Array[Card]:
	return cards.values()

func get_cards_by_rarity(rarity: String) -> Array[Card]:
	return get_all_cards().filter(func(c): return c.rarity == rarity)

func get_random_card(rarity: String = "common") -> Card:
	var pool := get_cards_by_rarity(rarity)
	if pool.is_empty():
		return null
	return pool.pick_random()
