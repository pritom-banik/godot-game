extends TileMapLayer

# Node references
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var popup: PopupPanel = $PopupPanel
@onready var image_rect: TextureRect = $PopupPanel/VBoxContainer/TextureRect
@onready var ok_button: Button = $PopupPanel/VBoxContainer/Cancel
@onready var desctiption: Label = $PopupPanel/VBoxContainer/ScrollContainer/Label

# Player reference (adjust path to your Player node)
@onready var player = get_node("../Player")

# State
var player_on_it := false

# Optional: NASA API key (use DEMO_KEY or your own key)
var api_key := "DEMO_KEY"

func _ready():
	randomize()  # For random selection of images

	# Connect signals
	http_request.request_completed.connect(_on_request_completed)
	ok_button.pressed.connect(_on_ok_pressed)


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):  # "ui_accept" is Enter/Return/Space by default
		popup.hide()
		get_tree().paused = false
		print("Game paused by Enter key")
	if not player:
		return  # Player node not found

	# Check if player is on a tile
	if is_player_on_tile(player.global_position):
		if not player_on_it:
			player_on_it = true
			get_tree().paused = true
			show_popup_with_image()
	else:
		player_on_it = false

# Check if the player is on a tile
func is_player_on_tile(player_pos: Vector2) -> bool:
	var tile_pos = local_to_map(player_pos)
	var tile_id = get_cell_source_id(tile_pos)
	return tile_id != -1

# Show popup and request a NASA image
func show_popup_with_image():
	print("Player on tile - showing popup")
	popup.popup_centered()  # Show popup immediately

	# Build URL
	var query := "cupola"  # Search term
	query = query.replace(" ", "%20")  # Encode spaces
	var url := "https://images-api.nasa.gov/search?q=cupola&media_type=image"
	#if api_key != "":
		#url += "&api_key=" + api_key

	# Start HTTP request
	http_request.request(url)

# Called when NASA API responds
func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		print("Error fetching NASA API: ", response_code)
		return

	#var parse_result = await JSON.parse_string(body.get_string_from_utf8())
	#if parse_result["error"] != OK:
		#print("JSON parse error")
		#return
#
	#var json_data: Dictionary = await parse_result["result"]

	var parse_result = JSON.parse_string(body.get_string_from_utf8())
	
	if parse_result == null:
		print("JSON parse error")
		return

	var json_data = parse_result

	if not json_data.has("collection") or json_data["collection"]["items"].size() == 0:
		print("No images found")
		return

	var items = json_data["collection"]["items"]
	var random_index = randi() % items.size()

	# Usually links[0] is the preview image
	var img_url = items[random_index]["links"][0]["href"]
	desctiption.text = items[random_index]["data"][0]["description"]
	print(desctiption.text)
	load_image_from_url(img_url)

# Load image from URL into TextureRect
func load_image_from_url(url: String):
	var image_loader = HTTPRequest.new()
	add_child(image_loader)

	image_loader.request_completed.connect(
		func(result, response_code, headers, body):
			if response_code == 200:
				var img = Image.new()
				var err = img.load_jpg_from_buffer(body)
				if err == OK:
					var tex = ImageTexture.create_from_image(img)
					image_rect.texture = tex
				else:
					print("Error loading image from buffer")
			else:
				print("Error fetching image: ", response_code)

			image_loader.queue_free()
	)

	image_loader.request(url)

# Hide popup when OK button is pressed
func _on_ok_pressed():
	popup.hide()
	get_tree().paused = false
