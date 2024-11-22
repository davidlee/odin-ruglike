package main

import "core:fmt"
// import alg "core:math/linalg"
// import rng "core:math/rand"
import "core:math/noise"
// noise_3d_improve_xz(x, y, Z)
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

cells := Map3d{}

init_terrain :: proc() {
	seed: i64 : 1987298
	for &zs, z in cells {
		for &ys, y in zs {
			for &cell, x in ys {

				v := noise.Vec3{f64(x), f64(y), f64(z)}
				n := noise.noise_3d_improve_xz(seed, v)
				if n > 0.5 {
					cell.material = .Sandstone
					cell.depth = .Solid
					// ys[x] = Cell{}
				} else {
					cell.material = .Dirt
					cell.depth = .Empty
					// ys[x] = Cell{}
				}
			}
		}
	}
}

/* data types */

Vector2 :: struct {
	x: f32,
	y: f32,
}

// 1 cell of rock / dirt expands to 2 cells of loose dirt / rubble
// sand or quarried stone is 1:1
// 
CellFillDepth :: enum {
	Empty, // normal movement
	Partial, // rough terrain
	Solid, // impassable
}

Cell :: struct {
	material: Maybe(TerrainMaterial),
	depth:    CellFillDepth,
	floor:    Maybe(Floor),
	// creature: Maybe(int),
	items:    []int,
	features: []int, // pos: floor / ceiling / wall / middle ? 
	liquid:   Maybe(int),
	gas:      Maybe(int),
}

// FloorType :: enum {
// 	Natural,
// }

Floor :: struct {
	material: TerrainMaterial, // union w ..?
}

TerrainMaterial :: enum {
	Dirt,
	Mud,
	Rocks,
	Sandstone,
	Granite,
	Marble,
	Slate,
}

Direction :: enum {
	North,
	East,
	South,
	West,
	NorthEast,
	SouthEast,
	SouthWest,
	NorthWest,
}

// CardinalDirection := Direction[:4]

Direction_Vectors :: [Direction][2]int {
	.North     = {0, -1},
	.East      = {+1, 0},
	.South     = {0, +1},
	.West      = {-1, 0},
	.NorthEast = {+1, +1},
	.SouthEast = {+1, +1},
	.SouthWest = {-1, +1},
	.NorthWest = {-1, -1},
}


MAP_SIZE: [3]uint : {2, 255, 255}
Map3d :: [MAP_SIZE.z][MAP_SIZE.y][MAP_SIZE.x]Cell
