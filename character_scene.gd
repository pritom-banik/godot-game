extends RigidBody2D

@export var thrust := 500.0       # movement strength
@export var torque_force := 0.0  # how strong the rotation is

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	# Linear thrust (forward/back/left/right)
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1

	if input_vector != Vector2.ZERO:
		apply_impulse(input_vector.normalized() * thrust * delta)

	# Rotation control (slow turning)
	if Input.is_action_pressed("ui_left"):
		apply_torque_impulse(-torque_force * delta)
	if Input.is_action_pressed("ui_right"):
		apply_torque_impulse(torque_force * delta)
	if Input.is_action_pressed("ui_left"):
		angular_velocity -= torque_force * delta
	elif Input.is_action_pressed("ui_right"):
		angular_velocity += torque_force * delta
