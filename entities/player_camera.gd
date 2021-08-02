extends Spatial

export var player_path : NodePath
var player

func _ready():
	player = get_node(player_path)	

func _process(delta):
	global_transform.origin = player.get_global_transform().origin
