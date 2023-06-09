extends Node2D

const field_height = 22
const field_width = 10

var top_border = Figure.block_size * 2
var bottom_border = Figure.block_size * (field_height - 3)
var left_border = 0
var right_border = Figure.block_size * (field_width  - 1)

func _ready():
	init()

func init():
	pass

func _on_game_timer_timeout():
	if Figure.figure_blocks == []:
		var figure_blocks = Figure.instantiate_figure()

		for i in len(figure_blocks):
			$Field.add_child(figure_blocks[i])

		Figure.update_blocks_coordinates()

	else:
		Figure.move_down()


func _on_start_button_pressed():
	pass
	#var block = Block_scene.instantiate()
	#var Block_sprite = block.get_node("Block")
	#Block.change_block_color(Block_sprite)
	#$Field.add_child(Block_scene.instantiate())
	#block.position = Vector2(200, 200)
	#Block.change_block_color(Block_sprite)
	#$Field.add_child(block)
	#Figure.move_down()
