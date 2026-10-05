class_name Player extends CharacterBody2D

@export var SPEED := 800.0
@export var JUMP_VELOCITY := -1400.0

signal died

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps := 0

func jump() -> void:
    if jumps < 2:
        velocity.y = JUMP_VELOCITY
        jumps += 1

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta
    
    if is_on_floor():
        jumps = 0
    else:
        if jumps == 0:
            jumps = 1
    
    if Input.is_action_just_pressed("jump"):
        jump()
    
    var direction := Input.get_axis("move_left", "move_right")
    if direction:
        velocity.x = direction * SPEED
    else:
        # gracefully stop speed instead of immediate
        velocity.x = move_toward(velocity.x, 0, 100)
    
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
