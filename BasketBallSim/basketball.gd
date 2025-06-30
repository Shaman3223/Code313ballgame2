extends RigidBody3D

func shoot(x,z, y,angle, pow):
	
	linear_velocity.x += x * pow
	linear_velocity.z += z * pow
	linear_velocity.y += y * pow


func _physics_process(delta: float) -> void:
	
	linear_velocity.y -= 9.8 * delta





func _on_body_entered(body: Node) -> void:
	queue_free() 
