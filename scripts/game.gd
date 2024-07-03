extends Node2D
# Zahid pull denemesi için
var turn = 0
var boss_damage = 0
var boss_heal = 0
var boss = null
var boss_path
var level
@onready var button_1 = $Button
@onready var button_2 = $Button2
@onready var button_3 = $Button3
@onready var button_4 = $Button4

func _ready(): # --> Oyun başlangıcında ayarlanacak şeyler
	$PauseScreen.visible = false
	$Boss/Spider.visible = false
	$Boss/VampireBoss.visible = false
	# Boss seçimini handle ediyoruz
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
	# Karakter seçimini handle ediyoruz
	if CharacterSelection.choice == 1:
		$Player/Sprite2D.texture = preload("res://assets/elementalist.png")
		button_1.text = "Blast"
		button_2.text = "Fireball"
		button_3.text = "Heal"
		button_4.text = "Mana Regen"
	elif CharacterSelection.choice == 2:
		$Player/Sprite2D.texture = preload("res://assets/knight.png")
		button_1.text = "Slash"
		button_2.text = "Heavy Attack"
		button_3.text = "Heal"
		button_4.text = "Mana Regen"
	elif CharacterSelection.choice == 3:
		$Player/Sprite2D.texture = preload("res://assets/death.png")
		button_1.text = "Drain"
		button_2.text = "Death Blow"
		button_3.text = "Heal"
		button_4.text = "Mana Regen"
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
	var mana_requirement = 0
	if CharacterSelection.choice == 1: # PYROMANCER
		mana_requirement = 10
	elif CharacterSelection.choice == 3: # DEATH
		mana_requirement = 15
	if $Player/PlayerManaBar.value < mana_requirement:
		pass
	else:
		$Player/AnimationPlayer.play("deal_damage")
		boss_path.get_node("AnimationPlayer").play("take_damage")
		# CONDITIONAL STATEMENTS FOR SPECIFIC CHARACTERS
		if CharacterSelection.choice == 1: # PYROMANCER
			fireblast()
		elif CharacterSelection.choice == 2: # KNIGHT
			slash()
		elif CharacterSelection.choice == 3: # DEATH
			drain()
		# CONDITIONAL STATEMENTS FOR SPECIFIC CHARACTERS
		if boss_path.get_node("BossHPBar").value <= 0:
			if level in CompletedLevels.completed_levels: # Daha önce kestik
				pass
			else: # İlk defa kesiyorsak
				CompletedLevels.completed_levels.append(level)
				Map.gold_count_as_integer += 50
			get_tree().change_scene_to_file("res://scenes/map.tscn")
		turn += 1
		toggle_buttons()
		play_turn()

func _on_button_2_pressed(): # Fireball butonuna basıldığında
	var mana_requirement = 0
	if CharacterSelection.choice == 1: # PYROMANCER
		mana_requirement = 10
	elif CharacterSelection.choice == 3: # DEATH
		mana_requirement = 15
	if $Player/PlayerManaBar.value < mana_requirement:
		pass
	else: # Yeterli manamız varsa
		$Player/AnimationPlayer.play("deal_damage")
		boss_path.get_node("AnimationPlayer").play("take_damage")
		# CONDITIONAL STATEMENTS FOR SPECIFIC CHARACTERS
		if CharacterSelection.choice == 1: # PYROMANCER
			fireball()
		elif CharacterSelection.choice == 2: # KNIGHT
			heavy_attack()
		elif CharacterSelection.choice == 3: # DEATH
			death_blow()
		# CONDITIONAL STATEMENTS FOR SPECIFIC CHARACTERS
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

func _on_button_4_pressed(): # Mana butonuna basıldığında
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

# KNIGHT CHARACTER SKILLS
func slash(): # Button 1 for the Knight character
	boss_path.get_node("BossHPBar").value -= 200
func heavy_attack():
	boss_path.get_node("BossHPBar").value -= 15

# PYROMANCER CHARACTER SKILLS
func fireblast(): # Button 1 for the Pyromancer character
	$Player/PlayerManaBar.value -= 5
	boss_path.get_node("BossHPBar").value -= 10
func fireball():	
	$Player/PlayerManaBar.value -= 10
	boss_path.get_node("BossHPBar").value -= 20

# DEATH CHARACTER SKILLS
func drain(): # Button 1 for the Death character
	$Player/PlayerManaBar.value -= 8
	boss_path.get_node("BossHPBar").value -= 15
func death_blow():	
	$Player/PlayerManaBar.value -= 15
	boss_path.get_node("BossHPBar").value -= 25
