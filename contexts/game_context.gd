class_name GameContext extends Node2D

@onready var platform_manager: PlatformManager = $PlatformManager
@onready var player: Player = $World/Player
@onready var platform_container: Node2D = $World/Platforms
@onready var world: Node2D = $World
@onready var lives_label: Label = %LivesNumberLabel
@onready var points_label: Label = %PointsLabel
@onready var gameover_container: Container = %GameOverContainer

@export var DEFAULT_SCROLLING_SPEED := 200
@export var DEFAULT_LIVES := 3
@export var player_threshold := .4

var px_threshold := 200 # spawn platform every 200px
var scrolled_pxs: float = 0.0

var scrolling_speed := DEFAULT_SCROLLING_SPEED
var win_height: float = 0

var lives := 3
var points := 0
var DEATH_TIME := 1.5 # seconds
var death_acc := 0.0
var playing := true

func _ready() -> void:
    win_height = get_viewport_rect().size.y

func setup() -> void:
    for platform in platform_container.get_children():
        platform.queue_free()
        
    world.position.y = 0
    points = 0
    lives = DEFAULT_LIVES
    lives_label.text = str(lives)
    playing = true
    player.move_to_center()
    player.visible = true
    
    # spawn floor platform
    platform_manager.spawn_platform(win_height)
        
    for i in range(7):
        platform_manager.spawn_platform(
            win_height - ((i + 1) * 200)
        )
        
    gameover_container.visible = false
    player.died.connect(handle_death)
    
func handle_death() -> void:
    lives -= 1
    if lives < 0:
        handle_gameover()
        return
        
    lives_label.text = str(lives)
    player.move_to_center()
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
        player.move_to_center()

    scrolled_pxs += DEFAULT_SCROLLING_SPEED * delta
    if scrolled_pxs >= px_threshold:
        scrolled_pxs -= px_threshold
        platform_manager.spawn_platform(-world.position.y)
        
    if player.paused:
        death_acc -= delta
        if death_acc < 0:
            player.unpause()
    _prune_old_platforms()
    
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
            
        if plat.position.y > win_height:
            platform_container.remove_child(platform)
            
#func _adjust_speed() -> void:
    #if player.position.y + world.position.y < win_height * player_threshold:
        #scrolling_speed = 300
    #else:
        #scrolling_speed = DEFAULT_SCROLLING_SPEED
        #
    #
