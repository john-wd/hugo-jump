class_name RootContext extends Node2D

@export var title_context: PackedScene
@export var game_context: PackedScene

var _current_context: Node

func _ready() -> void:
	setup()

func setup() -> void:
	mount_title()

func mount_title() -> void:
	if _current_context:
		_current_context.queue_free()
		
	_current_context = title_context.instantiate()
	var ctx := _current_context as TitleContext
	
	if not ctx:
		printerr("Game context not found")
		return

	add_child(ctx)
	ctx.setup()
	ctx.quit_button_pressed.connect(func(): get_tree().quit())
	ctx.start_button_pressed.connect(mount_game)

func mount_game() -> void:
	if _current_context:
		_current_context.queue_free()
		
	_current_context = game_context.instantiate()
	var ctx := _current_context as GameContext
	
	if not ctx:
		printerr("Game context not found")
		return

	add_child(ctx)
	ctx.setup()
