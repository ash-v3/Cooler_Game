extends KinematicBody

var velocity : Vector3 = Vector3.ZERO
var acceleration : float = 1.5

# The direction the player is looking
# maybe: Vector2.RIGHT.rotate(angle)
onready var look_vector = Vector2(global_transform.basis.x.x, global_transform.basis.z.z)

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
	
	# Extend a ray from the camera into infinity
	var ray = $Camera.project_ray_normal(mouse_position)

	# Player position
	var player_y = global_transform.origin.y
	var eyes_y = $Mesh/Nose.global_transform.origin.y
	
	# A plane with a normal vector that faces straight up
	# Second argument is distance from origin that plane is
	# Plane is ground plane raised to player's position
	var plane = Plane(Vector3(0, 1, 0), eyes_y)
	
	# The point the ray and plane intersect
	var intersection = plane.intersects_ray($Camera.global_transform.origin, ray)
	
	var test_ball = get_node("../TestBall")
	test_ball.global_transform.origin = intersection
	
	# Sometimes intersection is null, don't know why
	if intersection:
		# Get the normalized vector from the intersection point to the player
		var mouse_vector = (intersection - global_transform.origin).normalized()
		
		# Convert vector into 2 dimensions for easier calculation
		mouse_vector = Vector2(mouse_vector.x, mouse_vector.z)
		
		# The angle from the direction of the player is looking to the mouse
		var angle = look_vector.angle_to(mouse_vector)
		
		# Rotate the mesh around the y axis to face the mouse
		$Mesh.rotate(Vector3(0, 1, 0), -angle)
		
		# Save the new look vector
		look_vector = mouse_vector
		
		print(angle, look_vector)
