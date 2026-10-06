class_name Player extends CharacterBody2D

@export var SPEED := 800.0
@export var JUMP_VELOCITY := -1400.0

@onready var collision: CollisionShape2D = $CollisionShape2D

signal died

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps := 0
var paused := false

func jump() -> void:
    if jumps < 2:
        velocity.y = JUMP_VELOCITY
        jumps += 1
        
func move_to_center() -> void:
    var viewport := get_viewport_rect().size
    viewport.x = viewport.x / 2.0
    viewport.y = viewport.y / 2.0
    
    velocity = Vector2.ZERO
    
    global_position = viewport

func pause() -> void:
    paused = true
    collision.disabled = true
    
func unpause() -> void:
    paused = false
    collision.disabled = false

func _physics_process(delta: float) -> void:
    if is_on_floor():
        jumps = 0
    else:
        if jumps == 0:
            jumps = 1
    
    if Input.is_action_just_pressed("jump"):
        jump()
        unpause()
    
    var direction := Input.get_axis("move_left", "move_right")
    if direction:
        velocity.x = direction * SPEED
        unpause()
    else:
        # gracefully stop speed instead of immediate
        velocity.x = move_toward(velocity.x, 0, 100)
        
    if not paused and not is_on_floor():
        velocity.y += gravity * delta
        
    move_and_slide()
    wrap_h()
    check_died()
    
func check_died() -> void:
    var viewport_height := get_viewport_rect().size.y
    if global_position.y > viewport_height:
        global_position.y = 20
        died.emit()
    
    
func wrap_h() -> void:
    var viewport_width := get_viewport_rect().size.x
    
    if global_position.x < 0:
        global_position.x = viewport_width
    elif global_position.x > viewport_width:
        global_position.x = 0
