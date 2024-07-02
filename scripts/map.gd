extends Node2D

var gold_count_as_integer = 50

@onready var gold_label = $GoldCount

func _ready():
	call_deferred("_initialize_gold_label")

func _initialize_gold_label():
	if gold_label != null:
		gold_label.text = str(Map.gold_count_as_integer)
	else:
		print("GoldCount node is null!")

func _on_texture_button_pressed():
	Boss.which_boss = 1 # Spider boss
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_texture_button_2_pressed():
	if 1 in CompletedLevels.completed_levels:
		Boss.which_boss = 2 # Vampire boss
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_texture_button_2_mouse_entered():
	if !(1 in CompletedLevels.completed_levels):
		$TextureButton2/Label.visible = true

func _on_texture_button_2_mouse_exited():
	$TextureButton2/Label.visible = false
