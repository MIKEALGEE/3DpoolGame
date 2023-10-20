extends Camera3D


func _ready():
	GameEvents.cue_ball_hit.connect(_on_cue_ball_hit)

func _on_cue_ball_hit():
	self.make_current()
