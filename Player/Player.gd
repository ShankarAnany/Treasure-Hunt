extends KinematicBody2D
class_name Player

export(Resource) var Settings

var velocity = Vector2.ZERO
var coyote_jump = false
var extra_jump = 0
var buffer_jump = false

onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
onready var coyote_jump_timer = $CoyoteJumpTimer
onready var jump_buffer_timer = $JumpBufferTimer

func _ready():
	animated_sprite.animation = "Idle"
	extra_jump = Settings.extra_jumps

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")

	if animated_sprite.animation != "Die":
		move(input, delta)

func move(input, delta):
	apply_grav(delta)
	if input.x == 0:  # Stop movement in x direction
		apply_fric(delta)
		animated_sprite.animation = "Idle"
	else:  # Start movement in x direction
		apply_acc(input.x, delta)
		animated_sprite.animation = "Run"

	animated_sprite.flip_h = input.x < 0

	if is_on_floor():  # Reset
		extra_jump = Settings.extra_jumps

	jump(delta)

func jump(delta):
	if Input.is_action_just_pressed("ui_up"):  # Buffer Jump
		buffer_jump = true
		jump_buffer_timer.start()

	if is_on_floor() or coyote_jump:  # Jump
		if buffer_jump:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = Settings.jump_max
			buffer_jump = false
	else:
		animated_sprite.animation = "Jump"
		# Min Jump
		if Input.is_action_just_released("ui_up") and velocity.y < Settings.jump_min:
			velocity.y = Settings.jump_min

		# Double Jump
		if Input.is_action_just_pressed("ui_up") and extra_jump > 0:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = Settings.jump_max
			extra_jump -= 1

		# Extra Fall Gravity
		if velocity.y > 0:
			velocity.y += Settings.fall_grav * delta
			animated_sprite.animation = "Fall"

	var was_on_floor = is_on_floor()

	velocity = move_and_slide(velocity, Vector2.UP)

	# Coyote Jump
	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyote_jump_timer.start()

func apply_grav(delta):
	velocity.y += Settings.grav * delta
	velocity.y = min(velocity.y, 300)

func apply_fric(delta):
	velocity.x = move_toward(velocity.x, 0, Settings.fric * delta)

func apply_acc(input_x, delta):
	velocity.x = move_toward(velocity.x, Settings.speed_x * input_x, Settings.acc * delta)

func die():
	SoundPlayer.play_sound(SoundPlayer.HURT)
	animated_sprite.animation = "Die"
	animation_player.play("Die")
	yield(animation_player, "animation_finished")
	Events.emit_signal("player_died")
	queue_free()

func connect_camera(camera):
	var path = camera.get_path()
	$RemoteTransform2D.remote_path = path

func _on_CoyoteJumpTimer_timeout():
	coyote_jump = false

func _on_JumpBufferTimer_timeout():
	buffer_jump = false
