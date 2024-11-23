package main

import fmt "core:fmt"
import "core:math/noise"
// import rng "core:math/rand"


CellStore :: [dynamic]^Cell

init_terrain :: proc(cells: ^CellStore) {
	seed: i64 : 1987298

	resize(cells, cfg.cell_store.size)

	for i in 0 ..< cfg.cell_store.size {
		x, y, z := indexToXYZ(i)

		v := noise.Vec3{f64(x), f64(y), f64(z)}
		n := noise.noise_3d_improve_xz(seed, v)

		cell, err := new(Cell) // NOTE un-reaped allocation here 

		if err != nil {
			panic("Failed allocation")
		}

		if n > 0.7 {
			cell^ = Cell {
				material = .Dirt,
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
}

indexToXYZ :: proc(i: uint) -> (uint, uint, uint) {
	max :: cfg.cell_store.max
	z: uint = i / (max.x * max.y)
	y: uint = i / max.x
	x: uint = i % max.x
	return x, y, z
}

XYZtoIndex :: proc(x: uint, y: uint, z: uint) -> uint {
	max :: cfg.cell_store.max
	return z * (max.x * max.y) + y * max.x + x
}

getCellByXYZ :: proc(x: uint, y: uint, z: uint, cells: ^CellStore) -> ^Cell {
	i := XYZtoIndex(x, y, z)
	return &cells[i]^
}

isPassableTerrain :: proc(cell: ^Cell) -> bool {
	if cell == nil {return false}
	if cell.depth == .Solid {
		return false
	}
	return true
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

TerrainMaterial :: enum {
	Dirt,
	LooseDirt,
	Sand,
	Mud,
	Rocks,
	Sandstone,
	Granite,
	Marble,
	Slate,
	Limestone,
	Basalt,
	Quartz,
}

// FloorType :: enum {
// 	Natural,
// }

// Floor :: struct {
// 	material: TerrainMaterial, // union w ..?
// }
