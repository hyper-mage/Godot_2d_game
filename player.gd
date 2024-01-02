extends Area2D

signal hit

@export var speed = 400 # speed of player in pixel/sec
var screen_size # size of game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # player's vector
	if Input.is_action_pressed("move_up"): # i have no clue why the direction is flipped but it works
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	# clamp the screen
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = 'walk'
		$AnimatedSprite2D.flip_v = false
		# boolean shorthand below, dodges a if else block
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = 'up'
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body):
	hide() # player hides after being hit
	hit.emit()
	$CollisionShape2D.set_deferred('disabled', true)
	# deferring the collision disable allows the physics processor to finish first
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
