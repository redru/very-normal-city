extends Node

const quests_dir = "res://quests/resources/"
var quests = {}

func _ready():
	quests = load_quests()

func load_quests():
	var dir := DirAccess.open(quests_dir)

	if dir:
		dir.list_dir_begin()

		var file_name = dir.get_next()

		while file_name != "":
			if file_name.ends_with(".tres"):
				var quest = load(quests_dir + file_name)
				
				if quest:
					quests[quest.quest_id] = quest
					print("Loaded quest:", quest)

			file_name = dir.get_next()

		dir.list_dir_end()

	return quests

func get_quest(quest_id: int):
	return quests[quest_id]

func complete_quest(quest_id: int):
	quests[quest_id].is_completed = true
	print("Quest completed:", quest_id)
