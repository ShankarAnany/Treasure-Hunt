extends Area2D

onready var animated_sprite = $AnimatedSprite

var active = true

func _on_Checkpoint_body_entered(body):
	if not body is Player: return
	if not active: return
	SoundPlayer.play_sound(SoundPlayer.CHECKPOINT)
	animated_sprite.animation = "Checked"
	active = false
	Events.emit_signal("checkpoint", global_position)
