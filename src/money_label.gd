extends Label


func _ready() -> void:
	Global.change_money.connect(update_label)
	update_label(0)

func update_label(_unused):
	text = "Money: %d" % Global.money
