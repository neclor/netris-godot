extends Node2D

@onready var BlockI = preload("res://Scenes/Blocks/BlockI.tscn")
@onready var BlockO = preload("res://Scenes/Blocks/BlockO.tscn")
@onready var BlockT = preload("res://Scenes/Blocks/BlockT.tscn")
@onready var BlockL = preload("res://Scenes/Blocks/BlockL.tscn")
@onready var BlockJ = preload("res://Scenes/Blocks/BlockJ.tscn")
@onready var BlockS = preload("res://Scenes/Blocks/BlockS.tscn")
@onready var BlockZ = preload("res://Scenes/Blocks/BlockZ.tscn")

const game_field_width = 10
const game_field_height = 20

const cell_size = 64

const left_border = -cell_size * game_field_width / 2
const right_border = cell_size * (game_field_width / 2 - 1)
const bottom_border = cell_size * (game_field_height / 2 - 1)
const matrix_center = Vector2(-cell_size, -cell_size * (game_field_height / 2))

@onready var tetromino_I = [BlockI, Vector2(-cell_size, 0), Vector2(0, 0), Vector2(cell_size, 0), Vector2(cell_size * 2, 0)]
@onready var tetromino_O = [BlockO, Vector2(0, 0), Vector2(cell_size, 0), Vector2(cell_size, cell_size), Vector2(0, cell_size)]
@onready var tetromino_T = [BlockT, Vector2(-cell_size, 0), Vector2(0, 0), Vector2(0, cell_size), Vector2(cell_size, 0)]
@onready var tetromino_L = [BlockL, Vector2(-cell_size, cell_size), Vector2(-cell_size, 0), Vector2(0, 0), Vector2(cell_size, 0)]
@onready var tetromino_J = [BlockJ, Vector2(-cell_size, 0), Vector2(0, 0), Vector2(cell_size, 0), Vector2(cell_size, cell_size)]
@onready var tetromino_S = [BlockS, Vector2(-cell_size, cell_size), Vector2(0, cell_size), Vector2(0, 0), Vector2(cell_size, 0)]
@onready var tetromino_Z = [BlockZ, Vector2(-cell_size, 0), Vector2(0, 0), Vector2(0, cell_size), Vector2(cell_size, cell_size)]
@onready var tetromino_info = [tetromino_I, tetromino_O, tetromino_T, tetromino_L, tetromino_J, tetromino_S, tetromino_Z]

const speed_multiplier = 0.95
const max_pressed_ticks = 30

var left_button_pressed
var left_button_pressed_ticks
var down_button_pressed
var down_button_pressed_ticks
var right_button_pressed
var right_button_pressed_ticks

var speed
var paused
var game_over

var score

var matrix_coords
var blocks
var blocks_relative_coords
var fallen_blocks
var fallen_blocks_coords

var next_tetromino

var player_name

func _on_ready():
	player_name = ''

	init()

	restart()

func init():
	speed = 1
	paused = true
	game_over = true

	$GameTimer.wait_time = speed

	score = 0

	matrix_coords = matrix_center
	blocks = []
	blocks_relative_coords = []
	fallen_blocks = []
	fallen_blocks_coords = []

	next_tetromino = randi_range(0, len(tetromino_info) - 1)

	left_button_pressed = false
	left_button_pressed_ticks = 0
	down_button_pressed = false
	down_button_pressed_ticks = 0
	right_button_pressed = false
	right_button_pressed_ticks = 0

	change_interface_size()

	$GameOverPanel.visible = false
	$GameOverPanel/InputPanel.visible = false
	
	$ScoreLabel.text = "Score: " + str(score)
	$SpeedLabel.text = "Speed: " + str(snapped(1 / speed, 0.001))

