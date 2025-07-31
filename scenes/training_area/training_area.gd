extends Area3D

const quest_id: int = 0

@onready var shape: CollisionShape3D = $CollisionShape3D
@onready var fade_timer: Timer = $FadeTimer
@onready var mesh_1: MeshInstance3D = $"indicator-round-c2/indicator-round-c/rotate-y"
@onready var mesh_2: MeshInstance3D = $"indicator-round-d2/indicator-round-d/rotate-y"

func _process(_delta: float) -> void:
	if !fade_timer.is_stopped():
		var timer_progress = fade_timer.time_left / fade_timer.wait_time
		mesh_1.get_surface_override_material(0).set_shader_parameter("alpha", timer_progress)
		mesh_2.get_surface_override_material(0).set_shader_parameter("alpha", timer_progress)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		fade_timer.start()
		shape.set_deferred("disabled", true)
		QuestManager.complete_quest(quest_id)

func _on_fade_timer_timeout() -> void:
	queue_free()
