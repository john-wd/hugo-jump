class_name TitleContext extends Node2D

@onready var gameBtn: Button = %start_button
@onready var quitBtn: Button = %quit_button
@onready var settingsBtn: Button = %settings_button

signal start_button_pressed
signal quit_button_pressed
    
func setup():
    gameBtn.pressed.connect(start_button_pressed.emit)
    quitBtn.pressed.connect(quit_button_pressed.emit)
    gameBtn.grab_focus()
        
