extends CharacterBody2D

# --- VARIABLES ---



# 
var form_list = ['Pieface', 'Mocha', 'Cotton']
var player_form = form_list[1]


# -- SPRITES --
## Individual forms' sprites
@onready var COTTON_SPRITE = $"Body Sprites/Cotton Sprite"
@onready var MOCHA_SPRITE = $"Body Sprites/Mocha Sprite"
@onready var PIEFACE_SPRITE = $"Body Sprites/Pieface Sprite"
## List of forms' sprites
@onready var PLAYER_SPRITES = [COTTON_SPRITE, MOCHA_SPRITE, PIEFACE_SPRITE]

# -- COLLISION --
## Main collision
@onready var body_collision = $"Body Collision"
## Individual forms' collision measures
### Measure array : [radius,height, position.y]
var COTTON_COLLISION_MEASURE = [5,12, -5]
var MOCHA_COLLISION_MEASURE = [4, 12, -4]
var PIEFACE_COLLISION_MEASURE = [3,8, -3]


# Attributes
## 
var speed : float
## Determines jump forces: [high,wide].
var jump_force : Array
## 
var weight : float

# --- PHYSICS LOOP ---
## 
func _physics_process(delta):
	formAttributes()
	formSwap()
	
	shape()
	
	animate()
	
	# Base physics
	move_and_slide()
	
	walk()
	jump()
	crawl()
	climb()
	
	gravity(delta)



# --- FORM ATTRIBUTES ---
## Current form's sprite
var form_sprite : AnimatedSprite2D
func formAttributes():
	# - Forms' Attributes -
	var form_collision_measure : Array
	## PIEFACE
	if player_form == 'Pieface':
		form_sprite = PIEFACE_SPRITE
		form_collision_measure = PIEFACE_COLLISION_MEASURE
		#
		speed = 8
		jump_force = [4,8]
		weight = 1
	
	## MOCHA
	elif player_form == 'Mocha':
		form_sprite = MOCHA_SPRITE
		form_collision_measure = MOCHA_COLLISION_MEASURE
		#
		speed = 5
		jump_force = [8,4]
		weight = 2
		
	## COTTON
	elif player_form =='Cotton':
		form_sprite = COTTON_SPRITE
		form_collision_measure = COTTON_COLLISION_MEASURE
		#
		speed = 3
		jump_force = [4,1]
		weight = 4
	
	# Sprite visibility
	for i in PLAYER_SPRITES:
		if i == form_sprite:
			i.visible = true
		else:
			i.visible = false
	
	# Apply collision values
	## Apply crawling values
	if is_crawling:
		body_collision.shape.radius = form_collision_measure[0] / 2
		body_collision.shape.height = form_collision_measure[1] / 2
		body_collision.position.y = form_collision_measure[2] / 2
	## Apply basic values
	else:
		body_collision.shape.radius = form_collision_measure[0]
		body_collision.shape.height = form_collision_measure[1]
		body_collision.position.y = form_collision_measure[2]


# --- FORM SWAP ---
func formSwap():
	if Input.is_action_just_pressed("INTERACT"):
		if player_form == 'Pieface':
			player_form = 'Mocha'
		elif player_form == 'Mocha':
			player_form = 'Cotton'
		elif player_form == 'Cotton':
			player_form = 'Pieface'


# --- SHAPE ---
## Alter the shape of collisions
func shape():
	# Direction vairable
	var direction = Input.get_axis('LEFT','RIGHT')
	
	# Flip crawl check collisions
	## Variables
	var CRAWL_UPPER_COLLISION = $"Area Checks/Crawl Checks/Crawl Upper-Check/CollisionShape2D"
	var CRAWL_LOWER_COLLISION = $"Area Checks/Crawl Checks/Crawl Lower-Check/CollisionShape2D"
	## 
	if direction != 0:
		CRAWL_UPPER_COLLISION.position.x = abs(CRAWL_UPPER_COLLISION.position.x) * direction
		CRAWL_LOWER_COLLISION.position.x = abs(CRAWL_LOWER_COLLISION.position.x) * direction
	
	# Reposition crawl upper check based on player form
	if player_form == 'Mocha':
		CRAWL_UPPER_COLLISION.position.y = -7
	elif player_form == 'Pieface':
		CRAWL_UPPER_COLLISION.position.y = -4
	else:
		pass

# --- ANIMATION ---
##
@onready var ANIMATE = $"Body Sprites/AnimationPlayer"
func animate():
	# If no movement
	if not velocity:
		ANIMATE.play('idle')
	
	# - Turn sprites -
	var direction = Input.get_axis('LEFT','RIGHT')
	## Flip all sprites based on input direction.
	for i in PLAYER_SPRITES:
		if direction <0:
			i.flip_h = true
		elif direction >0:
			i.flip_h = false



# --- MOVEMENT ---

# -- WALK --
func walk():
	
	var direction = Input.get_axis('LEFT','RIGHT')
	#
	if direction != 0:
		if is_on_floor():
			ANIMATE.play('walk')
		velocity.x = speed*15 * direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed*100)



# -- JUMP --
# OLD JUMP -- UPDATE WHEN ABLE
func jump():
	# Determine if can jump
	var can_jump : bool
	## Cannot jump if off floor
	if not is_on_floor():
		can_jump = false
	## Can jump
	else:
		can_jump = true
	
	# Perform jump on press
	if Input.is_action_just_pressed("JUMP") and can_jump:
		ANIMATE.play('jump')
		velocity.y += jump_force[0]*-50

# -- CRAWL --
@onready var CRAWL_UPPER_CHECK = $"Area Checks/Crawl Checks/Crawl Upper-Check"
@onready var CRAWL_LOWER_CHECK = $"Area Checks/Crawl Checks/Crawl Lower-Check"
var is_crawling : bool
func crawl():
	var can_crawl : bool
	if not is_on_floor():
		can_crawl = false
	elif player_form == 'Cotton':
		can_crawl = false
	else:
		can_crawl = true
	
	# 
	if CRAWL_UPPER_CHECK.has_overlapping_bodies() and not CRAWL_LOWER_CHECK.has_overlapping_bodies() and can_crawl:
		is_crawling = true
	else:
		is_crawling = false
	
	# 
	if is_crawling:
		ANIMATE.play('crawl')



# -- CLIMB --
## Ladder func is in ladder object
@onready var CLIMB_CHECK = $"Area Checks/Climb Check"
func climb():
	var can_climb : bool
	# Determine if can climb
	## If Cotton, cannot climb
	if player_form == 'Cotton':
		can_climb = false
	else:
		can_climb = true
	
	var nonzero_direction
	if Input.get_axis('LEFT','RIGHT') != 0:
		nonzero_direction = Input.get_axis('LEFT','RIGHT')
	
	if Input.is_action_pressed('UP') and is_on_wall() and can_climb:
		ANIMATE.play('climb flat')
		velocity.y = -50
		velocity.x += 2 * nonzero_direction



# --- MISC ---

# -- GRAVITY --
func gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
