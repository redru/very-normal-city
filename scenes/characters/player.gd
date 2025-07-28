extends CharacterBody3D

@onready var animation_tree = $AnimationTree
@onready var model = $"character-male-a"

@export var rotation_speed = 2.0
@export var movement_speed = 2.0
@export var jump_force = 4.0
@export var gravity_scale = 1.2

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
	rotation.y += rotation_input * rotation_speed * delta
	
	# Calculate forward movement based on character's facing direction
	
	# Calculate forward direction from current Y rotation plus 90 degrees
	var forward_direction = Vector3.FORWARD.rotated(Vector3.UP, rotation.y - PI)
	var movement_velocity = forward_direction * forward_input * movement_speed
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
		else:
			velocity.y = 0.0
	else:
		velocity.y = clampf(velocity.y - 9.8 * gravity_scale * delta, -9.8, 1000.0)

	# Apply movement
	velocity = Vector3(movement_velocity.x, velocity.y, movement_velocity.z)

	move_and_slide()
