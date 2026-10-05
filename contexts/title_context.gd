class_name TitleContext extends Node2D

@onready var gameBtn: Button = $StartGame
@onready var quitBtn: Button = $Quit

signal start_button_pressed
signal quit_button_pressed
	
func setup():
	gameBtn.pressed.connect(start_button_pressed.emit)
	quitBtn.pressed.connect(quit_button_pressed.emit)
		
