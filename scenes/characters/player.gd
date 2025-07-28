extends CharacterBody3D

@onready var animation_tree = $AnimationTree
@onready var model = $"character-male-a"
@onready var glow_mesh = $"glow-mesh"

func _ready():
	pass

func _process(_delta: float):
	if is_on_floor():
		$AnimationTree.set("parameters/blend/blend_amount", velocity.normalized().length())
	else:
		$AnimationTree.set("parameters/blend/blend_amount", 0.0)

func _physics_process(delta: float):
	# Get forward/backward and rotation input
	var forward_input = Input.get_axis("move_backward", "move_forward")
	var rotation_input = Input.get_axis("move_right", "move_left")
	
	# Apply rotation
	var rotation_speed = 2.0  # Adjust rotation speed as needed
	rotation.y += rotation_input * rotation_speed * delta
	
	# Calculate forward movement based on character's facing direction
	var movement_speed = 2.0
	# Calculate forward direction from current Y rotation plus 90 degrees
	var forward_direction = Vector3.FORWARD.rotated(Vector3.UP, rotation.y - PI)
	var movement_velocity = forward_direction * forward_input * movement_speed
	
	# Apply movement
	velocity = Vector3(movement_velocity.x, 0.0, movement_velocity.z)

	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y = -9.8

	move_and_slide()
