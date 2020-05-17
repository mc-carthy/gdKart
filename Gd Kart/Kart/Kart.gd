extends Spatial

export var input_force: float = 50.0
export var steering_speed: float = 1.0

onready var mesh = $Mesh
onready var sphere: RigidBody = $Sphere

func _ready() -> void:
	sphere.set_as_toplevel(true)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var longitudinal_input: float = 0
	var lateral_input: float = 0
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
	
	
