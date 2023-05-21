extends Control

func _on_shop_button_pressed() -> void:
	Events.location_changed.emit(Events.LOCATIONS.SHOP)


func _on_play_button_pressed() -> void:
	Events.location_changed.emit(Events.LOCATIONS.GAME)
