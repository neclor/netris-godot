extends Node2D

const field_height = 22
const field_width = 10

const top_border = -(field_height / 2) * Block.block_size
const bottom_border = (field_height / 2 - 1) * Block.block_size
const left_border = -(field_width / 2) * Block.block_size
const right_border =(field_width / 2 - 1) * Block.block_size

const initial_coordinates = Vector2(-Block.block_size, -(field_height / 2 - 1) * Block.block_size)

const figure_names = ["i", "o", "t", "j", "l", "s", "z"]

var figure_names_bag
var next_figure_name

var locked_blocks

var figure
var figure_ghost
#var figure_next

func _ready():
	init()

func init():
	figure_names_bag = []
	locked_blocks = []

	choose_next_figure()
	creating_new_figure()

func _on_game_timer_timeout():
	if !figure.check_move_down(locked_blocks):
		locked_blocks.append_array(figure.blocks)
		locked_blocks = figure.check_line_fill(locked_blocks, field_width)

		figure_ghost.remove_ghost()

		creating_new_figure()

func creating_new_figure():
	var choosed_figure = choose_next_figure()

	figure = Figure.new(choosed_figure, initial_coordinates, top_border, bottom_border, left_border, right_border)

	for block in figure.blocks:
		$Field.add_child(block)

	figure_ghost = Figure.new(choosed_figure, initial_coordinates, top_border, bottom_border, left_border, right_border)
	figure_ghost.change_into_ghost()
	figure_ghost.update_ghost_coordinates(figure.coordinates, figure.blocks_coordinates, locked_blocks)

	for block in figure_ghost.blocks:
		$Field.add_child(block)

func choose_next_figure():
	if figure_names_bag == []:
		figure_names_bag = figure_names.duplicate()

	var new_figure_name_index = randi_range(0, len(figure_names_bag) - 1)
	var current_figure_name = next_figure_name

	next_figure_name = figure_names_bag[new_figure_name_index]
	figure_names_bag.remove_at(new_figure_name_index)

	return current_figure_name

















var just_touch
var touch_position 

func _input(event):

	if Input.is_action_pressed("Down"):
		figure.check_move_down(locked_blocks)

	if Input.is_action_pressed("Right"):
		figure.check_move_right(locked_blocks)
		figure_ghost.update_ghost_coordinates(figure.coordinates, figure.blocks_coordinates, locked_blocks)

	if Input.is_action_pressed("Left"):
		figure.check_move_left(locked_blocks)
		figure_ghost.update_ghost_coordinates(figure.coordinates, figure.blocks_coordinates, locked_blocks)

	if Input.is_action_just_pressed("Rotation"):
		figure.check_move_rotation(locked_blocks, 1)
		figure_ghost.update_ghost_coordinates(figure.coordinates, figure.blocks_coordinates, locked_blocks)

	if Input.is_action_just_pressed("AnotherRotation"):
		figure.check_move_rotation(locked_blocks, -1)
		figure_ghost.update_ghost_coordinates(figure.coordinates, figure.blocks_coordinates, locked_blocks)

	if event is InputEventScreenTouch:
		if !event.is_pressed():
			if just_touch:
				figure.check_move_rotation(locked_blocks, 1)
				figure_ghost.update_ghost_coordinates(figure.coordinates, figure.blocks_coordinates, locked_blocks)
		just_touch = true
		touch_position = event.position

	if event is InputEventScreenDrag:
		if event.velocity.y >= 3000:
			pass

		elif event.position.y - touch_position.y >= Block.block_size:
			touch_position.y += Block.block_size
			figure.check_move_down(locked_blocks)

		if event.position.x - touch_position.x >= Block.block_size:
			touch_position.x += Block.block_size
			figure.check_move_right(locked_blocks)
			figure_ghost.update_ghost_coordinates(figure.coordinates, figure.blocks_coordinates, locked_blocks)

		elif event.position.x - touch_position.x <= -Block.block_size:
			touch_position.x -= Block.block_size
			figure.check_move_left(locked_blocks)
			figure_ghost.update_ghost_coordinates(figure.coordinates, figure.blocks_coordinates, locked_blocks)

		just_touch = false





