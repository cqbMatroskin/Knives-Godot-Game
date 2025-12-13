extends Node2D

var restart_overlay_scene: PackedScene = preload("res://elements/ui/restart_overlay.tscn")

@onready var knife_spawner: KnifeSpawner = $KnifeSpawner
@onready var target_position: Marker2D = $TargetPosition

var target: Target

func _ready() -> void:
	Events.game_over.connect(on_end_game)
	Events.stage_changed.connect(change_stage)
	Global.change_stage(1)

func change_stage(stage: Stage) -> void:
	Global.save_game()
	place_target(stage)
	

func place_target(stage: Stage) -> void:
	if	target:
		target.queue_free()
	target = stage.target_scene_resources.instantiate()
	add_child(target)
	target.add_default_items(stage.knives, stage.apples)
	target.global_position = target_position.global_position

func on_end_game() -> void:
	knife_spawner.is_enabled = false
	show_restart_screen()
	Global.reset_points()

func show_restart_screen() -> void:
	add_child(restart_overlay_scene.instantiate())
	Hud.update_hud_restart()
