extends Control

@export var play_scene: PackedScene
@export var play_splitscreen_scene: PackedScene

func _ready() -> void:
	SoundManager.play_music()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play_scene)

func _on_play_splitscreen_pressed() -> void:
	get_tree().change_scene_to_packed(play_splitscreen_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()
