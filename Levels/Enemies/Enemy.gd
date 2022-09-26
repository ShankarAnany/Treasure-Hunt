extends KinematicBody2D

export(Resource) var Enemy
export(int) var speed = 25

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

onready var ledge_check_right = $LedgeCheckRight
onready var ledge_check_left = $LedgeCheckLeft
onready var animated_sprite = $AnimatedSprite


func _ready():
	animated_sprite.frames = Enemy.frames
	animated_sprite.position.y = Enemy.pos_y
	$TerrainCollision.shape = Enemy.collision_box
	$Hitbox/CollisionShape2D.shape = Enemy.hit_box
	$LedgeCheckRight.position.x = Enemy.raycast_x

func _physics_process(_delta):
	var found_wall = is_on_wall()
	var found_ledge = not ledge_check_right.is_colliding() or not ledge_check_left.is_colliding()

	if found_wall or found_ledge:
		direction *= -1
		animated_sprite.flip_h = not animated_sprite.flip_h

	velocity = direction * speed
	move_and_slide(velocity, Vector2.UP)
	animated_sprite.animation = "Run"
 
