extends Actor

export var stomp_impulse: = 600.0

func get_direction() -> Vector2:
	return Vector2(
		get_horizontal_direction(),
		get_vertical_direction()
	)

func get_horizontal_direction() -> float:
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func get_vertical_direction() -> float:
	return -Input.get_action_strength("ui_up") if is_on_floor() and Input.is_action_just_pressed("ui_up") else 0.0

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool
) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity

func _physics_process(_delta: float) -> void:
	var direction := get_direction()
	var is_jump_interrupted := false
	
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)
