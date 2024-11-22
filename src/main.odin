package main

import "core:fmt"
// import alg "core:math/linalg"
// noise_3d_improve_xz(x, y, Z)
import rl "vendor:raylib"

TILE_SIZE: i32 : 8

main :: proc() {
	SCREEN_WIDTH :: 1048
	SCREEN_HEIGHT :: 800

	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Firedamp")
	defer rl.CloseWindow()


	cells := CellStore{}
	defer delete(cells)

	init_game(&cells)

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		update_state()
		draw_game(&cells)
	}
}

init_game :: proc(cells: ^CellStore) {
	init_terrain(cells)
}

update_state :: proc() {
	process_input()
	validate_commands()
	perform_commands()
}


draw_game :: proc(cells: ^CellStore) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	for cell, i in cells {
		if cell != nil {
			x, y, z := indexToXYZ(uint(i))

			px: i32 = i32(x) * TILE_SIZE
			py: i32 = i32(y) * TILE_SIZE

			color: rl.Color

			if cell.depth == .Solid {
				color = rl.DARKGREEN
			} else {
				color = rl.BLACK
			}
			rl.DrawRectangle(
				posX = px,
				posY = py,
				width = TILE_SIZE,
				height = TILE_SIZE,
				color = color,
			)
		}
	}
}

/* data types */

Vector2 :: struct {
	x: f32,
	y: f32,
}

CardinalDirection :: enum {
	North = 0,
	East  = 2,
	South = 4,
	West  = 6,
}
OrdinalDirection :: enum {
	NorthEast = 1,
	SouthEast = 3,
	SouthWest = 5,
	NorthWest = 7,
}

Direction :: union {
	CardinalDirection,
	OrdinalDirection,
}

// CardinalDirection := Direction[:4]

Direction_Vectors :: [8][2]int {
	CardinalDirection.North    = {0, -1},
	OrdinalDirection.NorthEast = {+1, +1},
	CardinalDirection.East     = {+1, 0},
	OrdinalDirection.SouthEast = {+1, +1},
	CardinalDirection.South    = {0, +1},
	OrdinalDirection.SouthWest = {-1, +1},
	CardinalDirection.West     = {-1, 0},
	OrdinalDirection.NorthWest = {-1, -1},
}

//    Octant data
//
//    \ 1 | 2 /
//   8 \  |  / 3
//   -----+-----
//   7 /  |  \ 4
//    / 6 | 5 \
//
//  1 = NNW, 2 =NNE, 3=ENE, 4=ESE, 5=SSE, 6=SSW, 7=WSW, 8 = WNW
