extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
var CHASE = false
var ATACK = false
var ALIVE = true

@onready var ANIMATION = $AnimatedSprite2D
@onready var player = $"../../player/player"

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if ALIVE == true:
		var direction = (player.position - self.position).normalized()
		
		var distance = self.position.distance_to(player.position)
				
		if CHASE and distance > 42:
			ANIMATION.play("run")
			velocity.x = direction.x * SPEED
			
		else: 
			velocity.x = 0
			CHASE = false
			ANIMATION.play("idle")
			
		if direction.x > 0 :
			$AnimatedSprite2D.flip_h = true
		else: 
			$AnimatedSprite2D.flip_h = false
	else:
		$death_area/death_collision.set_deferred("disabled", true)
			
	move_and_slide()


func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		CHASE = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player":
		CHASE = false

func _on_death_area_body_entered(body: Node2D) -> void:
		if body.name == "player":
			player.velocity.y = -200
			death()
	
func death():
	ALIVE = false
	ANIMATION.play("death")
	await ANIMATION.animation_finished
	queue_free()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if ALIVE:
			body.HEALTH -= 25
		
