class_name PlatformManager extends Node2D

@export var gap := 100 # px
@export var platform_scene: PackedScene
@export var container: Node2D

func spawn_platform(y: float) -> Platform:
    var screen_height := get_viewport_rect().size.y
    var platform := platform_scene.instantiate() as Platform
    
    platform.position.y = y
    platform.position.x = _random_x(platform.get_size().x)
    
    container.add_child(platform as Node2D)
    return platform
    
func _random_x(width: float) -> float:
    var screen_width := get_viewport_rect().size.x
    var half_width = width / 2
    
    return randf_range(
        -half_width,
        screen_width - half_width
    )
