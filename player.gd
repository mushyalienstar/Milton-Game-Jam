extends CharacterBody2D

signal weapon_out_of_ammo

@export var speed: float = 400.0  # Player movement speed
@export var bullet_speed: float = 500.0  # Speed of bullets
@export var bullet_scene: PackedScene = preload("res://bullet.tscn")  # Path to your bullet scene
@export var enemy_scene: PackedScene = preload("res://Enemy.tscn")    # Path to your enemy scene
@onready var sfx_shoot = $sfx_shoot
@onready var healthbar = $CanvasLayer/Healthbar


var health: float = 10.0
var max_ammo: int = 10
var current_ammo: int = max_ammo
var player_touching: bool = false

func _ready() -> void:
	health = 10.0
	healthbar.init_health(health)
	# Instantiate and add the enemy to the scene at the start
	var enemy_instance = enemy_scene.instantiate()
	#health_bar.value = hp
	
	# Optionally, set the position of the enemy (e.g., center of the screen)
	var viewport_size = get_viewport().size
	enemy_instance.position = viewport_size / 2  # Center the enemy
	
	# Add the enemy to the scene
	get_tree().get_root().call_deferred("add_child", enemy_instance)

func _physics_process(delta: float) -> void:
	# Movement logic
	var motion = Vector2.ZERO

	if Input.is_action_pressed("up"):
		motion.y -= 1
	if Input.is_action_pressed("down"):
		motion.y += 1
	if Input.is_action_pressed("left"):
		motion.x -= 1
	if Input.is_action_pressed("right"):
		motion.x += 1
	if Input.is_action_just_pressed("reload"):
		current_ammo = max_ammo

	velocity = motion.normalized() * speed
	move_and_slide()
	
	if player_touching == true:
		health -= 0.1
		healthbar.health = health

	# Rotate to face the mouse cursor
	look_at(get_global_mouse_position())

	# Fire bullet when left mouse button is pressed
	if Input.is_action_just_pressed("LMB"):
		fire()

func fire():
	# Spawn a bulletw
	if current_ammo != 0:
		sfx_shoot.play()
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.position = position + Vector2(0, 0).rotated(rotation)  # Offset to avoid spawning inside the player
		bullet_instance.rotation = rotation  # Set bullet's rotation to match player rotation
		get_parent().add_child(bullet_instance)     # Add the bullet to the scene tree
		current_ammo -= 1
		if current_ammo == 0:
			emit_signal("weapon_out_of_ammo")

		# Set bullet's velocity to move it forward in the direction the player is facing
		if bullet_instance is RigidBody2D:
			var direction = Vector2.RIGHT.rotated(global_rotation) * bullet_speed
			bullet_instance.set_linear_velocity(direction)

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		player_touching = true



func _on_area_2d_area_exited(area):
	player_touching = false
