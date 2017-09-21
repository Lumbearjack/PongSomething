extends Node2D

# Member variables
var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)
var starting_lives = 3
var left_lives = starting_lives
var right_lives = starting_lives
var ball_speed_multiplier = 1.1

# Constant for ball speed (in pixels/second)
const INITIAL_BALL_SPEED = 120
# Speed of the ball (also in pixels/second)
var ball_speed = INITIAL_BALL_SPEED
# Constant for pads speed
const PAD_SPEED = 150

func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	var power_up_pos = get_node("power_up").get_pos()
	power_up_pos.x = screen_size.x*0.5
	power_up_pos.y = screen_size.y*0.25
	get_node("power_up").set_pos(power_up_pos)
	print(power_up_pos)
	set_process(true)

func _process(delta):
	var ball_pos = get_node("ball").get_pos()
	var left_rect = Rect2( get_node("left").get_pos() - pad_size*0.5, pad_size )
	var right_rect = Rect2( get_node("right").get_pos() - pad_size*0.5, pad_size )
	get_node("power_up")
	# Integrate new ball position
	ball_pos += direction * ball_speed * delta
	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
	# Flip, change direction and increase speed when touching pads
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ball_speed *= ball_speed_multiplier
	# Check gameover
	if (ball_pos.x < 0):
		left_lives -= 1
		if(left_lives < 3):
			get_node("left_life_3").hide()
		if(left_lives < 2):
			get_node("left_life_2").hide()
		if(left_lives < 1):
			get_node("left_life_1").hide()
		print(left_lives)
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
		
	if (ball_pos.x > screen_size.x):
		right_lives -= 1
		if(right_lives < 3):
			get_node("right_life_3").hide()
		if(right_lives < 2):
			get_node("right_life_2").hide()
		if(right_lives < 1):
			get_node("right_life_1").hide()
		print(right_lives)
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(1, 0)
		
	get_node("ball").set_pos(ball_pos)
	# Move left pad
	var left_pos = get_node("left").get_pos()
	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
    	left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
    	left_pos.y += PAD_SPEED * delta
	get_node("left").set_pos(left_pos)
	# Move right pad
	var right_pos = get_node("right").get_pos()
	if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
    	right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
    	right_pos.y += PAD_SPEED * delta
	get_node("right").set_pos(right_pos)
