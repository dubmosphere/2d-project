extends Node

@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var shot_sound: AudioStreamPlayer2D = $ShotSound
@onready var music: AudioStreamPlayer = $Music

func play_jump_sound() -> void:
	jump_sound.play()

func play_shot_sound() -> void:
	shot_sound.play()

func play_music() -> void:
	music.play()
