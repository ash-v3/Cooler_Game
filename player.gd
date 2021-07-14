extends KinematicBody

var velocity : Vector3 = Vector3.ZERO
var acceleration : float = 50
var max_speed : float = 10
var friction_strength : float = 35

# The direction the player is looking
var look_vector = Vector2(1, 0)

func _ready():
	pass

func _physics_process(delta):
	var side_input = 0
	var forward_input = 0
	
	if Input.is_action_pressed("left"):
		side_input -= 1
	if Input.is_action_pressed("right"):
		side_input += 1
	if Input.is_action_pressed("up"):
		forward_input += 1
	if Input.is_action_pressed("down"):
		forward_input -= 1
	
	# X is forward and z is sideways currently
	velocity += Vector3(forward_input, 0, side_input) * acceleration * delta
	
	if velocity.length() > max_speed:
		velocity *= max_speed / velocity.length()

	# Move the player
	var adjusted_velocity = move_and_slide(velocity)
	velocity = adjusted_velocity
	
	# The unit vector of the player's movement
	var unit_vector : Vector3 = velocity.normalized()
	
	# Apply friction to the player
	var friction_velocity : Vector3 = Vector3(-unit_vector.x * friction_strength * delta, 0, -unit_vector.z * friction_strength * delta)
	
	if friction_velocity.length() < velocity.length():
		velocity += friction_velocity
	else:
		velocity = Vector3.ZERO

	# Rotate to face mouse
	# Mouse position
	var mouse_position = get_viewport().get_mouse_position()
	
	# Extend a ray from the camera into infinity
	var ray = $Camera.project_ray_normal(mouse_position)

	# Player position
	#var player_y = global_transform.origin.y
	var nose_y = $Mesh/Nose.global_transform.origin.y
	
	# A plane with a normal vector that faces straight up
	# Second argument is distance from origin that plane is
	# Plane is ground plane raised to player's position
	var plane = Plane(Vector3(0, 1, 0), nose_y)
	
	# The point the ray and plane intersect
	var intersection = plane.intersects_ray($Camera.global_transform.origin, ray)
	
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
