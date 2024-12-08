extends RigidBody2D

@export var lifetime: float = 2.0  # Lifetime of the bullet in seconds

func _ready() -> void:
	# Create a new Timer node
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	add_child(timer)  # Add the timer to the bullet node
	timer.start()

	# Connect the timeout signal to delete the bullet
	timer.timeout.connect(self.queue_free)
	gravity_scale = 0
	
		
func _on_area_2d_body_entered(body):
	if body.name =="TileMap":
		queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		queue_free()
