extends RefCounted
class_name Stage

var knives: int = 0
var apples: int = 0
var target_scene_resources: PackedScene

func _init(_target_scene: PackedScene = preload("res://elements/targets/target/target.tscn")) -> void:
	target_scene_resources = _target_scene
