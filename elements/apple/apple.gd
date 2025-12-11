extends Node2D
class_name Apple

const EXPLOSION_TIME: float = 1.5

@onready var particles: Array[CPUParticles2D] = [$AppleParticles2D, $AppleParticles2D2]
@onready var sprite: Sprite2D = $Sprite2D

var is_hited := false

func _on_area_2d_body_entered(body) -> void:
	if !is_hited:
		is_hited = true
		Global.add_apples(1)
		sprite.hide()
		var tween: Tween = create_tween()
		for part in particles:
			part.emitting = true
			tween.parallel().tween_property(part, "modulate", Color("ffffff00"),EXPLOSION_TIME)
		await tween.finished
		queue_free()
