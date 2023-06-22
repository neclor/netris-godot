extends Node
class_name Coin

const coin_texture = preload("res://Assets/Sprites/Coin.png")

var coin

func _init():
	coin = Block.Block_scene.instantiate()

	var coin_sprite = coin.get_node("Block")
	coin_sprite.texture = coin_texture

	coin.z_index = 1

func check_collected(blocks):
	for block in blocks:
		if block.position == coin.position:
			return true

	return false

func check_available_position(locked_blocks, top_border):
	var available_positions = []

	var locked_blocks_coordinates = []

	for block in locked_blocks:
		locked_blocks_coordinates.append(block.position)

	for block in locked_blocks:
		var block_above = Vector2(block.position.x, block.position.y - Block.block_size)
		var block_above_2 = Vector2(block.position.x, block.position.y - 2 * Block.block_size)

		if block_above.y >= top_border and !(block_above in locked_blocks_coordinates) and !(block_above_2 in locked_blocks_coordinates):
			available_positions.append(block_above)

	if len(available_positions) != 0:
		coin.position = available_positions[randi_range(0, len(available_positions) - 1)]
		return true

	return false

func remove():
	coin.queue_free()
