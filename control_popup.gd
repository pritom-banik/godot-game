extends Control   # main scene script

@onready var popup_panel = $CanvasLayer/PopupPanel
@onready var question_label = $CanvasLayer/PopupPanel/VBoxContainer/Label
@onready var options_container = $CanvasLayer/PopupPanel/VBoxContainer/VBoxContainer
@onready var cancel_button = $CanvasLayer/PopupPanel/VBoxContainer/VBoxContainer/Cancel

var score = 0
var correct_answer_index = 0   # e.g. OptionA is correct


func _ready():
	# Example setup
	question_label.text = "Which of these are programming languages?"
	
	# Set button texts
	options_container.get_child(0).text = "Python"   # OptionA
	options_container.get_child(1).text = "Banana"   # OptionB
	options_container.get_child(2).text = "Java"     # OptionC

	# Hide popup at start
	popup_panel.hide()

	# Connect option buttons
	for i in range(options_container.get_child_count()):
		var btn = options_container.get_child(i)
		if btn != cancel_button:
			btn.pressed.connect(_on_option_pressed.bind(i))

	# Connect cancel button
	cancel_button.pressed.connect(_on_cancel_pressed)


# Show popup + pause game
func show_quiz():
	popup_panel.show()
	get_tree().paused = true


# Hide popup + resume game
func hide_quiz():
	popup_panel.hide()
	get_tree().paused = false


# Toggle popup when pressing W
func _process(delta):
	if Input.is_action_just_pressed("open_quiz"):   # "open_quiz" bound to W
		if popup_panel.visible:
			hide_quiz()
		else:
			show_quiz()


# Option pressed
func _on_option_pressed(index: int):
	if index == correct_answer_index:
		score += 1
		print("✅ Correct! Score:", score)
	else:
		print("❌ Wrong! Score:", score)

	hide_quiz()


# Cancel pressed
func _on_cancel_pressed():
	hide_quiz()
