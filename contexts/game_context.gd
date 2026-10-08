class_name GameContext extends Node2D

@onready var platform_manager: PlatformManager = $PlatformManager
@onready var player: Player = $World/Player
@onready var platform_container: Node2D = $World/Platforms
@onready var world: Node2D = $World
@onready var lives_label: Label = %LivesNumberLabel
@onready var points_label: Label = %PointsLabel
@onready var gameover_container: Container = %GameOverContainer

@export var DEFAULT_LIVES := 3
@export var player_threshold := .4

var DEFAULT_SCROLLING_SPEED := 200.0
var FAST_SCROLLING_SPEED := 400.0
var PLATFORM_SPACING := 200 # spawn platform every 200px

var scrolling_speed := DEFAULT_SCROLLING_SPEED
var screen_height: float = 0.0

var lives := 3
var points := 0
var DEATH_TIME := 1.5 # seconds
var death_acc := 0.0
var playing := true
var last_platform_height := 0.0

func _ready() -> void:
    screen_height = get_viewport_rect().size.y

func _reset_last_platform_height() -> void:
    last_platform_height = screen_height - 2 * PLATFORM_SPACING # account for ground

func setup() -> void:
    for platform in platform_container.get_children():
        platform.queue_free()
        
    world.position.y = 0
    _reset_last_platform_height()
    points = 0
    lives = DEFAULT_LIVES
    lives_label.text = str(lives)
    playing = true
    player.respawn()
    player.visible = true
    
    # spawn floor platform
    platform_manager.spawn_platform(screen_height)
        
    while last_platform_height >= 0.0:
        _spawn_next_platform()
        
    gameover_container.visible = false
    player.died.connect(handle_death)
    
    
func handle_death() -> void:
    lives -= 1
    if lives < 0:
        handle_gameover()
        return
        
    lives_label.text = str(lives)
    player.respawn()
    player.pause()
    death_acc = DEATH_TIME
    
func handle_gameover() -> void:
    print("Game over")
    player.visible = false
    gameover_container.visible = true
    playing = false

func _physics_process(delta: float) -> void:
    if not playing:
        return
        
    _move_world(delta)
    if player.paused:
        player.respawn()

    var world_height := -world.position.y
    while world_height <= last_platform_height - PLATFORM_SPACING:
        _spawn_next_platform()
        
    if player.paused:
        death_acc -= delta
        if death_acc < 0:
            player.unpause()
    _prune_old_platforms()
    _adjust_speed(delta)
    
func _move_world(delta: float) -> void:
    # points are number of scrolled pixels
    var dy := scrolling_speed * delta
    points += int(dy)
    points_label.text = "%010d" % points
    
    world.position.y += dy

func _process(delta: float) -> void:
    if not playing:
        if Input.is_action_pressed("restart"):
            setup()
    
func _prune_old_platforms() -> void:
    for platform in platform_container.get_children():
        var plat := platform as Node2D
        if not plat:
            continue
            
        if plat.position.y > screen_height:
            platform_container.remove_child(platform)
            
func _adjust_speed(delta: float) -> void:
    var target_speed := DEFAULT_SCROLLING_SPEED
    if player.global_position.y < screen_height * player_threshold:
        # player within fast screen threshold
        target_speed = FAST_SCROLLING_SPEED
        
    scrolling_speed = move_toward(scrolling_speed, target_speed, 2)
    print(scrolling_speed)


func _spawn_next_platform() -> void:
    last_platform_height -= PLATFORM_SPACING
    platform_manager.spawn_platform(last_platform_height)
