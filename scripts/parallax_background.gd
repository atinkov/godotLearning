extends ParallaxBackground

var backgroundMoveSpeed = 50;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_offset.x -= backgroundMoveSpeed * delta
