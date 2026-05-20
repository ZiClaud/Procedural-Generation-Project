extends WorldEnvironment

const SKY_COLOR: Color = Color8(54, 58, 79)

func _ready() -> void:
	var sky_material: ProceduralSkyMaterial = self.environment.sky.sky_material
	sky_material.sky_top_color = SKY_COLOR
	sky_material.sky_horizon_color = SKY_COLOR
	sky_material.ground_bottom_color = SKY_COLOR
	sky_material.ground_horizon_color = SKY_COLOR
