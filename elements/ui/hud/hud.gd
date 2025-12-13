extends CanvasLayer

@onready var knives_counter: VBoxContainer = %KnivesCounter
@onready var home_button: Button = %HomeButton
@onready var score_label: Label = %ScoreLabel
@onready var stage_label: Label = %StageLabel
@onready var stage_counter: HBoxContainer = %StageCounter
@onready var apples_label: Label = %ApplesLabel

func _ready() -> void:
	Events.location_changed.connect(update_hud_location)
	Events.points_changed.connect(update_points)
	Events.apples_amount_changed.connect(update_apples_count)
	update_apples_count(Global.apples_amount)
	update_hud_location(Events.LOCATIONS.START)

func _on_home_button_pressed() -> void:
	Events.location_changed.emit(Events.LOCATIONS.START)

# Функция обновления HUD в зависимости от текущей сцены
func update_hud_location(location: Events.LOCATIONS) -> void:
	match location:
		Events.LOCATIONS.START:
			hide_ui_elements([knives_counter, home_button, score_label, stage_label, stage_counter])
		Events.LOCATIONS.GAME:
			show_ui_elements([knives_counter, score_label, stage_label, stage_counter])
			hide_ui_elements([home_button])
		Events.LOCATIONS.SHOP:
			show_ui_elements([home_button])
			hide_ui_elements([knives_counter, score_label, stage_label, stage_counter])

# Скрыть UI элементы
func hide_ui_elements(elements: Array[Node]) -> void:
	for element in elements:
		if element.visible:
			element.hide()

# Показать UI элементы
func show_ui_elements(elements: Array[Node]) -> void:
	for element in elements:
		if element.hide:
			element.show()

# HUD перезапуска
func update_hud_restart() -> void:
	show_ui_elements([home_button])
	hide_ui_elements([knives_counter, score_label, stage_label, stage_counter])

# Обновление счётчика очков
func update_points(points: int) -> void:
	score_label.text = str(points)

func update_apples_count(amount: int) -> void:
	apples_label.text = str(amount)
