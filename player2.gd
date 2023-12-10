extends CharacterBody2D

@export var speed = 200

func get_input():
	var input_direction = Input.get_vector("leftj2", "rightj2", "upj2", "downj2")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

func _process(delta):
	pass
