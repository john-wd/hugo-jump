class_name GameContext extends Node2D

@onready var platform_manager: PlatformManager = $PlatformManager
@onready var player: Player = $World/Player
@onready var platform_container: Node2D = $World/Platforms
@onready var world: Node2D = $World

@export var DEFAULT_SCROLLING_SPEED := 200
@export var player_threshold := .4

var px_threshold := 200 # spawn platform every 200px
var scrolled_pxs: float = 0.0

var scrolling_speed := DEFAULT_SCROLLING_SPEED
var win_height: float = 0

var lives := 3
var DEATH_TIME := 1.5 # seconds
var death_acc = 0

func setup() -> void:
    win_height = get_viewport_rect().size.y
    for i in range(7):
        platform_manager.spawn_platform(
            win_height - ((i + 1) * 200)
        )
        
    player.died.connect(handle_death)
    
func handle_death() -> void:
    lives -= 1
    if lives < 0:
        print("Game over")
        get_tree().paused = true
        player.visible = false
        return
    player.move_to_center()
    player.pause()
    death_acc = DEATH_TIME

func _physics_process(delta: float) -> void:
    _move_world(delta)
    if player.paused:
        player.move_to_center()
    
func _move_world(delta: float) -> void:
    world.position.y += scrolling_speed * delta

func _process(delta: float) -> void:
    scrolled_pxs += DEFAULT_SCROLLING_SPEED * delta
    if scrolled_pxs >= px_threshold:
        scrolled_pxs -= px_threshold
        platform_manager.spawn_platform(-world.position.y)
        
    if player.paused:
        death_acc -= delta
        if death_acc < 0:
            player.unpause()
    _prune_old_platforms()
    
func _prune_old_platforms() -> void:
    for platform in platform_container.get_children():
        var plat := platform as Node2D
        if not plat:
            continue
            
        if plat.position.y > win_height:
            platform_container.remove_child(platform)
            
#func _adjust_speed() -> void:
    #if player.position.y + world.position.y < win_height * player_threshold:
        #scrolling_speed = 300
    #else:
        #scrolling_speed = DEFAULT_SCROLLING_SPEED
        #
    #
