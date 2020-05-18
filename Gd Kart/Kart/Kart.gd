extends Spatial

export var input_force: float = 50.0
export var steering_speed: float = 1.0

onready var mesh = $Mesh
onready var steeringWheel: Spatial = $Mesh/SteeringWheel/Pivot/WheelMesh
onready var wheelPivotFL: Spatial = $Mesh/WheelFL/Pivot
onready var wheelPivotFR: Spatial = $Mesh/WheelFR/Pivot
onready var wheelFL: MeshInstance = $Mesh/WheelFL/Pivot/WheelFL
onready var wheelFR: MeshInstance = $Mesh/WheelFR/Pivot/WheelFR
onready var wheelRL: MeshInstance = $Mesh/WheelRL
onready var wheelRR: MeshInstance = $Mesh/WheelRR
onready var sphere: RigidBody = $Sphere

var longitudinal_input: float = 0
var lateral_input: float = 0

var max_steer_angle: float = 30.0
var current_steer_angle: float = 0
var target_steer_angle: float = 0

var steering_lerp_weight: float = 0.1

var max_steering_wheel_angle: float = 90
var current_steering_wheel_angle: float = 0
var target_steering_wheel_angle: float = 0

var wheel_spin_rate: float = 0.5
var current_spin_rate: float = 0.0

func _ready() -> void:
	sphere.set_as_toplevel(true)

func _process(delta: float) -> void:
	target_steer_angle = lateral_input * deg2rad(max_steer_angle)
	current_steer_angle = lerp(current_steer_angle, target_steer_angle, steering_lerp_weight)
	wheelPivotFL.set_rotation(Vector3(0, current_steer_angle, 0))
	wheelPivotFR.set_rotation(Vector3(0, current_steer_angle, 0))
	
	current_spin_rate = sphere.linear_velocity.z * delta * wheel_spin_rate
	wheelFL.rotate(Vector3.BACK, current_spin_rate)
	wheelFR.rotate(Vector3.FORWARD, current_spin_rate)
	wheelRL.rotate(Vector3.RIGHT, current_spin_rate)
	wheelRR.rotate(Vector3.RIGHT, current_spin_rate)
	
	target_steering_wheel_angle = lateral_input * deg2rad(max_steering_wheel_angle)
	current_steering_wheel_angle = lerp(current_steering_wheel_angle, target_steering_wheel_angle, steering_lerp_weight)
	steeringWheel.set_rotation(Vector3(0, 0, current_steering_wheel_angle))

func _physics_process(delta: float) -> void:
	longitudinal_input = 0
	lateral_input = 0
	if Input.is_action_pressed('ui_left'):
		lateral_input += 1
	if Input.is_action_pressed('ui_right'):
		lateral_input -= 1
	if Input.is_action_pressed('ui_up'):
		longitudinal_input += 1
	if Input.is_action_pressed('ui_down'):
		longitudinal_input -= 1

	rotate(Vector3.UP, lateral_input * delta * steering_speed)
	sphere.apply_impulse(Vector3.ZERO, longitudinal_input * get_global_transform().basis.z * input_force * delta)
	#sphere.apply_central_impulse(Vector3.FORWARD * 10)
	translation = sphere.translation
	
	
