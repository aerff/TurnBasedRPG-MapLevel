extends Node2D

var choice = 0

func _on_button_pressed():
	CharacterSelection.choice = 1
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_button_2_pressed():
	CharacterSelection.choice = 2
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_button_3_pressed():
	CharacterSelection.choice = 3
	get_tree().change_scene_to_file("res://scenes/map.tscn")
