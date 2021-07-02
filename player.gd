extends KinematicBody

var velocity : Vector3 = Vector3.ZERO
var acceleration : float = 1.5

func _ready():
	pass

func _physics_process(delta):
	var horizontal_input = 0
	var vertical_input = 0
	
	if Input.is_action_pressed("left"):
		horizontal_input -= 1
	if Input.is_action_pressed("right"):
		horizontal_input += 1
	if Input.is_action_pressed("up"):
		vertical_input -= 1
	if Input.is_action_pressed("down"):
		vertical_input += 1
		
	velocity += Vector3(horizontal_input, 0, vertical_input) * acceleration * delta

	# Move the player
	var adjusted_velocity = move_and_slide(velocity)
	velocity = adjusted_velocity

	# Rotate to face mouse
	# Mouse position
	var mouse_position = get_viewport().get_mouse_position()

	# Project 3d position
	var distance_from_camera = $Camera.translation.magnitude()
	$Camera.project_position(mouse_position, distance_from_camera)

	# Rotate the player to match the position
	
