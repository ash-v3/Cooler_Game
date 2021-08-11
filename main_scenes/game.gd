extends Spatial

export var room_type_paths : Array

var player setget set_player
var room_types : Array = []

var rooms : Dictionary

func _ready():
	randomize()
	
	if funcref(TB, "test"):
		TB.test()
	
	# Find player in entities
	for node in $Entities.get_children():
		if node.is_player:
			set_player(node)
			break

	load_room_types()

	spawn_rooms(3)

func load_room_types():
	for path in room_type_paths:
		var room_scene = load(path)
		room_types.append(room_scene)

func spawn_rooms(count):
	rooms = {}
	
	for i in range(count):
		# Pick random room type out of list
		var room_type_i = floor(randf() * len(room_types))

		var room_type = room_types[room_type_i]

		var room = room_type.instance()

		$Level.add_child(room)

		var direction = randi() % (90 + 1)
		room.global_transform.origin += Vector3(40 * i, 0, 0)

####Signal Methods####
func on_player_shoot_bullet(new_bullet):
	$Entities/Projectiles.add_child(new_bullet)
	
func on_player_hp_changed(new_hp, hp_ratio):
	$UI/HealthBarBackground/HealthBar.anchor_right = hp_ratio

####Setters and Getters####
func set_player(new_player):
	player = new_player
	player.connect("shoot_bullet", self, "on_player_shoot_bullet")
	player.connect("hp_changed", self, "on_player_hp_changed")
