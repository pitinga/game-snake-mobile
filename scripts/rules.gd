extends "res://scripts/rules_base.gd"

const WIDTH := 18
const HEIGHT := 22
var snake: Array[Vector2i] = []
var heading := Vector2i.RIGHT
var next_heading := Vector2i.RIGHT
var food := Vector2i(9, 8)
var elapsed := 0.0


func _init() -> void:
	title = "Snake"
	subtitle = "Pegue as frutas sem se chocar"


func reset() -> void:
	super.reset()
	snake = [Vector2i(8, 11), Vector2i(7, 11), Vector2i(6, 11)]
	heading = Vector2i.RIGHT
	next_heading = heading
	elapsed = 0.0
	_place_food()


func _place_food() -> void:
	var free: Array[Vector2i] = []
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var candidate := Vector2i(x, y)
			if not snake.has(candidate):
				free.append(candidate)
	if free.is_empty():
		ended = true
		message = "Você venceu!"
	else:
		food = free.pick_random()


func steer(direction: Vector2i) -> void:
	if direction != -heading and direction != Vector2i.ZERO:
		next_heading = direction


func swipe(a: Vector2, b: Vector2) -> void:
	var d := b - a
	if absf(d.x) > absf(d.y):
		steer(Vector2i.RIGHT if d.x > 0 else Vector2i.LEFT)
	else:
		steer(Vector2i.DOWN if d.y > 0 else Vector2i.UP)


func tap(p: Vector2) -> void:
	var d := p - Vector2(0.5, 0.5)
	if absf(d.x) > absf(d.y):
		steer(Vector2i.RIGHT if d.x > 0 else Vector2i.LEFT)
	else:
		steer(Vector2i.DOWN if d.y > 0 else Vector2i.UP)


func tick(delta: float) -> void:
	elapsed += delta
	var interval: float = maxf(0.08, 0.17 - score * 0.004)
	if elapsed >= interval:
		elapsed -= interval
		advance()


func advance() -> void:
	if ended:
		return
	heading = next_heading
	var head := snake[0] + heading
	var eating := head == food
	var body := snake.duplicate()
	if not eating:
		body.pop_back()
	if head.x < 0 or head.x >= WIDTH or head.y < 0 or head.y >= HEIGHT or body.has(head):
		ended = true
		message = "Fim da partida"
		return
	snake.push_front(head)
	if eating:
		score += 1
		_place_food()
	else:
		snake.pop_back()


func draw_game(canvas: CanvasItem, area: Rect2) -> void:
	var field := area.grow(-10)
	canvas.draw_rect(field, Color("e0f2ed"))
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var item := Vector2i(x, y)
			if snake.has(item):
				canvas.draw_rect(cell_rect(field, x, y, WIDTH, HEIGHT, 2), Color("177f68") if item != snake[0] else Color("095c4f"))
	canvas.draw_circle(cell_rect(field, food.x, food.y, WIDTH, HEIGHT, 0).get_center(), 12.0, Color("eb644c"))
