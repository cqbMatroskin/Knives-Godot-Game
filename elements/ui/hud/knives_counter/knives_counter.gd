extends VBoxContainer

var knife_texture: Texture2D = preload("res://assets/knife_ico_2.png")

func _ready() -> void:
	Events.knives_amount_changed.connect(update_knife_counter)


func update_knife_counter(amount: int) -> void:
	print_debug(get_child_count())
	var knives_diff: int = amount - get_child_count()
	if knives_diff > 0:
		add_knives(knives_diff)
	elif knives_diff < 0:
		remove_knives(-knives_diff)

func create_knife_icon() -> TextureRect:
	var texture_rect: TextureRect = TextureRect.new()
	texture_rect.texture = knife_texture
	return texture_rect

func add_knives(amount: int) -> void:
	for i in range(amount):
		add_child(create_knife_icon())

func remove_knives(amount: int) -> void:
	for i in range(amount):
		get_child(i).queue_free()
