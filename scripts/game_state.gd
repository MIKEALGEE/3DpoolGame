extends Resource
class_name GameState

@export var current_player_id: int

@export var current_play_state: Enums.PlayState:
	set(new_play_state):
		current_play_state = new_play_state
		GameEvents.play_state_changed.emit()

@export var ball_suit_by_player_id: Array[Enums.BallType]

@export var balls_remaining_by_player_id:Array[int]
