extends PowerUp

@export var shield_time := 6.0

func applyPowerUp(body):
	body.apply_shield(shield_time)
