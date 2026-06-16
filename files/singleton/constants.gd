extends Node

const SKY_COLOR: Color = Color8(54, 58, 79)

#region Tile
const TILE_SIZE_X: float = 2.0
const TILE_SIZE_Z: float = 1.75

const HEIGHT_MULTIPLIER : int = 24
#endregion

#region Chunk
const CHUNK_SIZE : int = 16
const CHUNK_SHOWN: int = 1 # 1=1, 2=9, 3=16, 4=25, 5=49 (Nice pattern lol)

const CHUNK_SIZE_X: float = TILE_SIZE_X * CHUNK_SIZE
const CHUNK_SIZE_Z: float = TILE_SIZE_Z * CHUNK_SIZE
#endregion
