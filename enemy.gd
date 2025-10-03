extends RigidBody2D
var amplitude := 5.0   # how much it moves
var speed := 2.5      # how fast it moves
var base_position: Vector2

func _ready():
	base_position = position
	#Label.text = str(score) 

func _process(delta: float) -> void:
	# Make the rock float slightly up and down
	var offset_y = sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude
	position = base_position + Vector2(0, offset_y)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		body.score -= 5
		print("Collided with rock! Player score: ", body.score)
		var score_label = body.get_node("Camera2D/CanvasLayer/Panel/Label2") as Label
		if score_label:
			score_label.text = str(body.score)
		
