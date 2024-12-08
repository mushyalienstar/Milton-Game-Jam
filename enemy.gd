extends CharacterBody2D

var motion = Vector2()

func _ready():
	pass

func _physics_process(delta: float) -> void:
	# Get the player node from the parent scene, which should be the root of the current scene
	var player = get_tree().current_scene.get_node("Player")  # Assumes Player is a direct child of the current scene
	
	# Check if the player node exists
	if player:
		# Move the enemy towards the player
		position.x += (player.position.x - position.x) / 50
		position.y += (player.position.y - position.y) / 50

		look_at(player.position)
	else:
		# If the player node wasn't found, print a debug message
		print("Player node not found!")


func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		print("enemy shotd")
