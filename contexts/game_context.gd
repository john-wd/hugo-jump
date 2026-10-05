class_name GameContext extends Node2D

@onready var platform_manager: PlatformManager = $PlatformManager
@onready var player: Player = $World/Player
@onready var platform_container: Node2D = $World/Platforms
@onready var world: Node2D = $World

@export var DEFAULT_SCROLLING_SPEED := 200
@export var DEFAULT_TICK_TIME = 1.1
@export var player_threshold := .4

var tick_time: float = DEFAULT_TICK_TIME
var scrolling_speed := DEFAULT_SCROLLING_SPEED
var time_acc: float = 0
var win_height: float = 0

func setup():
	win_height = get_viewport_rect().size.y
	for i in range(7):
		platform_manager.spawn_platform(
			win_height - ((i + 1) * 200)
		)

func _physics_process(delta: float):
	_move_world(delta)
	
func _move_world(delta: float):
	world.position.y += scrolling_speed * delta

func _process(delta: float) -> void:
	time_acc += delta
	if time_acc >= tick_time:
		time_acc -= tick_time
		platform_manager.spawn_platform(-world.position.y)
		
	_prune_old_platforms()
	
func _prune_old_platforms():
	for platform in platform_container.get_children():
		if platform.position.y > win_height:
			platform_container.remove_child(platform)
			
#func _adjust_speed():
	#if player.position.y + world.position.y < win_height * player_threshold:
		#scrolling_speed = 400
		#tick_time = .5
	#else:
		#scrolling_speed = DEFAULT_SCROLLING_SPEED
		#tick_time = DEFAULT_TICK_TIME
		
	
