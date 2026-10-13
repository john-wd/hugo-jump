class_name AudioPlayer
extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

@export var coinSfx: AudioStream
@export var jumpSfx: AudioStream
@export var menuSfx: AudioStream
@export var startSfx: AudioStream
@export var dieSfx: AudioStream
@export var titleSong: AudioStream
@export var gameSong: AudioStream

func play_jump() -> void:
    sfx_player.stream = jumpSfx
    sfx_player.play()
    
func play_coin() -> void:
    sfx_player.stream = coinSfx
    sfx_player.play()
    
func play_select() -> void:
    sfx_player.stream = menuSfx
    sfx_player.play()
    
func play_start() -> void:
    sfx_player.stream = startSfx
    sfx_player.play()
    
func play_die() -> void:
    sfx_player.stream = dieSfx
    sfx_player.play()
    
func play_title_music() -> void:
    music_player.stream = titleSong
    music_player.play()
    
func play_game_music() -> void:
    music_player.stream = gameSong
    music_player.play()
    
func pause_music() -> void:
    music_player.stream_paused = !music_player.stream_paused
    
