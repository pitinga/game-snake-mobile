extends SceneTree

const Rules := preload("res://scripts/rules.gd")
var failures := 0


func check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		push_error(label)


func _initialize() -> void:
	var game = Rules.new()
	game.reset()
	check(game.snake.size() == 3, "comprimento inicial")
	game.steer(Vector2i.LEFT)
	check(game.next_heading == Vector2i.RIGHT, "não permite reversão imediata")
	game.food = Vector2i(9, 11)
	game.advance()
	check(game.snake.size() == 4 and game.score == 1, "comer aumenta corpo e placar")
	game.steer(Vector2i.UP)
	game.advance()
	check(game.snake[0] == Vector2i(9, 10), "mudança de direção")
	game.snake.clear()
	game.snake.append(Vector2i(17, 5))
	game.snake.append(Vector2i(16, 5))
	game.heading = Vector2i.RIGHT
	game.next_heading = Vector2i.RIGHT
	game.advance()
	check(game.ended, "colisão com parede")
	game.reset()
	check(not game.ended and game.score == 0, "reinício")
	finish()


func finish() -> void:
	print("Snake: %s" % ("OK" if failures == 0 else "%d falhas" % failures))
	quit(0 if failures == 0 else 1)
