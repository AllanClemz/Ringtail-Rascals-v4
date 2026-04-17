extends Node2D

# Player
@onready var PLAYER = $"Player Body" 

# Node Banks
var ROOM_BANK : Array
var CAMERA_BANK : Array
var CAMERA_AREA_BANK : Array

# --- ON READY ---
func _ready():
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
	
	# Camera On Start
	current_camera = CAMERA_BANK[0]

# --- LOOP ---
func _process(_delta):
	# Find which camera has player in area
	for i : Area2D in CAMERA_AREA_BANK:
		# Detect bodies in camera's area
		for x in i.get_overlapping_bodies():
			# If body is the player body
			if x == PLAYER:
				for y in i.get_parent().get_children():
					if y is Camera2D:
						# Assign area's parent as camera's original parent
						var original_parent = i.get_parent()
						# Assign camera as current
						print(y)
						# Reparent camera
						y.reparent(x)
						y.transform = x.transform
						y.make_current()
						# Leave camera after
						if i.body_exited:
							y.reparent(original_parent)
	
	
	# TEMP
	if Input.is_action_pressed("DOWN"):
		$"Player Body/Out View".make_current()
	
