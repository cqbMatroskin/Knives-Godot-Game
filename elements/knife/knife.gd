extends CharacterBody2D
class_name Knife

enum State { IDLE, FLY_TO_TARGET, FLY_AWAY }

var state: State = State.IDLE

var fly_away_direction := Vector2.DOWN

const speed := 4500.0
const fly_away_speed := 1000.0
const fly_away_rotation_speed := 1500.0
const fly_away_deviation := PI / 4.0

 # Движение ножа и возврат коллизии
func _physics_process(delta: float) -> void:
	match state:
		State.FLY_AWAY:
			global_position += fly_away_direction * fly_away_speed * delta
			rotation += fly_away_rotation_speed * delta
		State.FLY_TO_TARGET:
			var collision := move_and_collide(Vector2.UP * speed * delta)
			if collision:
				handle_collision(collision)

# Обработчик коллизии
func handle_collision(collision: KinematicCollision2D) -> void:
	var collider := collision.get_collider()
	if collider is Target:
		add_knife_to_target(collider)
		change_state(State.IDLE)
		collider.take_damage()
		Global.add_point()
	if collider is Knife:
		throw_away(collision.get_normal())
		Events.game_over.emit()

# Добавление ножа в контейнер
func add_knife_to_target(target: Target) -> void:
	self.reparent(target.items_container, true)

func throw() -> void:
	change_state(State.FLY_TO_TARGET)

# Отбрасывание ножа при попадании в другой нож
func throw_away(direction: Vector2) -> void:
	# Рандомный угол отклонения
	var direction_deviation: float = Global.rng.randf_range(-fly_away_deviation, fly_away_deviation)
	# Задаём направление
	fly_away_direction = direction.rotated(direction_deviation)
	change_state(State.FLY_AWAY)

func change_state(new_state: State) -> void:
	state = new_state
