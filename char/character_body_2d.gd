extends CharacterBody2D

# Переменные для движения
var SPEED = 100.0
const JUMP_VELOCITY = -400.0
const BOOSTED_SPEED = 180

# Переменные для ускорения
var IS_BOOST = false # флаг ускорения
var BOOST_DURATION = 5.0 # длительность ускорения в секундах
var BOOST_TIMER = 0.0 # таймер для отслеживания времени ускорения

var HEALTH = 100;

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Добавление гравитации
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Прыжок
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")

	# Направление движения
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("idle")

	# Анимация переворота персонажа
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1: 
		$AnimatedSprite2D.flip_h = false

	# Анимация падения
	if velocity.y > 0:
		anim.play("fall")
	
	# Ускорение при нажатии Shift, если можно ускоряться (CAN_BOOST)
	if Input.is_action_pressed("ui_shift") and not IS_BOOST:
		IS_BOOST = true
		SPEED = BOOSTED_SPEED # Увеличенная скорость
		anim.speed_scale = 2.0
		BOOST_TIMER = BOOST_DURATION # Запуск таймера ускорения

	else:
		# Если Shift не зажат, используем обычную скорость
		IS_BOOST = false
		SPEED = 100
		anim.speed_scale = 1.0
		
	# Если персонаж ускоряется, обновляем таймер ускорения
	if IS_BOOST:
		BOOST_TIMER -= delta
		
		if BOOST_TIMER <= 0:
			IS_BOOST = false # Ускорение закончилось
			SPEED = 100 # Возвращаем обычную скорость
	
	if HEALTH <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	# Движение персонажа
	move_and_slide()
