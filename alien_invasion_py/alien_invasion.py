import sys
import random
from time import sleep

import pygame

from settings import Settings
from game_stats import GameStats
from ship import Ship
from bullet import Bullet
from alien import Alien

class AlienInvasion:
	"""Overall class to manage game assets and behavior."""

	def __init__(self):
		"""Initialize the game, and create game resources."""
		pygame.init() #inherit from pygame
		self.settings = Settings()

		#self.screen = pygame.display.set_mode((self.settings.screen_width
		#	, self.settings.screen_height)) 				#This object is a surface. A surface in Pygame is a part of the screen
														   #where a game element can be displayed.

		# Full Screen
		self.screen = pygame.display.set_mode((0,0), pygame.FULLSCREEN)
		self.settings.screen_width = self.screen.get_rect().width
		self.settings.screen_height = self.screen.get_rect().height
		pygame.display.set_caption("Alien Invasion")

		# Create an instance to store game statistics.
		self.stats = GameStats(self)

		self.ship = Ship(self)
		self.bullets = pygame.sprite.Group()
		self.aliens = pygame.sprite.Group()

		self._create_fleet()

		# Shooting Flag
		self.shoot_bullet = False
		self.flag = 100

	def run_game(self):
		"""Start the main loop for the game."""
		while True:
			self._check_events() 

			if self.stats.game_active:
				self.ship.update()
				self._update_bullets()
				self._update_aliens()

			self._update_screen()


	def _check_events(self):
		"""Respond to keypresses and mouse events."""
		# The event loop performs appropriate tasks depending on the kinds of event that occur.
		for event in pygame.event.get():
			if event.type == pygame.QUIT:
				sys.exit()
			elif event.type == pygame.KEYDOWN:
				self._check_keydown_events(event)
			elif event.type == pygame.KEYUP:
				self._check_keyup_events(event)

	def _check_keydown_events(self, event):
		"""Repsond to keypresses"""
		if event.key == pygame.K_l:
			# Set Right Movement Flag to True
			self.ship.moving_right = True
		elif event.key == pygame.K_j:
			self.ship.moving_left = True
		if event.key == pygame.K_i:
			self.ship.moving_up = True
		elif event.key == pygame.K_k:
			self.ship.moving_down = True
		if event.key == pygame.K_SPACE:
			self.shoot_bullet = True

		elif event.key == pygame.K_q:
			sys.exit()

	def _check_keyup_events(self, event):
		"""Respond to key releases."""
		if event.key == pygame.K_l:
			# Set Right Movement Flag to FALSE
			self.ship.moving_right = False
		elif event.key == pygame.K_j:
			self.ship.moving_left = False
		if event.key == pygame.K_i:
			self.ship.moving_up = False
		elif event.key == pygame.K_k:
			self.ship.moving_down = False
		if event.key == pygame.K_SPACE:
			self.shoot_bullet = False

	def _fire_bullet(self):
		"""Create a new bullet and add it to the bullets group."""
		if len(self.bullets) < self.settings.bullets_allowed:
			new_bullet = Bullet(self)
			self.bullets.add(new_bullet)

	def _update_bullets(self):
		"""Update position of bullets and get rid of old bullets."""
		# Update bullet positions. Keeps the bullet moving
		self.bullets.update()
		self.flag += 1
		if self.shoot_bullet and self.flag > 85:
			self._fire_bullet()
			self.flag = 0

		# Get rid of bullets that have disappeared.
		for bullet in self.bullets:
			if bullet.rect.bottom < 0:
				self.bullets.remove(bullet)
		#print(len(self.bullets)) -> prints how many bullets currently exist in the game

		self._check_bullet_alien_collisions()

	def _check_bullet_alien_collisions(self):
		"""Respond to bullet-allien collisions."""
		# Check for any bullets that have hit aliens.
		#   If so, get rid of the bullet and the alien.
		collisions = pygame.sprite.groupcollide(
				self.bullets, self.aliens, True, True)

		# Create new fleets after one is cleared
		if not self.aliens:
			# Destroy existing bullets and create new fleet.
			self.bullets.empty()
			self._create_fleet()

	def _create_fleet(self):
		"""Create the fleet of aliens."""
		# Create an alien and find the number of aliens in a row.
		# Spacing between each alien is equal to one alien width.
		alien = Alien(self)
		alien_width, alien_height = alien.rect.size
		ship_height = self.ship.rect.height

		available_space_x = self.settings.screen_width - alien_width
		number_aliens_x = available_space_x // (2 * alien_width)
		# Determine the number of rows of aliens that fit on the screen.
		available_space_y = (self.settings.screen_height - 
									(4 * alien_height) - ship_height)
		number_rows = available_space_y // (2 * alien_height)

		# Create the full fleet of aliens.
		for row_number in range(number_rows):
			for alien_number in range(number_aliens_x):
				n = random.randint(1, 100)
				if n > 40:
					self._create_alien(alien_number, row_number)
				else:
					continue

	def _check_fleet_edges(self):
		"""Respond appropriately if any aliens have reached an edge."""
		for alien in self.aliens.sprites():
			if alien.check_edges():
				self._change_fleet_direction()
				break	# Break so that fleet direction is only changed once. 

	def _change_fleet_direction(self):
		"""Drop the entire fleet and change the fleet's direction."""
		self.settings.fleet_direction *= -1
		for alien in self.aliens.sprites():
			alien.cnt = 0

	def _create_alien(self, alien_number, row_number):
		"""Create an alien and place it in the row."""
		alien = Alien(self)
		alien_width, alien_height = alien.rect.size
		alien.x = (alien_width) + (2 * alien_width * alien_number)
		alien.y = (alien_height) + (2 * alien_height * row_number)
		alien.rect.x = alien.x
		alien.rect.y = alien.y
		self.aliens.add(alien)

	def _check_aliens_bottom(self):
		"""Check if any aliens have reached the bottom of the screen."""
		screen_rect = self.screen.get_rect()
		for alien in self.aliens.sprites():
			if alien.rect.bottom >= screen_rect.bottom:
				# Treat this the same as if the ship got hit.
				self._ship_hit()
				break

	def _update_aliens(self):
		"""
		Check if the fleet is at an edge,
			then update the positions of all aliens in the fleet.
		"""
		self._check_fleet_edges()
		self.aliens.update()

		# Look for alien-ship collisions.
		if pygame.sprite.spritecollideany(self.ship, self.aliens):
			self._ship_hit()

		# Look for aliens hitting the bottom of the screen.
		self._check_aliens_bottom()
			
	def _ship_hit(self):
		"""Respond to the ship being hit by an alien."""
		# Decrement ships_left.
		self.stats.ships_left -= 1
		
		if self.stats.ships_left > 0:
			# Get rid of any remaining aliens and bullets.
			self.aliens.empty()
			self.bullets.empty()

			# Create a new fleet and center the ship.
			self._create_fleet()
			self.ship.center_ship()

			# Pause.
			sleep(1.0)
		else:
			self.stats.game_active = False
		print(self.stats.game_active)

	def _update_screen(self):
		"""Update images on the screen, and flip to the new screen."""
		# Redraw the screen during each pass through the loop. Inputs tuple.
		self.screen.fill(self.settings.bg_color)
		self.ship.blitme()
		for bullet in self.bullets.sprites():
			bullet.draw_bullet()
		self.aliens.draw(self.screen)
		
		# Make the most recently drawn screen visible. (updates the display to show the new positions of game elements and 
		# hides the old one; creates the illusion of smooth movement.)
		pygame.display.flip()


if __name__ == "__main__":
	# Make a game instance, and run the game.
	ai = AlienInvasion()
	ai.run_game()

































