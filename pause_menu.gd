extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	
func pause():
	get_tree().paused = true
	visible=true
	$AnimationPlayer.play_backwards("blur")
	
func resume():
	get_tree().paused = false
	visible=false
	$AnimationPlayer.play("blur")

func testescp():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta):
	testescp()
