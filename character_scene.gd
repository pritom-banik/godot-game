extends RigidBody2D

@onready var animatedspite_2d: AnimatedSprite2D = $animatedspite2d
@onready var label: Label = $Camera2D/CanvasLayer/Panel/Label2

@export var thrust := 500.0       # movement strength
@export var torque_force := 0.0  # how strong the rotation is

var score: int = 0   # starting score (you can set any value)

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	animatedspite_2d.animation = "default"

	# Linear thrust (forward/back/left/right)
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
		animatedspite_2d.animation="floating"
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
		animatedspite_2d.animation="floating"
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
		animatedspite_2d.animation="floating"
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
		animatedspite_2d.animation="floating"

	if input_vector != Vector2.ZERO:
		apply_impulse(input_vector.normalized() * thrust * delta)
		
	
	# Rotation control (slow turning)
	#if Input.is_action_pressed("ui_left"):
		#apply_torque_impulse(-torque_force * delta)
	#if Input.is_action_pressed("ui_right"):
		#apply_torque_impulse(torque_force * delta)
	#if Input.is_action_pressed("ui_left"):
		#angular_velocity -= torque_force * delta
	#elif Input.is_action_pressed("ui_right"):
		#angular_velocity += torque_force * delta

	var isleft = input_vector.x < 0
	animatedspite_2d.flip_h = isleft
	
	var isup = input_vector.y < 0
	animatedspite_2d.flip_v = isup
