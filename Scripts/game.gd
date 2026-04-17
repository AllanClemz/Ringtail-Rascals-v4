extends Node2D

# Game
@onready var GAME = $"."
# Player
@onready var PLAYER = $"Player Body" 

# Node Banks
@onready var ROOM_BANK = get_tree().get_nodes_in_group("Room Group")
var CAMERA_BANK : Array
var CAMERA_AREA_BANK : Array

## Array of room groups: [[Room,Camera,Area],[Room,Camera,Area],...]
var LARGE_BANK : Array

# --- ON READY ---
func _ready():
	cameraSTART()

# --- LOOP ---
func _process(_delta):
	camera()


# --- CAMERA ---

func cameraSTART():
	# Find cameras
	for i in ROOM_BANK:
		for x in i.get_children():
			# Append room's camera to camera bank
			if x is Camera2D:
				CAMERA_BANK.append(x)
	
	# Camera Areas
	for i in CAMERA_BANK:
		# Create nodes for area
		## Area node
		var camera_area = Area2D.new()
		## Area collision
		var area_collision = CollisionShape2D.new()
		## Area shape node
		var collision_shape = RectangleShape2D.new()
		
		# Build area node
		## Apply area collision to camera area
		camera_area.add_child(area_collision)
		## Apply collision shape to area collision
		area_collision.add_child(collision_shape)
		
		# Configure area shape
		## Define camera's size
		var camera_width : int = abs(i.limit_right - i.limit_left)
		var camera_height : int = abs(i.limit_bottom - i.limit_top)
		## Match area shape's size to camera's size
		collision_shape.size = Vector2(camera_width,camera_height)
		
		# Large bank
		## Appends [Room,Camera,Area]
		LARGE_BANK.append([i.get_parent(),i,camera_area])
	
	print(LARGE_BANK)



func camera():
	
	
	
	# View from outer view
	if Input.is_action_pressed("DOWN"):
		$"Player Body/Out View".make_current()





func OLDcamera():
	var original_parent
	var current_camera
	# Find which camera has player in area
	for i : Area2D in CAMERA_AREA_BANK:
		# Detect bodies in camera's area
		for x in i.get_overlapping_bodies():
			# If body is the player body
			if x is CharacterBody2D:
				# Look at siblings of area
				for y in i.get_parent().get_children():
					if y is Camera2D:
						# Assign area's parent as camera's original parent
						original_parent = i.get_parent()
						# Assign camera as current
						current_camera = y
						# Reparent camera
						y.reparent(x)
						y.transform = x.transform
						y.make_current()
						# Leave camera after
	for x in CAMERA_BANK:
		if x != current_camera:
			x.reparent(original_parent)
		print(x.get_parent())
	
	
	# View from outer view
	if Input.is_action_pressed("DOWN"):
		$"Player Body/Out View".make_current()


func OLDcameraStart():
	var SCENE = $"Apartment Level"
	# Get room nodes
	for i in SCENE.get_children():
		if i.is_in_group('Room Group'):
			ROOM_BANK.append(i)
	# Get camera nodes
	## Count of rooms
	for i in ROOM_BANK:
		# Get rooms' cameras
		for x in i.get_children():
			if x is Camera2D:
				CAMERA_BANK.append(x)
	
	# - Give each camera an area -
	for i : Camera2D in CAMERA_BANK:
		# Create nodes for this camera
		## Create area node for camera
		var camera_area = Area2D.new()
		## Create rectangle collision node for camera's area node
		var camera_area_collision = CollisionShape2D.new()
		
		# Move those nodes as children of this camera
		## Move collision node as child of area
		camera_area.add_child(camera_area_collision)
		## Move area node as child of camera
		i.add_child(camera_area)
		
		# Change area's collision node to size as camera size
		## Camera width and height values
		var camera_width : int = abs(i.limit_right - i.limit_left)
		var camera_height : int = abs(i.limit_bottom - i.limit_top)
		## Create collision rectangle shape
		var area_collision_shape = RectangleShape2D.new()
		## Define size as camera size
		area_collision_shape.size = Vector2(camera_width,camera_height)
		## Apply rectangle shape as area collision's shape
		camera_area_collision.shape = area_collision_shape
		# Change area's collision node to position at camera
		## Tiles are even, so cameras will always be even
		@warning_ignore("integer_division")
		camera_area_collision.transform.origin = Vector2(camera_width/2,camera_height/2)
		
				# Append area to array
		CAMERA_AREA_BANK.append(camera_area)
		
		# Name camera area
		i.name = get_parent().name + " Camera"
		# Reparent area to room
		camera_area.reparent(i.get_parent())
		
		# Starter camera
		$"Player Body/Out View".make_current()