func change_interface_size():
	const intrface_width = 16
	const intrface_height = 26
	
	var window_size = get_viewport().size
	var window_center = Vector2(window_size.x / 2, window_size.y / 2)
	var interface_scale = float(min(window_size.x / intrface_width, window_size.y / intrface_height)) / cell_size

	$GameField.position = window_center
	$GameField.scale /= $GameField.scale 
	$GameField.scale *= interface_scale

	$SpeedLabel.position = Vector2(window_center.x - cell_size * interface_scale * 5, window_center.y - cell_size * interface_scale * 11.5)
	$SpeedLabel.size = Vector2(cell_size * interface_scale * 2, cell_size * interface_scale)
	$SpeedLabel.add_theme_font_size_override("font_size", cell_size * interface_scale / 2)

	$ScoreLabel.position = Vector2(window_center.x + cell_size * interface_scale * 2, window_center.y - cell_size * interface_scale * 11.5)
	$ScoreLabel.size = Vector2(cell_size * interface_scale * 2, cell_size * interface_scale)
	$ScoreLabel.add_theme_font_size_override("font_size", cell_size * interface_scale / 2)

	$StartTextureButton.position = Vector2(window_center.x - cell_size * interface_scale * (intrface_width - 1) / 2, window_center.y - cell_size * interface_scale * (intrface_height - 1) / 2)
	$StartTextureButton.size = Vector2(cell_size * interface_scale * 2, cell_size * interface_scale * 2)
	$StartTextureButton.add_theme_font_size_override("font_size", cell_size * interface_scale)

	$LeftButton.position = Vector2(window_center.x - cell_size * interface_scale * 8, window_center.y - cell_size * interface_scale * 10)
	$LeftButton.size = Vector2(cell_size * interface_scale * 5, cell_size * interface_scale * 20)
	$LeftButton.add_theme_font_size_override("font_size", cell_size * interface_scale)

	$TurnButton.position = Vector2(window_center.x - cell_size * interface_scale * 3, window_center.y - cell_size * interface_scale * 10)
	$TurnButton.size = Vector2(cell_size * interface_scale * 6, cell_size * interface_scale * 20)
	$TurnButton.add_theme_font_size_override("font_size", cell_size * interface_scale)

	$RightButton.position = Vector2(window_center.x + cell_size * interface_scale * 3, window_center.y - cell_size * interface_scale * 10)
	$RightButton.size = Vector2(cell_size * interface_scale * 5, cell_size * interface_scale * 20)
	$RightButton.add_theme_font_size_override("font_size", cell_size * interface_scale)

	$DownButton.position = Vector2(window_center.x - cell_size * interface_scale * 8, window_center.y + cell_size * interface_scale * 10)
	$DownButton.size = Vector2(cell_size * interface_scale * 16, cell_size * interface_scale * 3)
	$DownButton.add_theme_font_size_override("font_size", cell_size * interface_scale)

	$NextTetrominoPanel.position = Vector2(window_center.x - cell_size * interface_scale, window_center.y - cell_size * interface_scale * (intrface_height - 1) / 2)
	$NextTetrominoPanel.size = Vector2(cell_size * interface_scale * 2, cell_size * interface_scale * 2)

	$NextTetrominoPanel/NextTetrominoPicture.position = Vector2(0, 0)
	$NextTetrominoPanel/NextTetrominoPicture.size = Vector2(cell_size * interface_scale * 2, cell_size * interface_scale * 2)

	$GameOverPanel.position = Vector2(window_center.x - cell_size * interface_scale * 3, window_center.y - cell_size * interface_scale * 8)
	$GameOverPanel.size = Vector2(cell_size * interface_scale * 6, cell_size * interface_scale * 4)

	$GameOverPanel/GameOverLabel.position = Vector2(0, 0)
	$GameOverPanel/GameOverLabel.size = Vector2(cell_size * interface_scale * 6, cell_size * interface_scale * 4)
	$GameOverPanel/GameOverLabel.add_theme_font_size_override("font_size", cell_size * interface_scale)

	$GameOverPanel/InputPanel.position = Vector2(0, cell_size * interface_scale * 6)
	$GameOverPanel/InputPanel.size = Vector2(cell_size * interface_scale * 6, cell_size * interface_scale * 4)

	$GameOverPanel/InputPanel/InputLineEdit.position = Vector2(cell_size * interface_scale * 0.5, cell_size * interface_scale)
	$GameOverPanel/InputPanel/InputLineEdit.size = Vector2(cell_size * interface_scale * 5, cell_size * interface_scale * 1)
	$GameOverPanel/InputPanel/InputLineEdit.add_theme_font_size_override("font_size", cell_size * interface_scale * 0.5)

	$GameOverPanel/InputPanel/InputButton.position = Vector2(cell_size * interface_scale * 2, cell_size * interface_scale * 2.5)
	$GameOverPanel/InputPanel/InputButton.size = Vector2(cell_size * interface_scale * 2, cell_size * interface_scale)
	$GameOverPanel/InputPanel/InputButton.add_theme_font_size_override("font_size", cell_size * interface_scale * 0.5)

