<div align="center">

<img alt="Logo" width="150" src="icon.svg?raw=true">

<h1>Procedural Generation Hexagonal Template</h1>

#### Procedural Generation with Hexagonal 3D Tiles
#### [**Run it on Itch.io**](https://ziclaud.itch.io/procedural-generation-project)

</div>

---

## Types of generation

### Perlin Positive Heights:
<img alt="PerlinPositiveHeightsGeneration" width="500" src="https://i.imgur.com/BVKoLgH.png?raw=true">

### Perlin Noise:
<img alt="PerlinNoiseGeneration" width="500" src="https://i.imgur.com/iHPWJNv.png?raw=true">

---

## Tiles system

### Tile Edges IDs, read clock-wise, starting from the top (12 o'clock)
- 0 = grass
- 1 = water
- 2 = road
- 3 = river
- 4 = coast (grass - coast)
- 4 = coast (coast - grass)

### Example: [0, 0, 0, 2, 2, 0]

<img alt="Example1" width="500" src="https://i.imgur.com/ylU33Dl.png?raw=true">

---

## Key Bindings:

- Movement: `WASD`
- Sprint: `Ctrl`
- Get Cursor: `Esc`
- Move camera Up: `Spacebar`
- Move camera down: `Shift`
- Re-Generate World: `F1`
- Toggle Debug Mode: `F3`
- Toggle Hints: `H`

---

## Credits

### Assets:
- KayKit : Medieval Hexagon Pack - [Kay Lousberg](https://www.kaylousberg.com/)
<!--
- KayKit : Adventurers Character Pack (2.0) - [Kay Lousberg](https://www.kaylousberg.com/)
- KayKit : Character Pack : Skeletons (1.1) - [Kay Lousberg](https://www.kaylousberg.com/)
-->

### Theme used for UI and assets:
- [Catppuccin Mocha](https://catppuccin.com/)

### Character with movement - Used for testing:
- Brackeys/brackeys-proto-controller [Proto Controller](https://github.com/Brackeys/brackeys-proto-controller)
