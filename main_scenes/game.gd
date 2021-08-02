extends Spatial

var player setget set_player

func _ready():
	# Find player in entities
	for node in $Entities.get_children():
		if node is Player:
			set_player(node)
			break

######################
####Signal Methods####
######################
func on_player_shoot_bullet(new_bullet):
	$Entities/Projectiles.add_child(new_bullet)
	
func on_player_hp_changed(new_hp, hp_ratio):
	$UI/HealthBarBackground/HealthBar.anchor_right = hp_ratio

###########################
####Setters and Getters####
###########################
func set_player(new_player):
	player = new_player
	player.connect("shoot_bullet", self, "on_player_shoot_bullet")
	player.connect("hp_changed", self, "on_player_hp_changed")
