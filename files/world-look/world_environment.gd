extends WorldEnvironment

func _ready() -> void:
	var sky_material: ProceduralSkyMaterial = self.environment.sky.sky_material
	sky_material.sky_top_color = Constants.SKY_COLOR
	sky_material.sky_horizon_color = Constants.SKY_COLOR
	sky_material.ground_bottom_color = Constants.SKY_COLOR
	sky_material.ground_horizon_color = Constants.SKY_COLOR
