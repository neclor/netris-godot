extends Node2D

@onready var Block_scene = preload("res://Block.tscn")

var figure_blocks = []
var blocks_relative_coords

func _ready():
	pass







func _on_game_timer_timeout():
	if figure_blocks == []:
		#figure_blocks = Figure.creation_figure()
		var figure = Figure.chose_next_figure()

		blocks_relative_coords = figure.slice(1).duplicate()

		for i in len(figure) - 1:
			var block = Block_scene.instantiate()
			var block_sprite = block.get_node("Block")
			Block.change_block_color(block_sprite, figure[0])

			figure_blocks.append(block)

		for i in len(figure_blocks):
			print(figure_blocks[i])
			$Field.add_child(figure_blocks[i])
		update_cords()
	

func update_cords():
	for i in len(figure_blocks):
		figure_blocks[i].position = blocks_relative_coords[i]




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
