class Settings:
	"""A class to store all settings for Alien Invasion. (The "raw" data only)."""

	def __init__(self):
		"""Initiate game settings."""
		# Screens setttings
		self.screen_width = 1400
		self.screen_height = 770
		self.bg_color = (80, 100, 80)

		# Ship settings
		self.ship_speed = 1.0
		self.ship_limit = 3

		# Bullet settings
		self.bullet_speed = 1.25
		self.bullet_width = 2
		self.bullet_height = 20
		self.bullet_color = (0, 0, 0)
		self.bullets_allowed = 5

		# Alien settings
		self.alien_speed = 0.25
		self.fleet_drop_speed = 0.025
			# fleet direction of 1 represents right; -1 represents left.
		self.fleet_direction = 1
			# moving counter
		self.cnt = 0