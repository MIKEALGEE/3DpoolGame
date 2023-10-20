extends Area3D
class_name Pocket

func _on_body_entered(body: Node3D) -> void:
	if body is Ball:
		GameEvents.ball_potted.emit(body,self)
		
		#if body.ball_type == Enums.BallType.CUE_BALL:
			#body.freeze = false
