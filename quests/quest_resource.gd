extends Resource
class_name QuestResource

@export var quest_id: int
@export var quest_name: String = "Quest " + str(quest_id)
@export var description: String = "<placeholder>"
@export var is_completed: bool = false
@export var active: bool = false
@export var current_step: int = 1
@export var steps: Array = []
