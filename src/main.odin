package main

import fmt "core:fmt"
// import alg "core:math/linalg"
import rl "vendor:raylib"

Command :: Direction

Game :: struct {
	cells:   ^CellStore,
	player:  ^Player,
	command: Direction,
	config:  struct {
		screen: struct {
			width:  int,
			height: int,
		},
	},
	assets:  Assets,
}

Assets :: struct {
	sounds: struct {
		beep: ^rl.Sound,
	},
}

main :: proc() {
	_ = fmt.printfln

	rl.InitWindow(cfg.screen.width, cfg.screen.height, "Firedamp")
	defer rl.CloseWindow()

	rl.InitAudioDevice()
	defer rl.CloseAudioDevice()

	sound := rl.LoadSound("assets/bip.wav")

	cells := CellStore{}

	player := Player{}

	game := Game {
		cells = &cells,
		player = &player,
		command = .None,
		assets = {sounds = {beep = &sound}},
	}

	init_game(&game)

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		update_state(&game)
		draw_game(&game)
	}
}

init_game :: proc(game: ^Game) {
	init_terrain(game.cells)
	init_player(game)
}

update_state :: proc(game: ^Game) {
	process_input(game)
	apply_command(game)
}

draw_game :: proc(game: ^Game) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	draw_terrain(game)
	draw_player(game)
}

draw_player :: proc(game: ^Game) {
	rl.DrawRectangle(
		posX = i32(game.player.pos.x) * cfg.tiles.size,
		posY = i32(game.player.pos.y) * cfg.tiles.size,
		width = cfg.tiles.size,
		height = cfg.tiles.size,
		color = rl.RED,
	)
}

draw_terrain :: proc(game: ^Game) {
	for cell, i in game.cells {
		if cell != nil {
			x, y, _ := indexToXYZ(uint(i))

			px: i32 = i32(x) * cfg.tiles.size
			py: i32 = i32(y) * cfg.tiles.size

			color: rl.Color

			if cell.depth == .Solid {
				color = rl.DARKBROWN
			} else {
				color = rl.BLACK
			}
			rl.DrawRectangle(
				posX = px,
				posY = py,
				width = cfg.tiles.size,
				height = cfg.tiles.size,
				color = color,
			)
		}
	}
}

/* data types */

Direction :: enum {
	None = 0,
	North,
	East,
	South,
	West,
	NorthEast,
	SouthEast,
	SouthWest,
	NorthWest,
}

Cardinals := [4]Direction{.North, .East, .South, .West}
Ordinals := [4]Direction{.NorthEast, .SouthEast, .SouthWest, .NorthWest}

Direction_Vectors :: [Direction][2]int {
	.None      = {0, 0},
	.North     = {0, -1},
	.NorthEast = {+1, -1},
	.East      = {+1, 0},
	.SouthEast = {+1, +1},
	.South     = {0, +1},
	.SouthWest = {-1, +1},
	.West      = {-1, 0},
	.NorthWest = {-1, -1},
}
