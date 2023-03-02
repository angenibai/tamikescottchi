extends Area2D


export (int) var speed
var screensize
var head_radius = 30
signal cloud_hit
signal enemy_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screensize = get_viewport_rect().size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() # The player's movement vector.
	if Input.is_action_pressed("ui_down"):
		velocity.y += 400
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 400
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position.x = clamp(position.x, head_radius, screensize.x - head_radius)
	position.y = clamp(position.y, head_radius, screensize.y - head_radius)




func _on_Player_body_entered(body):
	print(body.name)
	
	if "Cloud" in str(body.name):
		emit_signal("cloud_hit")
	else:
		emit_signal("enemy_hit")
	body.hide()

