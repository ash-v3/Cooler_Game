extends StaticBody

var health : float = 100

func _ready():
	add_to_group("TargetDummies")

func damage(amount):
	health -= amount

	if health <= 0:
		queue_free()
