extends Area2D

export(Resource) var collect_type
onready var animated_sprite = $AnimatedSprite
onready var collision_shape_2d = $CollisionShape2D


func _ready():
	animated_sprite.frames = collect_type.sprite
	collision_shape_2d.shape = collect_type.collision_box

func _on_Collectibles_body_entered(body):
	if not body is Player: return
	SoundPlayer.play_sound(SoundPlayer.COLLECT)
	Events.emit_signal("collected", 5)
	queue_free()
