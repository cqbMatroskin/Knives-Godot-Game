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
	if is_enabled and \
	event is InputEventScreenTouch and \
	event.is_pressed() and \
	timer.is_stopped():
		knife.throw()
		timer.start()

func _on_timer_timeout() -> void:
	Global.knives_decrease()
	if Global.knives_amount <= 0:
		is_enabled = false
	if is_enabled:
		create_new_knife()
