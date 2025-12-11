extends Node2D
class_name KnifeSpawner

const knife_scene := preload('res://elements/knife/knife.tscn')
var is_enabled: bool = true

@onready var knife := $Knife
@onready var timer := $Timer

func create_new_knife() -> void:
	knife = knife_scene.instantiate()
	add_child(knife)

func _input(event: InputEvent) -> void:
	if Global.knives_amount > 0 and \
	is_enabled and \
	event is InputEventScreenTouch and \
	event.is_pressed() and \
	timer.time_left <= 0:
		knife.throw()
		Global.knives_decrease()
		timer.start()

func _on_timer_timeout() -> void:
		create_new_knife()
