package main

// we need these for computed vars, 
// but lets hide them in here and just expose a cute little Config struct.
// 
@(private = "file")
TILE_SIZE: i32 : 8
@(private = "file")
SCREEN_WIDTH :: 1048
@(private = "file")
SCREEN_HEIGHT :: 800
@(private = "file")
CELL_STORE_LEN :: [3]uint{255, 255, 1}
@(private = "file")
CELL_STORE_SIZE: uint : CELL_STORE_LEN.x * CELL_STORE_LEN.y * CELL_STORE_LEN.z

Config :: struct {
	screen:     struct {
		width, height: i32,
	},
	tiles:      struct {
		size:    i32,
		visible: struct {
			x: i32,
			y: i32,
		},
		// visible_x, visible_y: i32,
	},
	cell_store: struct {
		size: uint,
		max:  struct {
			x, y, z: uint,
		},
	},
}


cfg :: Config {
	screen = {width = SCREEN_WIDTH, height = SCREEN_HEIGHT},
	tiles = {
		size = TILE_SIZE,
		visible = {x = SCREEN_WIDTH / TILE_SIZE, y = SCREEN_HEIGHT / TILE_SIZE},
	},
	cell_store = {
		size = CELL_STORE_SIZE,
		max = {CELL_STORE_LEN.x, CELL_STORE_LEN.y, CELL_STORE_LEN.z},
	},
}
