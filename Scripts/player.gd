extends CharacterBody2D

@onready var sprite = $Sprite
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var jump_sound = $JumpSound

var ta_na_parede = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const WALL_JUMP_PUSHBACK = 1000
const WALL_SLIDE_GRAVITY = 60

var coyote_time = 0.2
var can_jump = false

var jump_timer = 0.0

var is_wall_sliding = false
var direction

var has_key := true

var pushback_vector =Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	direction = Input.get_axis("ui_left", "ui_right")
	if direction >0 and direction<1:
		direction =1
	elif direction <0 and direction>-1:
		direction =-1
	_movement(delta)
	wall_slide(delta)
	_jump(delta)
	
	if ray_cast_right.is_colliding() or ray_cast_left.is_colliding():
		ta_na_parede = true
	else:
		ta_na_parede=false
	
func _movement(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite.play("Jump")
		
		#jump buffer
		if Input.is_action_pressed("ui_accept"):
			jump_timer=0.1
		
		
	#move
	if !ta_na_parede or (ta_na_parede and is_on_floor()):
		if direction:
			sprite.play("Run")
			sprite.scale.x = direction
			velocity.x = direction * SPEED
		else:
			if is_on_floor():
				sprite.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)

			
# Get the input direction and handle the movement/deceleration.
	move_and_slide()
	
	#if knockbackVector != Vector2.ZERO:
		#velocity = knockbackVector
	
func _jump(delta):
	if jump_timer>0:
			jump_timer-=delta	
			
	if is_on_floor() and !can_jump:
		can_jump = true
	elif can_jump and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start(coyote_time)

	#jump buffer
	if is_on_floor() and jump_timer>0:
		jump_timer=0.0
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
			
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
			
		if can_jump:
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
			
		if ray_cast_right.is_colliding():
			pushback_vector = Vector2(-200, -400)
			velocity = pushback_vector
			jump_sound.play()
		
			var pushback_tween := get_tree().create_tween()
			pushback_tween.tween_property(self, "pushback_vector", Vector2.ZERO, 0.25)
		
		if ray_cast_left.is_colliding():
			pushback_vector = Vector2(200, -400)
			velocity = pushback_vector
			jump_sound.play()
		
			var pushback_tween := get_tree().create_tween()
			pushback_tween.tween_property(self, "pushback_vector", Vector2.ZERO, 0.25)
	
func wall_slide(delta):
	
	if not is_on_floor() and (ray_cast_left.is_colliding() or ray_cast_right.is_colliding()):
		is_wall_sliding = true
		#if direction:
		#	is_wall_sliding = true
		#else:
		#	is_wall_sliding = false 
	else:
		is_wall_sliding=false
		
	if is_wall_sliding:
		sprite.play("WallSlide")
		velocity.y += (WALL_SLIDE_GRAVITY * delta)
		velocity.y = min(velocity.y, WALL_SLIDE_GRAVITY)

func morrer():
	queue_free()
	Globals.restart()


func _on_coyote_timer_timeout():
	can_jump = false
