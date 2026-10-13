class_name TitleContext extends Node2D

@onready var gameBtn: Button = %start_button
@onready var quitBtn: Button = %quit_button
@onready var settingsBtn: Button = %settings_button

var audio_player: AudioPlayer

signal start_button_pressed
signal quit_button_pressed
    
func setup(aplayer: AudioPlayer):
    quitBtn.pressed.connect(quit_button_pressed.emit)
    gameBtn.pressed.connect(_handle_game_button)
    gameBtn.grab_focus()
    
    audio_player = aplayer
    audio_player.play_title_music()    

func _handle_game_button() -> void:
    start_button_pressed.emit()
    audio_player.play_start()
