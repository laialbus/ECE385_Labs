"""The Alien class doesn't need a method for drawing it to the screen;
	instead; we'll use a Pygame group method that automatically draws all the elements of a group to the screen."""

import pygame
from pygame.sprite import Sprite

class Alien(Sprite):
	"""A class to represent a single alien in the fleet."""

	def __init__(self, ai_game):
		"""Initialize the alien and set its starting position."""
		super().__init__()
		self.screen = ai_game.screen
		self.settings = ai_game.settings

		# Load the UFO image and get its rect
		self.image = pygame.image.load("images/ufo_scaled.png")
		self.rect = self.image.get_rect()

		# Place the new alien near the top left on the screen.
		# Adding a space to the left of it that's equal to the alien's width and a space above it equal to its height.
		self.rect.x = self.rect.width
		self.rect.y = self.rect.height

		# Store a decimal value for the UFO's horizontal and vertical position.
		self.x = float(self.rect.x)
		self.y = float(self.rect.y)

		# Moving counter
		self.cnt = 0

	def update(self):
		"""Move the alien right or left."""
		if self.cnt >= 0 and self.cnt <= 500:
			self.x += (self.settings.alien_speed *
							self.settings.fleet_direction)
			self.rect.x = self.x
			self.cnt += 1
			if self.cnt == 500:
				self.cnt = -200
		else:
			self.x -= (self.settings.alien_speed *
							self.settings.fleet_direction)
			self.rect.x = self.x
			self.cnt += 1

		self.y += self.settings.fleet_drop_speed
		self.rect.y = self.y

	def check_edges(self):
		"""Return True if alien is at edge of screen."""
		screen_rect = self.screen.get_rect()
		if self.rect.right >= screen_rect.right or self.rect.left <= 0:
			return True
		else:
			return False

































