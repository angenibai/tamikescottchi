extends CanvasLayer

signal start_game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayAgain.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func new_game():
	$PlayAgain.hide()
	hide_tamagotchi()
	$ScoreLabel.show()
	update_score(0)
	show_message("Let's get back to 50")

func hide_tamagotchi():
	$Tamagotchi.hide()
	$TamikesccottchiLabel.hide()
	$FinalScoreLabel.hide()

func show_tamagotchi(line1, line2=""):
	$Tamagotchi.show()
	$TamikesccottchiLabel.text = line1
	$TamikesccottchiLabel.show()
	$FinalScoreLabel.text = line2
	$FinalScoreLabel.show()

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over(score):
	show_message("Pipeline failed")
	yield($MessageTimer, "timeout")
	$PlayAgain.show()
	$ScoreLabel.hide()
	
	show_tamagotchi("  You got back to", str(score))
	
func update_score(score):
	$ScoreLabel.text = str(score)


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
