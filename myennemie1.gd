extends CharacterBody2D

@export var speed = 400
@export var player : CharacterBody2D

var hit : bool = false

func get_input():
	look_at(player.position)
	velocity = transform.x * Input.get_axis("down1", "up2") * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body==player:
		player.set_life_point(player.life_point - 1)
