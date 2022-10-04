extends Spatial

# Node references
onready var ball = $Ball
onready var car_mesh = $CarMesh
onready var ground_ray = $CarMesh/RayCast
onready var right_wheel = $CarMesh/wheel_frontRight
onready var left_wheel = $CarMesh/wheel_frontLeft
onready var body_mesh = $CarMesh/body

# Where to place the car mesh relative to the sphere
var SPHERE_OFFSET = Vector3(0, -1.0, 0)
# Engine power
var ACCELERATION = 0.15
# Turn amount, in degrees
var STEERING = 21.0
# How quickly the car turns
var TURN_SPEED = 5
# Below this speed, the car doesn't turn
var TURN_STOP_LIMIT = 0.75
# How much the body tilts when turning
var BODY_TILT = 35

# Variables for input values, default is player 1 input
var speed_input = 0
var rotate_input = 0
var up = "up_1"
var down = "down_1"
var left = "left_1"
var right = "right_1"


func _ready():
	ground_ray.add_exception(ball)

func _physics_process(_delta):
	# Keep the car mesh aligned with the sphere
	car_mesh.transform.origin = ball.transform.origin + SPHERE_OFFSET
	# Accelerate based on car's forward direction
	ball.apply_central_impulse(-car_mesh.global_transform.basis.z * speed_input)

func _process(delta):
	# Can't steer/accelerate when in the air, but wheels can still turn
	if not ground_ray.is_colliding():
		# Get STEERING input
		rotate_input = 0
		rotate_input += Input.get_action_strength(left)
		rotate_input -= Input.get_action_strength(right)
		rotate_input *= deg2rad(STEERING)
		# rotate wheels for effect
		right_wheel.rotation.y = rotate_input
		left_wheel.rotation.y = rotate_input
		
		var n = ground_ray.get_collision_normal()
		var xform = align_with_y(car_mesh.global_transform, n.normalized())
		car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)
		return
	
	speed_input = 0
	speed_input += Input.get_action_strength(up)
	speed_input -= Input.get_action_strength(down)
	speed_input *= ACCELERATION
	
	# Get STEERING input
	rotate_input = 0
	rotate_input += Input.get_action_strength(left)
	rotate_input -= Input.get_action_strength(right)
	rotate_input *= deg2rad(STEERING)
	
	# rotate wheels for effect
	right_wheel.rotation.y = rotate_input
	left_wheel.rotation.y = rotate_input
	
	TURN_SPEED = 5 * ball.linear_velocity.length() * 0.05
	if TURN_SPEED > 5:
		TURN_SPEED = 5
	
	var n = ground_ray.get_collision_normal()
	var xform = align_with_y(car_mesh.global_transform, n.normalized())
	car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10 * delta)
	
	# rotate car mesh
	if ball.linear_velocity.length() > TURN_STOP_LIMIT:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, rotate_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, TURN_SPEED * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		# tilt body for effect
		var t = -rotate_input * ball.linear_velocity.length() / BODY_TILT
		body_mesh.rotation.z = lerp(body_mesh.rotation.z, t, 10 * delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
