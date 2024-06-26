extends Node2D

var turn = 0
var boss_damage = 0
var boss_heal = 0
var boss = null
var boss_path
var level
	
# 0, 2, 4... çift sayı ise -> Boss'un turu
# 1, 3, 5... tek sayı ise -> Bizim turumuz

func _ready(): # --> Oyun başlangıcında ayarlanacak şeyler
	$PauseScreen.visible = false
	$Boss/Spider.visible = false
	$Boss/VampireBoss.visible = false
	if Boss.which_boss == 1:
		level = 1
		boss_path = $Boss/Spider
		boss_path.visible = true
		boss_damage = 8
		boss_heal = 0
	elif Boss.which_boss == 2:
		level = 2
		boss_path = $Boss/VampireBoss
		boss_path.visible = true
		boss_damage = 10
		boss_heal = 3
	if CharacterSelection.choice == 1:
		$Player/Sprite2D.texture = preload("res://assets/elementalist.png")
	elif CharacterSelection.choice == 2:
		$Player/Sprite2D.texture = preload("res://assets/knight.png")
	elif CharacterSelection.choice == 3:
		$Player/Sprite2D.texture = preload("res://assets/death.png")
	$ColorRect.visible = false
	toggle_buttons()
	$TurnLabel.visible = false
	play_turn()
	
func play_turn():
	$Timer.start(1)
	await $Timer.timeout
	if turn % 2 == 0:
		show_turn_label_text("Boss' Turn")
		$Timer.start(1)
		await $Timer.timeout
		boss_path.get_node("AnimationPlayer").play("deal_damage")
		$Player/AnimationPlayer.play("take_damage")
		boss_does_something(boss_damage, boss_heal)
		if $Player/PlayerHPBar.value <= 0:
			$ColorRect.visible = true
			return
		turn += 1
		$Timer.start(1)
		await $Timer.timeout
		show_turn_label_text("Your Turn")
		play_turn()
	else:
		toggle_buttons()
		pass
		
		
func boss_does_something(damage: int, heal: int):
	$Player/PlayerHPBar.value -= damage
	boss_path.get_node("BossHPBar").value += heal
	
func toggle_buttons():
	if $Button.disabled == false: #Basabiliyorsam hepsini disabled yap
		$Button.disabled = true
		$Button2.disabled = true
		$Button3.disabled = true
		$Button4.disabled = true
	else: # Basamıyorsam hepsini disabledlıktan çıkar
		$Button.disabled = false
		$Button2.disabled = false
		$Button3.disabled = false
		$Button4.disabled = false

func show_turn_label_text(text: String):
	$TurnLabel.visible = true
	$TurnLabel.text = text
	$Timer.start(1)
	await $Timer.timeout
	$TurnLabel.visible = false

func _on_button_pressed(): # Slash butonuna basıldığında
	$Player/AnimationPlayer.play("deal_damage")
	boss_path.get_node("AnimationPlayer").play("take_damage")
	boss_path.get_node("BossHPBar").value -= 5
	if boss_path.get_node("BossHPBar").value <= 0:
		if level in CompletedLevels.completed_levels: # Daha önce kestik
			pass
		else: # İlk defa kesiyorsak
			CompletedLevels.completed_levels.append(level)
		get_tree().change_scene_to_file("res://scenes/map.tscn")
	turn += 1
	toggle_buttons()
	play_turn()

func _on_button_2_pressed(): # Fireball butonuna basıldığında
	if $Player/PlayerManaBar.value < 15:
		pass
	else: # Yeterli manamız varsa
		$Player/AnimationPlayer.play("deal_damage")
		boss_path.get_node("AnimationPlayer").play("take_damage")
		boss_path.get_node("BossHPBar").value -= 15
		$Player/PlayerManaBar.value -= 15
		if boss_path.get_node("BossHPBar").value <= 0:
			if level in CompletedLevels.completed_levels: # Daha önce kestik
				pass
			else: # İlk defa kesiyorsak
				CompletedLevels.completed_levels.append(level)
			get_tree().change_scene_to_file("res://scenes/map.tscn")
		turn += 1
		toggle_buttons()
		play_turn()

func _on_button_3_pressed(): # Heal butonuna basıldığında
	$Player/PlayerHPBar.value += 10
	turn += 1
	toggle_buttons()
	play_turn()

func _on_button_4_pressed():
	$Player/PlayerManaBar.value = $Player/PlayerManaBar.max_value
	turn += 1
	toggle_buttons()
	play_turn()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_back_to_mm_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_pause_button_pressed():
	$PauseScreen.visible = true
	get_tree().paused = true

func _on_resume_pressed():
	$PauseScreen.visible = false
	get_tree().paused = false

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
