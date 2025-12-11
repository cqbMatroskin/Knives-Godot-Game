extends Node

const location_to_scene = {
	Events.LOCATIONS.GAME: preload("res://scenes/game/game.tscn"),
	Events.LOCATIONS.START: preload("res://scenes/start_screen/start_screen.tscn"),
	Events.LOCATIONS.SHOP: preload("res://scenes/knife_shop/knife_shop.tscn")
}

const SAVE_GAME_FILE: String = "user://savegame.save"
const SAVE_VARIABLES: Array[String] = ["apples"]

const MAX_STAGE_APPLES: int = 3
const MAX_STAGE_KNIVES: int = 2
const MIN_KNIVES: int = 5
const MAX_KNIVES: int = 8

var rng := RandomNumberGenerator.new()

var current_stage: int = 1
var points: int = 0
var knives_amount: int = 7
var apples_amount: int = 0

func _ready() -> void:
	rng.randomize()
	Events.location_changed.connect(on_location_changed)

# Изменение уровня
func change_stage(stage_num: int) -> void:
	current_stage = stage_num
	var stage: Stage = get_common_stage()
	knives_amount = rng.randi_range(MIN_KNIVES, MAX_KNIVES)
	Events.knives_amount_changed.emit(knives_amount)
	Events.stage_changed.emit(stage)

func get_common_stage() -> Stage:
	var stage: Stage = Stage.new()
	stage.apples = round(rng.randi_range(0, MAX_STAGE_APPLES)) 
	stage.knives = round(rng.randi_range(0, MAX_STAGE_KNIVES))

	return stage

# Добавить очки за поподание в мишень
func add_point() -> void:
	points += 1
	Events.points_changed.emit(points)

# Сбросить счётчик очков
func reset_points() -> void:
	points = 0
	Events.points_changed.emit(points)

# Уменьшение количества ножей
func knives_decrease() -> void:
	knives_amount -= 1
	Events.knives_amount_changed.emit(knives_amount)

func add_apples(apples: int) -> void:
	apples_amount += apples
	Events.apples_amount_changed.emit(apples_amount)

# Переход между сценами
func on_location_changed(location: Events.LOCATIONS) -> void:
	get_tree().change_scene_to_packed(location_to_scene.get(location))

func save_game() -> void:
	pass
