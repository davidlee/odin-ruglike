package main

import fmt "core:fmt"
import "core:math/noise"
// import rng "core:math/rand"

init_terrain :: proc(cells: ^CellStore) {
	seed: i64 : 1987298

	resize(cells, CELL_STORE_SIZE)

	for i in 0 ..< CELL_STORE_SIZE {
		x, y, z := indexToXYZ(i)
		v := noise.Vec3{f64(x), f64(y), f64(z)}
		n := noise.noise_3d_improve_xz(seed, v)

		cell, err := new(Cell)

		if err != nil {
			fmt.println("FAILED TO ALLOC")
		}

		if n < 0.3 {
			cell^ = Cell {
				material = .Sandstone,
				depth    = .Solid,
			}
		} else {
			cell^ = Cell {
				material = nil,
				depth    = .Empty,
			}
		}
		cells[i] = cell
	}

	fmt.println("map done.")
}

indexToXYZ :: proc(i: uint) -> (uint, uint, uint) {
	z: uint = i / (CELL_STORE_LEN.x * CELL_STORE_LEN.y)
	y: uint = i / CELL_STORE_LEN.x
	x: uint = i % CELL_STORE_LEN.x
	return x, y, z
}

// ZYXtoIndex :: proc(z: uint, y: uint, x: uint) -> uint {
// 	return z * (CELL_STORE_LEN.x * CELL_STORE_LEN.y) + y * CELL_STORE_LEN.x + x
// }


// 1 cell of rock / dirt expands to 2 cells of loose dirt / rubble
// sand or quarried stone is 1:1
// 
CellFillDepth :: enum {
	Empty = 0, // normal movement
	Partial, // rough terrain
	Solid, // impassable
}

CellFeature :: struct {}

// CellFeatureLocation :: enum {
// 	Ceiling,
// 	Floor,
// 	Wall-North,
// 	Wall-East,
// 	Wall-South,
// 	Wall-West,
// }

FeatureType :: enum {
	Fountain,
	Statue,
	Workshop,
	Machine,
	Furniture,
	Light,
	Trap,
	Chest,
	Grate,
	Hatch,
	Engraving,
}

LiquidSubstance :: enum {
	None = 0,
	Water,
	Brine,
	Sewerage,
	Blood,
}

LiquidDepth :: enum {
	None = 0,
	Depth1,
	Depth2,
	Depth3,
	Depth4,
	Depth5,
}

Liquid :: struct {
	kind: LiquidSubstance,
}


Cell :: struct {
	material: Maybe(TerrainMaterial),
	depth:    CellFillDepth,
	// floor:    Maybe(Floor),
	// creature: Maybe(int),
	// items:    []int,
	// features: []int, // pos: floor / ceiling / wall(4) / middle ? 
	// liquid:   Maybe(int),
	// gas:      Maybe(int),
}

CELL_STORE_LEN :: [3]uint{255, 255, 1}
CELL_STORE_SIZE: uint : CELL_STORE_LEN.x * CELL_STORE_LEN.y * CELL_STORE_LEN.z
CellStore :: [dynamic]^Cell

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
