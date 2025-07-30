extends Area3D

const quest_id: int = 0

@onready var shape = $CollisionShape3D
@onready var mesh = $MeshInstance3D

func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		visible = false
		shape.set_deferred("disabled", true)
		QuestManager.complete_quest(quest_id)
