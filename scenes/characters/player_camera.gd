extends Camera3D

@export var sensitivity: float = 5

var rotating: bool = false

func _ready() -> void:
    sensitivity = sensitivity / 1000

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("reset_camera"):
        rotation = Vector3(0, PI, 0)

func _input(event):
    if event is InputEventMouseMotion and rotating:
        rotation.x -= event.relative.y * sensitivity
        rotation.y -= event.relative.x * sensitivity

        # Clamp the rotation to prevent flipping
        rotation.x = clamp(rotation.x, -PI / 4, PI / 4)

    elif event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
            rotating = true
        elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
            rotating = false
