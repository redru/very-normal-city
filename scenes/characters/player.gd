extends Node3D

@onready var animation_tree = $AnimationTree
@onready var body = $CharacterBody
@onready var model = $"character-male-a"
@onready var glow_mesh = $"glow-mesh"
@onready var ground_checker = $CharacterBody/GroundChecker

func _ready():
	pass

func _process(_delta: float):
	if is_grounded():
		$AnimationTree.set("parameters/blend/blend_amount", body.velocity.normalized().length())

	# Update the model's global transform to match the body
	model.global_transform = body.global_transform
	glow_mesh.global_transform = body.global_transform

func _physics_process(delta: float):
	# Get forward/backward and rotation input
	var forward_input = Input.get_axis("move_backward", "move_forward")
	var rotation_input = Input.get_axis("move_right", "move_left")
	
	# Apply rotation
	var rotation_speed = 2.0  # Adjust rotation speed as needed
	body.rotation.y += rotation_input * rotation_speed * delta
	
	# Calculate forward movement based on character's facing direction
	var movement_speed = 2.0
	# Calculate forward direction from current Y rotation plus 90 degrees
	var forward_direction = Vector3.FORWARD.rotated(Vector3.UP, body.rotation.y - PI / 2)
	var movement_velocity = forward_direction * forward_input * movement_speed
	
	# Apply movement
	body.velocity = Vector3(movement_velocity.x, body.velocity.y, movement_velocity.z)

	if !is_grounded():
		body.velocity.y -= 9.8 * delta  # Apply gravity
	else:
		body.velocity.y = 0  # Reset vertical velocity when grounded

	body.move_and_slide()

func is_grounded() -> bool:
	return ground_checker.is_colliding()
