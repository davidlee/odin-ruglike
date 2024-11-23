package main
import "core:fmt"
import rl "vendor:raylib"

XYZ :: [3]uint

Player :: struct {
	pos: XYZ, // xyz
}

init_player :: proc(game: ^Game) {
	game.player.pos = {50, 50, 0}
}

MoveKeyMap :: struct {
	key: rl.KeyboardKey,
	dir: Direction,
}

MOVE_KEYS: [4]MoveKeyMap : {{.UP, .North}, {.DOWN, .South}, {.LEFT, .West}, {.RIGHT, .East}}

MOVE_KEYS_SHIFTED: [4]MoveKeyMap : {
	{.UP, .NorthWest},
	{.DOWN, .SouthEast},
	{.LEFT, .SouthWest},
	{.RIGHT, .NorthEast},
}

process_input :: proc(game: ^Game) {
	shifted := rl.IsKeyDown(.LEFT_SHIFT) || rl.IsKeyDown(.RIGHT_SHIFT)
	keymap := shifted ? MOVE_KEYS_SHIFTED : MOVE_KEYS

	for x in keymap {
		if rl.IsKeyPressed(x.key) || rl.IsKeyPressedRepeat(x.key) {
			game.command = x.dir
		}
	}
}

// only movement commands for now
apply_command :: proc(game: ^Game) {

	direction := game.command
	if direction == nil {
		return
	}

	new_pos, err := validate_2d_move(game.player.pos, direction, game)
	game.command = .None

	if err != nil {
		rl.PlaySound(game.assets.sounds.beep^)
		fmt.printfln("Invalid movement command: %v", err)
		return
	} else {
		game.player.pos = new_pos
	}

}

CommandError :: enum {
	None = 0,
	OutOfBounds,
	ImpassableTerrain,
}

validate_2d_move :: proc(xyz: XYZ, direction: Direction, game: ^Game) -> (XYZ, CommandError) {
	directions := Direction_Vectors
	delta := directions[direction]

	xy: [2]int = {int(xyz.x), int(xyz.y)}
	sum: [2]int = xy + delta

	if sum.x < 0 ||
	   sum.y < 0 ||
	   sum.x > int(cfg.tiles.visible.x) ||
	   sum.y > int(cfg.tiles.visible.y) ||
	   sum.x > int(cfg.cell_store.max.x) ||
	   sum.y > int(cfg.cell_store.max.y) {
		return XYZ{}, .OutOfBounds
	}
	new_pos := XYZ{uint(sum.x), uint(sum.y), xyz.z}

	cell := getCellByXYZ(uint(sum.x), uint(sum.y), xyz.z, game.cells)
	if isPassableTerrain(cell) {
		return new_pos, nil
	} else {
		return XYZ{}, .ImpassableTerrain

	}
}


move :: proc() {}
