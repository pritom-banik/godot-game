extends Control

@onready var astronaut = $Astronaut  # Make sure your Sprite2D is named "Astronaut"

func _ready():
	randomize()
	_move_astronaut()

func _move_astronaut():
	# Pick a random spot on the screen (adjust limits for your screen size)
	var target = Vector2(randi_range(50, 700), randi_range(50, 400))
	
	# Create a tween to move astronaut smoothly
	var tween = create_tween()
	tween.tween_property(astronaut, "position", target, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# When tween finishes, call this function again (keep moving forever)
	tween.connect("finished", Callable(self, "_move_astronaut"))

func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	#$AnimationPlayer.play("fade_out")
	#await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://main-node-2d.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
