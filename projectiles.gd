extends KinematicBody

var direction : Vector3 = Vector3.FORWARD setget set_direction, get_direction
var speed : float = 3

func _ready():
	pass

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		queue_free()

func set_direction(new_direction):
	direction = new_direction

func get_direction():
	return direction
