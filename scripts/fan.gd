extends Area3D

@onready var blades = $Blades
@onready var fan_air = $Air

const rot_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	blades.rotate_y(deg_to_rad(rot_speed))

func _on_body_entered(body: Node3D) -> void:
	if Input.is_action_pressed("move_jump"):
		Global.fanTime = true


func _on_body_exited(body: Node3D) -> void:
	Global.fanTime = false
