package main

import "core:fmt"
// import alg "core:math/linalg"
// import rng "core:math/rand"
import rl "vendor:raylib"

main :: proc() {
	SCREEN_WIDTH :: 2048
	SCREEN_HEIGHT :: 2048
	fmt.println("hey")
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Tetroid")
	defer rl.CloseWindow()

	init_game()

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		update_state()
		draw_game()
	}
}

init_game :: proc() {
	init_terrain()

}

update_state :: proc() {

}

draw_game :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
}

cells :: Map3d{}

init_terrain :: proc() {
	for zs in cells {
		for ys in zs {
			for x in ys {

				_ = x
			}
		}
	}
}

/* data types */

Vector2 :: struct {
	x: f32,
	y: f32,
}

Cell :: struct {}

MAP_SIZE: [3]uint : {2, 255, 255}
Map3d :: [MAP_SIZE.z][MAP_SIZE.y][MAP_SIZE.x]Cell
