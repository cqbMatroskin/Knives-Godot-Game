extends Node2D

var restart_overlay_scene: PackedScene = preload("res://elements/ui/restart_overlay.tscn")

@onready var knife_spawner: KnifeSpawner = $KnifeSpawner

func _ready() -> void:
	Events.game_over.connect(on_end_game)

func on_end_game() -> void:
	knife_spawner.is_enabled = false
	show_restart_screen()
	Global.reset_points()

func show_restart_screen() -> void:
	add_child(restart_overlay_scene.instantiate())
	Hud.update_hud_restart()
