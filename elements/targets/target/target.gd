extends CharacterBody2D
class_name Target

const GENERATION_LIMIT: int = 100
const KNIFE_POSITION: Vector2 = Vector2(0, 180)
const APPLE_POSITION: Vector2 = Vector2(0, 176)
const MIN_ANGULAR_DISTANCE: float = 0.96
const EXPLOSION_TIME: float = 1.5

var knife_scene: PackedScene = load("res://elements/knife/knife.tscn")
var apple_scene: PackedScene = load("res://elements/apple/apple.tscn")

var speed: float = PI

@onready var items_container: Node2D = $ItemsContainer
@onready var sprite: Sprite2D = $Sprite2D
@onready var knife_particles: CPUParticles2D = $KnifeParticles2D
@onready var targets_particles: Array[CPUParticles2D] = [$TargetParticles2D, $TargetParticles2D2, $TargetParticles2D3]

func take_damage() -> void:
	print(Global.knives_amount)
	if Global.knives_amount == 0:
		explode_target()

func explode_target() -> void:
	sprite.hide()
	items_container.hide()
	
	var tween := create_tween()
	
	for target_part in targets_particles:
		tween.parallel().tween_property(target_part, "modulate", Color("ffffff00"),EXPLOSION_TIME)
		target_part.emitting = true
	# Поворот узла частиц для выстрела ножей вверх
	knife_particles.rotation = -rotation
	knife_particles.emitting = true
	tween.parallel().tween_property(knife_particles, "modulate", Color("ffffff00"),EXPLOSION_TIME)
	await tween.finished
	Global.change_stage(Global.current_stage + 1)

## Вращение мишени
func _physics_process(delta: float) -> void:
	# Добавление количества радиан
	rotation += speed * delta

# Добавить предметы в контейнер
func create_rotating_object(object: Node2D, object_rotation: float) -> void:
	var pivot := Node2D.new()
	pivot.rotate(object_rotation)
	pivot.add_child(object)
	items_container.add_child(pivot)

# Добавить предметы и задать позицию
func add_default_items(knives: int, apples: int) -> void:
	var occupied = add_items(knife_scene, KNIFE_POSITION, knives)
	add_items(apple_scene, APPLE_POSITION, apples, occupied)

func add_items(scene: PackedScene, object_position: Vector2, count: int, occupied_rotations: Array = []) -> Array:
	for i in range(count):
		var pivot_rotation = get_free_random_rotation(occupied_rotations)
		if pivot_rotation == null:
			break
		occupied_rotations.append(pivot_rotation)
		var object: Node = scene.instantiate()
		object.position = object_position
		create_rotating_object(object, pivot_rotation)
	return occupied_rotations

# Поиск случайной свободной точки на окружности
func get_free_random_rotation(occupied_rotations: Array, generation_attempts: int = 0):
	if generation_attempts >= GENERATION_LIMIT:
		return NAN
	# Случайная точка на окружности
	# Полный круг (360 градусов) равен 2π радиан
	var random_rotation = Global.rng.randf_range(MIN_ANGULAR_DISTANCE / 2, TAU - (MIN_ANGULAR_DISTANCE / 2))
	
	for  occupied in occupied_rotations:
		if random_rotation <= occupied + MIN_ANGULAR_DISTANCE / 2.0 and random_rotation >= occupied - MIN_ANGULAR_DISTANCE / 2.0:
			return get_free_random_rotation(occupied_rotations, generation_attempts + 1)
	return random_rotation