func _on_game_timer_timeout():
	if blocks == []:
		var tetromino
		var block_color

		left_button_pressed_ticks = 0
		down_button_pressed_ticks = 0
		right_button_pressed_ticks = 0

		tetromino = tetromino_info[new_tetromino()]
		blocks_relative_coords = tetromino.slice(1).duplicate()

		block_color = tetromino[0];
		blocks = [block_color.instantiate(), block_color.instantiate(), block_color.instantiate(), block_color.instantiate()]
		for i in len(blocks_relative_coords):
			$GameField.add_child(blocks[i])

		update_coords()

	elif down_button_pressed_ticks < max_pressed_ticks:
		move_down()

func _on_pressed_timer_timeout():
	if down_button_pressed:
		if down_button_pressed_ticks >= max_pressed_ticks:
			move_down()
		else:
			down_button_pressed_ticks += 1

	if left_button_pressed:
		if left_button_pressed_ticks >= max_pressed_ticks:
			move_left()
		else:
			left_button_pressed_ticks += 1

	if right_button_pressed:
		if right_button_pressed_ticks >= max_pressed_ticks:
			move_right()
		else:
			right_button_pressed_ticks += 1

func restart():
	if blocks != []:
		for block in blocks:
			block.queue_free()

	for fallen_block in fallen_blocks:
		fallen_block.queue_free()

	init()

	$StartTextureButton.texture_normal = load("res://Assets/PauseButton.png")

	paused = false
	game_over = false

	$GameTimer.start()
	$PressedTimer.start()

func pause():
	if $GameTimer.is_stopped():
		paused = false
		$GameTimer.start()
		$PressedTimer.start()
		$StartTextureButton.texture_normal = load("res://assets/PauseButton.png")

	else:
		paused = true
		$GameTimer.stop()
		$PressedTimer.stop()
		$StartTextureButton.texture_normal = load("res://Assets/StartButton.png")

func new_tetromino():
	var new_tetromino
	var present_tetromino
	
	while true:
		new_tetromino = randi_range(0, len(tetromino_info) - 1)

		if new_tetromino != next_tetromino:
			present_tetromino = next_tetromino
			next_tetromino = new_tetromino

			$NextTetrominoPanel/NextTetrominoPicture.texture = load("res://Assets/Tetromino%d.png" % next_tetromino)

			return present_tetromino

func update_score(number_filled_lines):
	var new_points = 0

	for i in number_filled_lines:
		new_points = new_points * 2 + 100

	score += new_points

	$ScoreLabel.text = "Score: " + str(score)

func change_speed(number_filled_lines):
	const max_speed = 0.01

	speed *= speed_multiplier ** number_filled_lines

	if speed < max_speed:
		speed = max_speed

	$GameTimer.wait_time = speed
	$SpeedLabel.text = "Speed: " + str(snapped(1 / speed, 0.001))

func update_coords():
	for i in len(blocks):
		blocks[i].position = matrix_coords + blocks_relative_coords[i]

func check_game_over():
	for fallen_block in fallen_blocks:
		if fallen_block.position.y == -1 * cell_size * (game_field_height / 2 - 1):
			paused = true
			game_over = true

			$GameTimer.stop()
			$PressedTimer.stop()

			add_record_in_table()

			$StartTextureButton.texture_normal = load("res://assets/StartButton.png")
			$GameOverPanel.visible = true

			break

func add_record_in_table():
	if score != 0:
		if player_name == '':
			$GameOverPanel/InputPanel.visible = true

		else:
			$GameOverPanel/InputPanel/HTTPRequest.request("https://neclor.ru/Records?name=%s&score=%d" % [player_name, score], \
				[], HTTPClient.METHOD_POST, '{}')

func check_filled_lines():
	var last_blocks_coords_y = []
	var tested_line_indexes
	var block_index_in_tested_line
	var filled_lines_indexes = []
	var filled_lines_coords_y = []
	var number_filled_lines

	for block in blocks:
		if (block.position.y in last_blocks_coords_y) == false:
			last_blocks_coords_y.append(block.position.y)

	for block_coord_y in last_blocks_coords_y:
		tested_line_indexes = []

		for cell in game_field_width:
			block_index_in_tested_line = fallen_blocks_coords.find(Vector2(left_border + cell * cell_size, block_coord_y))
			if block_index_in_tested_line != -1:
				tested_line_indexes.append(block_index_in_tested_line)

		if len(tested_line_indexes) == game_field_width:
			filled_lines_indexes.append_array(tested_line_indexes)
			filled_lines_coords_y.append(block_coord_y)

	number_filled_lines = len(filled_lines_coords_y)

	if number_filled_lines != 0:
		remove_filled_lines(filled_lines_indexes)
		move_fallen_blocks_down(filled_lines_coords_y)

		update_score(number_filled_lines)
		change_speed(number_filled_lines)

