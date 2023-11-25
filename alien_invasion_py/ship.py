import pygame

class Ship:
	"""A class to manage to the ship."""

	def __init__(self, ai_game):  # the current instance of the AlienInvasion class (ai).
								  # Note: alien_invasion.py module is not imported.
		self.screen = ai_game.screen
		self.screen_rect = ai_game.screen.get_rect()
		self.settings = ai_game.settings

		# Load the ship image and get its ship rect
		self.image = pygame.image.load("images/jet-plane.png")
		self.rect = self.image.get_rect()

		# Place the new ship at the bottom center of the screen.
		self.rect.midbottom = self.screen_rect.midbottom

		# Store a decimal value for the ship's horizontal position. Allows simple calculations; helps reduce run time...?
		self.x = float(self.rect.x)
		self.y = float(self.rect.y)

		# Movement flag
		self.moving_right = False
		self.moving_left = False
		self.moving_up = False
		self.moving_down = False

	def update(self):
		"""Update the ship's position based on the movement flag."""
		# Update the ship's x and y values, not the ship's rect.
		if self.moving_right and self.rect.right < self.screen_rect.right:
			self.x += self.settings.ship_speed
		if self.moving_left and self.rect.left > 0:
			self.x -= self.settings.ship_speed
		if self.moving_up and self.rect.top > 0:
			self.y -= self.settings.ship_speed
		if self.moving_down and self.rect.bottom < self.screen_rect.bottom:
			self.y += self.settings.ship_speed

		# Update rect object from self x and y
		self.rect.x = self.x
		self.rect.y = self.y 

	def center_ship(self):
		"""Center the ship on the screen."""
		self.rect.midbottom = self.screen_rect.midbottom
		self.x = float(self.rect.x)
		self.y = float(self.rect.y)

	def blitme(self):  # blit_method
		"""Draw the ship at its current location."""
		self.screen.blit(self.image, self.rect)


















































