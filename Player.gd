extends CharacterBody2D

@export var speed = 400
@export var suffixAction = ""
@export var dash_call = 40
@export var max_life_point = 100
@export var hud_visibily : bool = true

var can_dash : bool = true
var life_point = max_life_point

func get_input():
	var input_direction = Input.get_vector("left"+suffixAction, "right"+suffixAction, "up"+suffixAction, "down"+suffixAction)
	velocity = input_direction * speed
	if Input.is_action_just_pressed("dash_button") and can_dash :
		velocity = input_direction * speed * dash_call
		can_dash = false
		$Timer.start()

func _physics_process(delta):
	get_input()
	move_and_slide()

func _process(delta):
	$HUD/score_label.text = "%.01f" % $Timer.get_time_left()

func _ready():
	set_life_point(max_life_point)
	$HUD.visible = hud_visibily

func _on_timer_timeout():
	can_dash = true 
	$Timer.stop()

func set_life_point(new_life_point:int):
	life_point = new_life_point
	$HUD/LabelLP.set_text("%d / %d" % [life_point, max_life_point])

func _on_button_pressed():
	set_life_point(life_point - 1) 
	print($HUD.get_children())
