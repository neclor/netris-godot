extends Node2D

@onready var I_Block_Sprite = preload("res://Sprites/Blocks/I_Block.png")
@onready var O_Block_Sprite = preload("res://Sprites/Blocks/O_Block.png")
@onready var T_Block_Sprite = preload("res://Sprites/Blocks/T_Block.png")
@onready var J_Block_Sprite = preload("res://Sprites/Blocks/J_Block.png")
@onready var L_Block_Sprite = preload("res://Sprites/Blocks/L_Block.png")
@onready var S_Block_Sprite = preload("res://Sprites/Blocks/S_Block.png")
@onready var Z_Block_Sprite = preload("res://Sprites/Blocks/Z_Block.png")

func change_block_color(block, block_letter):
	if block_letter == "I":
		block.texture = I_Block_Sprite

	elif block_letter == "O":
		block.texture = O_Block_Sprite

	elif block_letter == "T":
		block.texture = T_Block_Sprite

	elif block_letter == "J":
		block.texture = J_Block_Sprite

	elif block_letter == "L":
		block.texture = L_Block_Sprite

	elif block_letter == "S":
		block.texture = S_Block_Sprite

	elif block_letter == "Z":
		block.texture = Z_Block_Sprite