func remove_filled_lines(filled_lines_indexes):
	filled_lines_indexes.sort()
	filled_lines_indexes.reverse()

	for block_index in filled_lines_indexes:
		fallen_blocks[block_index].queue_free()
		fallen_blocks.remove_at(block_index)
		fallen_blocks_coords.remove_at(block_index)

func move_fallen_blocks_down(filled_lines_coords_y):
	filled_lines_coords_y.sort()

	for full_line_coord_y in filled_lines_coords_y:
		for i in len(fallen_blocks):
			if fallen_blocks[i].position.y <= full_line_coord_y:
				fallen_blocks[i].position.y += cell_size
				fallen_blocks_coords[i].y += cell_size

func move_left():
	if blocks != [] and !paused:
		if check_move_left():
			matrix_coords.x -= cell_size

			update_coords()

func check_move_left():
	var next_coords

	for block in blocks:
		next_coords = block.position
		next_coords.x -= cell_size

		if next_coords.x < left_border or next_coords in fallen_blocks_coords:
			return false

	return true

func turn ():
	if blocks != [] and !paused:
		var next_coords

		if check_turn():
			for i in len(blocks_relative_coords):
				next_coords = blocks_relative_coords[i].x
				blocks_relative_coords[i].x = -1 * blocks_relative_coords[i].y
				blocks_relative_coords[i].y = next_coords

		update_coords()

func check_turn():
	var next_coords

	for block_relative_coord in blocks_relative_coords:
		next_coords = matrix_coords + Vector2(block_relative_coord.y * -1, block_relative_coord.x)

		if next_coords.x < left_border or next_coords.x > right_border or next_coords.y > bottom_border or next_coords in fallen_blocks_coords:
			return false

	return true

func move_down():
	if blocks != [] and !paused:
		if check_move_down():
			matrix_coords.y += cell_size

			update_coords()

		else:
			fallen_blocks.append_array(blocks)
			for block in blocks:
				fallen_blocks_coords.append(block.position)

			check_filled_lines()
			check_game_over()

			matrix_coords = matrix_center
			blocks = []

func check_move_down():
	var next_coords

	for block in blocks:
		next_coords = block.position
		next_coords.y += cell_size

		if next_coords.y > bottom_border or next_coords in fallen_blocks_coords:
			return false	

	return true

func move_right():
	if blocks != [] and !paused:
		if check_move_right():
			matrix_coords.x += cell_size

			update_coords()

func check_move_right():
	var next_coords

	for block in blocks:
		next_coords = block.position
		next_coords.x += cell_size
		
		if next_coords.x > right_border or next_coords in fallen_blocks_coords:
			return false

	return true

func _on_start_texture_button_pressed():
	if game_over:
		restart()
	else:
		pause()

func _on_turn_button_pressed():
	turn()

func _on_left_button_button_down():
	move_left()

	left_button_pressed = true

func _on_left_button_button_up():
	left_button_pressed = false
	left_button_pressed_ticks = 0

func _on_down_button_button_down():
	move_down()

	down_button_pressed = true

func _on_down_button_button_up():
	down_button_pressed = false
	down_button_pressed_ticks = 0

func _on_right_button_button_down():
	move_right()

	right_button_pressed = true

func _on_right_button_button_up():
	right_button_pressed = false
	right_button_pressed_ticks = 0

func _input(event):
	if Input.is_action_just_pressed("pause"):
		pause()

	if Input.is_action_just_pressed("left"):
		move_left()

		left_button_pressed = true

	if Input.is_action_just_released("left"):
		left_button_pressed = false
		left_button_pressed_ticks = 0

	if Input.is_action_just_pressed("turn"):
		turn()

	if Input.is_action_just_pressed("down"):
		move_down()

		down_button_pressed = true

	if Input.is_action_just_released("down"):
		down_button_pressed = false
		down_button_pressed_ticks = 0

	if Input.is_action_just_pressed("right"):
		move_right()

		right_button_pressed = true

	if Input.is_action_just_released("right"):
		right_button_pressed = false
		right_button_pressed_ticks = 0

func _on_input_button_pressed():
	player_name = $GameOverPanel/InputPanel/InputLineEdit.text
	add_record_in_table()

	restart()
