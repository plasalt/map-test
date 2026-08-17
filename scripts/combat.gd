extends Control
@onready var playerhpbar = $player/playerhpbar
@onready var enemyhpbar = $enemy/enemyhpbar



func _ready() -> void:
	print(GameData.playerdata["hp"])
	pass



func _process(delta: float) -> void:
	playerhpbar.value -= 1
	pass
