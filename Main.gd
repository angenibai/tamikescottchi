extends Node2D


export (PackedScene) var Cloud
export (PackedScene) var Enemy

var score
var speed_multiplier
var spawn_multiplier


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func new_game():
	score = 0
	speed_multiplier = 1
	spawn_multiplier = 1
	$HUD.new_game()
	$GameplayMusic.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_StartTimer_timeout():
	$CloudTimer.start()
	$EnemyTimer.start()


func _on_CloudTimer_timeout():
	# Spawn cloud
	if randi() % (8 + spawn_multiplier) > 4:
		$CloudPath/CloudSpawnLocation.set_offset(randi())
		var cloud = Cloud.instance()
		add_child(cloud)
		
		cloud.position = $CloudPath/CloudSpawnLocation.position
		
		var direction = PI

		cloud.set_linear_velocity(Vector2(cloud.speed * speed_multiplier, 0).rotated(direction))
	
	speed_multiplier += 0.005
	
	if randi() % 20 > 16:
		spawn_multiplier += 1
	
func _on_EnemyTimer_timeout():
	# Spawn enemy
	if randi() % (8 + spawn_multiplier) > 4:
		$EnemyPath/EnemySpawnLocation.set_offset(randi())
		var enemy = Enemy.instance()
		add_child(enemy)
		
		enemy.position = $EnemyPath/EnemySpawnLocation.position
		
		var direction = PI
		
		var extra_multiplier = 1
		if randi() % 6 > 4:
			extra_multiplier = 2
		
		enemy.set_linear_velocity(Vector2(enemy.speed * speed_multiplier * extra_multiplier, 0).rotated(direction))
	
func _on_Player_enemy_hit():
	$GameplayMusic.stop()
	$DeathSound.play()
	for child in get_children():
		if str("Timer") in child.name:
			child.stop()
		elif str("Player") in child.name:
			child.hide()
		elif str("Cloud") == child.name or str("Enemy") == child.name:
			remove_child(child)
		elif str("@Cloud") in child.name or str("@Enemy") in child.name:
			remove_child(child)
	$HUD.show_game_over(score)
	#get_tree().reload_current_scene()

func _on_Player_cloud_hit():
	score += 1
	$HUD.update_score(score)
	$CloudHit.play()
	
	if score != 0 and score % 50 == 0:
		$HUD.show_message("Yay we are back to " + str(score) + "!")
		$Reached50.play()
