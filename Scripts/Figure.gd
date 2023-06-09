extends Node

@onready var Block_scene = preload("res://Block.tscn")

@onready var I_Figure = [Color("#00ffff"), Vector2(-block_size, 0), Vector2(0, 0), Vector2(block_size, 0), Vector2(block_size * 2, 0)]
@onready var O_Figure = [Color("#ffff"), Vector2(0, -block_size), Vector2(block_size, -block_size), Vector2(0, 0), Vector2(block_size, 0)]
@onready var T_Figure = [Color("#ff00ff"), Vector2(0, -block_size), Vector2(-block_size, 0), Vector2(0, 0), Vector2(block_size, 0)]
@onready var J_Figure = [Color("#ff7f00"), Vector2(-block_size, -block_size), Vector2(-block_size, 0), Vector2(0, 0), Vector2(block_size, 0)]
@onready var L_Figure = [Color("#0000ff"), Vector2(block_size, -block_size), Vector2(-block_size, 0), Vector2(0, 0), Vector2(block_size, 0)]
@onready var S_Figure = [Color("#00ff00"), Vector2(0, -block_size), Vector2(block_size, -block_size), Vector2(-block_size, 0), Vector2(0, 0)]
@onready var Z_Figure = [Color("#ff0000"), Vector2(-block_size, -block_size), Vector2(0, -block_size), Vector2(0, 0), Vector2(block_size, 0)]
@onready var figures = [I_Figure, O_Figure, T_Figure, J_Figure, L_Figure, S_Figure, Z_Figure]

const block_size = 32

var figure_coordinates
var blocks_coordinates
var figure_blocks
var locked_blocks

var figures_bag
var next_figure

func _ready():
	init()

func init():
	figure_coordinates = Vector2(96, 96)
	figure_blocks = []
	locked_blocks = []

	figures_bag = figures.duplicate()
	next_figure = figures_bag[randi_range(0, len(figures_bag) - 1)]

func instantiate_figure():
	var figure = chose_next_figure()

	blocks_coordinates = figure.slice(1).duplicate()

	for i in len(figure) - 1:
		var block = Block_scene.instantiate()
		var block_sprite = block.get_node("Block")

		block_sprite.material.set_shader_parameter("new_color", figure[0])

		figure_blocks.append(block)

	return figure_blocks

func update_blocks_coordinates():
	for i in len(figure_blocks):
		figure_blocks[i].position = blocks_coordinates[i] + figure_coordinates

func chose_next_figure():
	if figures_bag == []:
		figures_bag = figures.duplicate()

	var new_figure_index = randi_range(0, len(figures_bag) - 1)
	var present_figure = next_figure

	next_figure = figures_bag[new_figure_index]
	figures_bag.remove_at(new_figure_index)

	return present_figure

func check_gameover():
	for block in locked_blocks:
		if block.position.y < Main.top_border:
			#paused = true
			#game_over = true

			#$GameTimer.stop()
			#$PressedTimer.stop()

			#add_record_in_table()

			#$StartTextureButton.texture_normal = load("res://assets/StartButton.png")
			#$GameOverPanel.visible = true

			break

func check_line_fill():
	var locked_blocks_coordinates = []

	for block in locked_blocks:
		locked_blocks_coordinates.append(block.position)

	var locked_blocks_coordinate_y = []
	var block_indexes_in_filled_lines = []
	var filled_line_coordinate_y = []

	for block in figure_blocks:
		if (block.position.y in locked_blocks_coordinate_y) == false:
			locked_blocks_coordinate_y.append(block.position.y)

	for y in locked_blocks_coordinate_y:
		var filled_line_indixes = []

		for i in Main.field_width:
			var filled_line_block_index = locked_blocks_coordinates.find(Vector2(block_size * i, y))
			if filled_line_block_index != -1:
				filled_line_indixes.append(filled_line_block_index)

		if len(filled_line_indixes) == Main.field_width:
			block_indexes_in_filled_lines.append_array(filled_line_indixes)
			filled_line_coordinate_y.append(y)

	var number_filled_lines = len(filled_line_coordinate_y)
	if number_filled_lines != 0:
		erase_filled_lines(block_indexes_in_filled_lines)
		move_down_locked_bloks(filled_line_coordinate_y)

		Main.update_score(number_filled_lines)
		Main.change_speed(number_filled_lines)

func erase_filled_lines(block_indexes_in_filled_lines):
	block_indexes_in_filled_lines.sort()
	block_indexes_in_filled_lines.reverse()

	for index in block_indexes_in_filled_lines:
		locked_blocks[index].queue_free()
		locked_blocks.remove_at(index)

func move_down_locked_bloks(filled_line_coordinate_y):
	filled_line_coordinate_y.sort()

	for y in filled_line_coordinate_y:
		for i in len(locked_blocks):
			if locked_blocks[i].position.y <= y:
				locked_blocks[i].position.y += block_size

















func move_down():
	var check_move_down = check_move_down()
	if check_move_down:
		figure_coordinates += Vector2(0, block_size)
		update_blocks_coordinates()

	elif !check_move_down:
		check_line_fill()


func check_move_down():
	if figure_blocks == []:
		return null

	else:
		var locked_blocks_coordinates = []

		for block in locked_blocks:
			locked_blocks_coordinates.append(block.position)

		var next_coordinates_block

		for block in figure_blocks:
			next_coordinates_block = block.position
			next_coordinates_block.y += block_size

			if next_coordinates_block.y > Main.bottom_border or next_coordinates_block in locked_blocks_coordinates:
				return false

		return true


func move_rotation():
	pass

func check_move_rotation():
	pass
