extends Label

func _ready():
	GameEvents.game_ended.connect(_on_game_ended)
	

func _on_game_ended(winning_player_id):
	self.visible = true
	self.text = "Player " + str(winning_player_id + 1) + " Wins!"
