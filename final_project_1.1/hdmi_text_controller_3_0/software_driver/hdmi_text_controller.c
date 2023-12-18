

/***************************** Include Files *******************************/
#include "hdmi_text_controller.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "sleep.h"

#include "xparameters.h"
#include "xtmrctr.h"
#include "..\..\..\..\mb_galaga_1_1\src\lw_usb\GenericTypeDefs.h"

/************************** Function Definitions ***************************/
/*Global Variables*/
// made global so that the start_state function can reset it for repeated plays
uint8_t mag1 = 60;						// magazine for player 1  --> 60 allows continuous shooting every sec
uint8_t mag2 = 60;						// magazine for player 2  --> b/c 60 frames per sec
uint32_t mask_y = 0x000001FF;			// mask for y position of sprites
uint16_t enemy_create_speed = 300;

/*
 * Start State
 * Takes in keycode and respond accordingly
 */
void start_state(BYTE keycode[6])
{
	hdmi_ctrl->VRAM[0] = 0;					// set start-screen background

	char string1[18] = " PRESS 1   FOR PvE";
	char string2[18] = " PRESS 2   FOR PvP";

	for(uint8_t k = 0; k < 18; k++)
	{
		hdmi_ctrl->palette[k] = string1[k];
		hdmi_ctrl->palette[k+30] = string2[k];
	}

	for(int i = 0; i < 6; i++)
	{
		if(keycode[i] == 0x1E){								// if user presses "1": SINGLE PLAYER
			// basic set ups for a gameplay
			ship.speed = 1;
			ship.lives = 3;
			ship.score = 0;
			ship.x = X_CENTER;
			ship.y = Y_BOTTOM;
			ship_ammo.speed = 2;
			enemy_ammo.speed = 2;
			enemy_create_speed = 300;
			for(uint8_t k = 0; k < 18; k++)			// clear text display
			{
				hdmi_ctrl->palette[k] = 0;
				hdmi_ctrl->palette[k+30] = 0;
			}
			// switch state to gameplay
			state = ONE;
			break;
		}
		else if(keycode[i] == 0x1F){						// if user presses "2": MULTI PLAYER
			// set each player's live cnt to 50 and score to 0
			ship.speed = 1;
			ply2.speed = 1;
			ship.lives = 60;
			ply2.lives = 60;
			ship.score = 0;
			ply2.score = 0;
			ship.x = X_CENTER;
			ship.y = Y_BOTTOM;
			ply2.x = X_CENTER;
			ply2.y = Y_TOP;
			ship_ammo.speed = 2;
			enemy_ammo.speed = 2;
			mag1 = 60;
			mag2 = 60;
			for(uint8_t k = 0; k < 18; k++)			// clear text display
			{
				hdmi_ctrl->palette[k] = 0;
				hdmi_ctrl->palette[k+30] = 0;
			}
			state = MULTI;
			break;
		}
	}
	
	return;
}

/*
 * One-Player State
 * Game Logic Flow: check for collision, update ship, update bullet, update enemy positions
 */
void one_state(BYTE keycode[6])
{
	// set background
	if(ship.score < 50)
    	hdmi_ctrl->VRAM[0] = 1;			
	else
		hdmi_ctrl->VRAM[0] = 3;

	static uint8_t cnt = 60;			// used for timing/counting the number of loops passed
	if(cnt < 60)
		cnt++;							// increments each loop (supposedly one frame?)

	if(ship.score == 50){
		ship_ammo.speed = 2;
	}
	if(ship.score == 100){
		ship.speed = 2;
	}

	char score_str[30] = "                     SCORE:";			// 21 white spaces in between to offset the position of texts
	char lives_str[30] = "                     LIVES:";

	for(uint8_t k = 0; k < 30; k++)
	{
		if(k == 27){
			hdmi_ctrl->palette[k] = ship.score/100 + 48;		// numbers start at code 48 in IBM Code page 437
			hdmi_ctrl->palette[k+30] = 0; 
		}
		else if(k == 28){
			hdmi_ctrl->palette[k] = (ship.score%100)/10 + 48;
			hdmi_ctrl->palette[k+30] = 0; 
		}
		else if(k == 29){
			hdmi_ctrl->palette[k] =    ship.score%10 + 48;
			hdmi_ctrl->palette[k+30] = ship.lives + 48;			// starting positions have an offset of 30
		}
		else{
			hdmi_ctrl->palette[k] = score_str[k];				
			hdmi_ctrl->palette[k+30] = lives_str[k];			// starting positions have an offset of 30
		}
	}

	// // check collision
	// shipHit();
	// bulletEnemyCollide();

	for(uint8_t i = 0; i < 6; i++){
		if(keycode[5-i] == 4)		// keycode 4: 'A' LEFT
		{
		    if(ship.x > 0)
			    ship.x -= ship.speed;
			else
				ship.x = 0;
	    }
		else if(keycode[5-i] == 7)	// keycode 7: 'D' RIGHT
		{
		    if(ship.x < 288)
    			ship.x += ship.speed;
			else
				ship.x = 288;
	    }
		else if(keycode[5-i] == 22)	// keycode 22: 'S' DOWN
		{
			if(ship.y < 470)
    			ship.y += ship.speed;
			else
				ship.y = 470;
		}
		else if(keycode[5-i] == 26) // keycode 26: 'W' UP
		{
		    if(ship.y != 0xFFFFFFF0)
    			ship.y -= ship.speed;
		}

		if(keycode[i] == 44){		// keycode 44: space
			// bullet creation fcn: includes the functionality of creating upright AND inverted bullet
			if(60 == cnt){			// makes sure the bullet doesn't stick together when space is always pressed down
				createBullet(SHIP_SPRT);
				cnt = 0;
			}
		}
	}

	// update bullet
	updateShipBullet();
	updateEnemyBullet(ENEMY1_1);
	// enemy_update fcn (in it includes bullet creation fcn)
	updateEnemy();
	// ship update fcn
	updateShip(SHIP_SPRT);
    
	// check collision last because this function also clears enemies and bullets when the user loses
	shipHit();
	bulletEnemyCollide();

    return;
}

/*
 * Multi-Player State
 * Includes different controls: 1st player -> WASDF, 2nd player -> KL;OJ
 */
void multi_state(BYTE keycode[6])
{
	hdmi_ctrl->VRAM[0] = 3;				// background with special effect
	
	static uint8_t cnt1 = 60;			// used for timing PLY1 firing speed
	static uint8_t cnt2 = 60;			// used for timing PLY2 firing speed
	uint8_t	sprt = ENEMY1_1;

	// ability upgrade (bullet moves faster)
	if(ship.score == 15){
		ship_ammo.speed = 3;
	}
	if(ply2.score == 15){
		enemy_ammo.speed = 3;
	}
	// ability upgrade (move faster)
	if(ship.score == 30){
		ship.speed = 2;
	}
	if(ply2.score == 30){
		ply2.speed = 2;
	}
	// ability upgrade (more bullets)
	if((ship.score == 45) && (mag1 != 30)){		// Second condition makes sure that these...
		cnt1 = 0;
		mag1 = 30;
	}
	if((ply2.score == 45) && (mag2 != 30)){		// ...if-statements only run once. Otherwise, cnt will continuously be reset when score = 45.
		cnt2 = 0;
		mag2 = 30;
	}

	if(cnt1 < mag1){
		cnt1++;
	}
	if(cnt2 < mag2){
		cnt2++;
	}

	char ply1_str[30] = " PLAYER1:   HP:       KILL: "; 
	char ply2_str[30] = " PLAYER2:   HP:       KILL: ";

	for(uint8_t k = 0; k < 30; k++)
	{
		if(k == 17){
			hdmi_ctrl->palette[k+30] = ship.lives/10 + 48;			// numbers start at code 48 in IBM Code page 437
			hdmi_ctrl->palette[k] = ply2.lives/10 + 48;				// ply1 display start on 3rd line -> a +30 offset
		}
		else if(k == 18){
			hdmi_ctrl->palette[k+30] = (ship.lives%10) + 48;
			hdmi_ctrl->palette[k] = (ply2.lives%10) + 48;
		}
		else if(k == 27){											// first digit indicating lives
			hdmi_ctrl->palette[k+30] = ship.score/10 + 48;		
			hdmi_ctrl->palette[k] = ply2.score/10 + 48;
		}
		else if(k == 28){
			hdmi_ctrl->palette[k+30] = (ship.score%10) + 48;
			hdmi_ctrl->palette[k] = (ply2.score%10) + 48;
		}
		else{
			hdmi_ctrl->palette[k+30] = ply1_str[k];
			hdmi_ctrl->palette[k] = ply2_str[k];
		}
	}

	for(uint8_t i = 0; i < 6; i++){
		// PLAYER 1 MOVEMENT
		if(keycode[5-i] == 4)		// keycode 4: 'A' LEFT
		{
		    if(ship.x > 0)
			    ship.x -= ship.speed;
	    }
		else if(keycode[5-i] == 7)	// keycode 7: 'D' RIGHT
		{
		    if(ship.x < 288)
    			ship.x += ship.speed;
	    }
		else if(keycode[5-i] == 22)	// keycode 22: 'S' DOWN
		{
			if(ship.y < 480)
    			ship.y += ship.speed;
			else
				ship.y = 0;
		}
		else if(keycode[5-i] == 26) // keycode 26: 'W' UP
		{
		    if((ship.y < 0xFFFFFFDD) && (0xFFFFFFDA < ship.y))
		    	ship.y = 480;
			else
				ship.y -= ship.speed;
		}
		// PLAYER 2 MOVEMENT
		if(keycode[5-i] == 14)		// keycode 4: 'K' LEFT
		{
		    if(ply2.x > 0)
			    ply2.x -= ply2.speed;
	    }
		else if(keycode[5-i] == 51)	// keycode 7: ';' RIGHT
		{
		    if(ply2.x < 288)
    			ply2.x += ply2.speed;
	    }
		else if(keycode[5-i] == 15)	// keycode 22: 'L' DOWN
		{
			if(ply2.y < 480)
    			ply2.y += ply2.speed;
			else
				ply2.y = 0;
		}
		else if(keycode[5-i] == 18) // keycode 26: 'O' UP
		{
		    if((ply2.y < 0xFFFFFFDD) && (0xFFFFFFDA < ply2.y))
		    	ply2.y = 480;
			else
				ply2.y -= ply2.speed;
		}

		// PLAYER 1 SHOOTING
		if(keycode[i] == 9){		// keycode 9: 'F'
			// bullet creation fcn: includes the functionality of creating upright AND inverted bullet
			if(mag1 == cnt1){			// makes sure the bullet doesn't stick together when space is always pressed down
				createBullet(SHIP_SPRT);
				cnt1 = 0;
			}
		}
		// PLAYER 2 SHOOTING
		if(keycode[i] == 13){		// keycode 13: 'J'
			// bullet creation fcn: includes the functionality of creating upright AND inverted bullet
			if(mag2 == cnt2){			// makes sure the bullet doesn't stick together when space is always pressed down
				createBullet(PLY2_TAG);
				sprt = ENEMY1_2;
				cnt2 = 0;
			}
		}
	}

	// check for collision
	bulletCollideMulti();

	updateShipBullet();
	updateEnemyBullet();

	updateShip(SHIP_SPRT);
	updateShip(sprt);
}


/*HELPER FUNCTIONS: called by functions above*/
void shipHit()
{
	struct BULLET* bullet_temp;
	struct ENEMY*  enemy_temp;
	uint8_t		   hit = 0;			// used to indicate whether ship has been hit

	// 15 enemy bullets
	for(uint8_t i = 0; i < 15; i++)
	{
		hit = 0;			
		bullet_temp = &(enemy_ammo.bullets[i]);

		// if there is a bullet
		if(bullet_temp->stat == 1)
		{
			// check if the bullet hits the ship
				// y-position: only checks whether bullet hit ship from above; hit from below is negligible
			if((ship.y < (bullet_temp->y + 15)) && ((bullet_temp->y + 15) < (ship.y+32)))
			{
				// x-position, when the width of bullet is within that of the enemy
				if((ship.x <= (bullet_temp->x + 13)) && ((bullet_temp->x + 19) <= (ship.x+32))) {
					hit = 1;
				}
				else
					continue;
			}
		}
		else
			continue;

		// if hit, process accordingly
		if(hit)
		{
			if(ship.lives != 1){
				// update live, score, and position
				ship.lives--;
				ship.x = X_CENTER;
				ship.y = Y_BOTTOM;
				// get rid of bullet
				bullet_temp->stat = 0;
				enemy_ammo.alive -= 1;
			}
			// if this is the last life, return to start-screen
			else{
				// clear all sprites on screen
				for(uint8_t i = 0; i < 15; i++){
					fleet.enemies[i].stat = 0;
					hdmi_ctrl->VRAM[ENEMY_OFFSET+i] = (0 << 23);
				}
				fleet.alive = 0;
				// clear all bullets
				for(int i = 0; i < ship_ammo.limit; i++){
					ship_ammo.bullets[i].stat = 0;
					enemy_ammo.bullets[i].stat = 0;
					hdmi_ctrl->VRAM[BULLET_OFFSET+i] = 0;
					hdmi_ctrl->VRAM[ENEM_BULL_OFFSET+i] = 0;
				}
				ship_ammo.alive = 0;
				enemy_ammo.alive = 0;
				// indicate player has no more lives in end state
				hdmi_ctrl->palette[59] = 48;
				state = START;
				return;
			}
		}
	}

	// 15 enemies
	for(uint8_t j = 0; j < 15; j++)
	{
		hit = 0;
		enemy_temp = &(fleet.enemies[j]);

		// if there is an enemy
		if(enemy_temp->stat == 1)
		{
			// check if enemy hits the ships
				// y-position
			if(((enemy_temp->y < (ship.y+32)) && ((ship.y+32) < (enemy_temp->y+32))) ||
					((ship.y < (enemy_temp->y+32)) && ((enemy_temp->y+32) < (ship.y+32))))
			{
				// x-position, enemy from the left
				if((ship.x < (enemy_temp->x + 32)) && ((enemy_temp->x + 32) < (ship.x+32))) {
					hit = 1;
				}
				// x-position, enemy from the right
				else if((enemy_temp->x < (ship.x+32)) && ((ship.x + 32) < (enemy_temp->x + 32))) {
					hit = 1;
				}
				else
					continue;
			}
		}
		else
			continue;

		// if hit, process accordingly
		if(hit)
		{
			if(ship.lives != 1){
				ship.lives--;
				ship.x = X_CENTER;
				ship.y = Y_BOTTOM;
				enemy_temp->stat = 0;
				fleet.alive -= 1;
			}
			// if this is the last life, return to start-screen
			else{
				// clear all sprites on screen
				for(uint8_t i = 0; i < 15; i++){
					fleet.enemies[i].stat = 0;
					hdmi_ctrl->VRAM[ENEMY_OFFSET+i] = (0 << 23);		// remember to update the hardware memory as well
				}
				fleet.alive = 0;
				// clear all bullets
				for(int i = 0; i < ship_ammo.limit; i++){
					ship_ammo.bullets[i].stat = 0;
					enemy_ammo.bullets[i].stat = 0;
					hdmi_ctrl->VRAM[BULLET_OFFSET+i] = 0;
					hdmi_ctrl->VRAM[ENEM_BULL_OFFSET+i] = 0;
				}
				ship_ammo.alive = 0;
				enemy_ammo.alive = 0;
				// indicate player has no more lives in end state
				hdmi_ctrl->palette[59] = 48;
				state = START;
				return;
			}
		}
	}
}

void bulletEnemyCollide()
{
	struct BULLET* bullet_temp;		// bullets from ship
	struct ENEMY*  enemy_temp;		// enemies
	uint8_t		   hit = 0;			// used to indicate whether ship has been hit

	// for 15 ship bullets...
	for(uint8_t i = 0; i < 15; i++)
	{
		bullet_temp = &(ship_ammo.bullets[i]);

		// if bullet exists
		if(bullet_temp->stat == 1)
		{
			// ...check its collision against 15 enemies
			for(uint8_t j = 0; j < 15; j++)
			{
				hit = 0;
				enemy_temp = &(fleet.enemies[j]);

				// if enemy exists AND is not exploding
				if((enemy_temp->stat == 1) && (enemy_temp->explode == 0))
				{
					// check for overlap
						// y-position: no need to check bullet tail hit enemy from uptop -> negligible
					if((enemy_temp->y < (bullet_temp->y+17)) && ((bullet_temp->y+17) < (enemy_temp->y+32)))
					{
						// x-position, when the width of bullet is within that of the enemy -> simplifies logic & code
						if((enemy_temp->x <= (bullet_temp->x+13)) && ((bullet_temp->x+19) <= (enemy_temp->x+32))){
							hit = 1;
						}
						else
							continue;
					}
				}

				// if there is collision, respond accordingly
				// explosion anime would be added here
				if(hit)
				{
					//enemy_temp->stat = 0; ---> die only after explosion
					//fleet.alive -= 1; 	---> update only after explosion
					enemy_temp->explode = 1;
					bullet_temp->stat = 0;
					ship_ammo.alive -= 1;
					ship.score++;
				}
			}
		}
	}
}

void updateShipBullet()
{
	// decrement each bullets position by one speed-unit
	for(uint8_t i = 0; i < 15; i++)
	{
		if(ship_ammo.bullets[i].stat == 1)
		{
			if(0 < (ship_ammo.bullets[i].y + 32)){
				ship_ammo.bullets[i].y -= ship_ammo.speed;
			}
			else{
				ship_ammo.bullets[i].stat = 0;			// kill the ship bullet if it reaches top of screen
				ship_ammo.alive--;
			}
		}
	}

	// write into VRAM
	for (uint8_t i = 0; i < 15; i++)
	{
		hdmi_ctrl->VRAM[BULLET_OFFSET+i] = (ship_ammo.bullets[i].stat << 23) | (3 << 18) | (ship_ammo.bullets[i].x << 9) | (mask_y & ship_ammo.bullets[i].y);
	}
	
}

void updateEnemyBullet()					// enemy_ammo and ply2_ammo are the same, one set is enough
{
	// increment each bullets position by one speed-unit
	for(int i = 0; i < 15; i++)
	{
		if(enemy_ammo.bullets[i].stat == 1)
		{
			if(enemy_ammo.bullets[i].y < 480){
				enemy_ammo.bullets[i].y += enemy_ammo.speed;
			}
			else{
				enemy_ammo.bullets[i].stat = 0;			// kill the enemy bullet if it reaches bottom of screen
			}
		}
	}

	// write into VRAM
	for (uint8_t i = 0; i < 15; i++)
	{
		hdmi_ctrl->VRAM[ENEM_BULL_OFFSET+i] = (enemy_ammo.bullets[i].stat << 23) | (4 << 18) | (enemy_ammo.bullets[i].x << 9) | (mask_y & enemy_ammo.bullets[i].y);
	}
}

void createBullet(uint8_t ammo_type)		// extended to MULTI-PLAYER
{
	if(ammo_type == SHIP_SPRT)
	{
		for(uint8_t i = 0; i < ship_ammo.limit; i++)
		{
			if(ship_ammo.bullets[i].stat == 0)
			{
				ship_ammo.bullets[i].stat = 1;
				ship_ammo.bullets[i].x = ship.x;
				ship_ammo.bullets[i].y = ship.y - 32;
				ship_ammo.alive++;
				break;
			}
		}
	}
	// enemy_ammo used for ply2 and AI enemy
	else if(ammo_type == PLY2_TAG)
	{
		for(uint8_t i = 0; i < enemy_ammo.limit; i++)
		{
			if(enemy_ammo.bullets[i].stat == 0)
			{
				enemy_ammo.bullets[i].stat = 1;
				enemy_ammo.bullets[i].x = ply2.x;
				enemy_ammo.bullets[i].y = ply2.y + 18;		// 16?
				enemy_ammo.alive++;
				break;
			}
		}
	}
	else
	{
		for(uint8_t i = 0; i < enemy_ammo.limit; i++)
		{
			if((enemy_ammo.bullets[i].stat == 0) && fleet.enemies[i+10].stat)
			{
				enemy_ammo.bullets[i].stat = 1;
				enemy_ammo.bullets[i].x = fleet.enemies[i+10].x;
				enemy_ammo.bullets[i].y = fleet.enemies[i+10].y + 18;
				enemy_ammo.alive++;
				break;
			}
		}
	}

	return;
}

/*
 * Move each enemy horizontally. If edge is touched, change direction or delete.
 * Enemy bullet created in here.
 */
void updateEnemy()
{
	// for each frame drawn, swap++
	uint8_t sprt1;										// use to record which sprite to draw
	static uint16_t count = 0;							// helps count 5 seconds (60 frames/sec -> 300 frames for 5sec)

	// increment counter each frame
	fleet.swap++;
	count++;

	// counter logic
	if(fleet.swap == 240)
		fleet.swap = 0;
	if(fleet.swap < 120)
		sprt1 = ENEMY2_1;
	else
		sprt1 = ENEMY2_2;

	if(ship.score == 50){
		enemy_create_speed = 200;
	}

	if(fleet.alive != 0)								// if there is enemies to draw
	{
		for(int i = 0; i < 15; i++)
		{
			if((fleet.enemies[i].stat==1) && (fleet.enemies[i].explode == 0))	// if the enemy is alive AND not hit
			{
				// vertical position check
				if(fleet.enemies[i].y == 480){			// if enemy reached bottom of screen
					fleet.enemies[i].stat = 0;
					fleet.alive --;
				}

				// horizontal position check
				if (fleet.enemies[i].speed < 0)			// if ship is moving to the left
				{
					if(fleet.enemies[i].x != 0){
						fleet.enemies[i].x += fleet.enemies[i].speed;			// *** no such mechanism: thus moves left faster
						if(!(fleet.swap%5))
							fleet.enemies[i].y -= fleet.enemies[i].speed;			// speed is (-)tive, thus need to invert it
					}
					else{
						fleet.enemies[i].y += 2;
						fleet.enemies[i].speed = 1;
					}
				}
				else if(0 < fleet.enemies[i].speed)		// if ship is moving to the right
				{
					if(fleet.enemies[i].x != 288){
						if(!(fleet.swap%5)){									// if swap mod 5 = 0, enemy moves: makes enemy move slower ***
							fleet.enemies[i].x += fleet.enemies[i].speed;
							//fleet.enemies[i].y += fleet.enemies[i].speed;
						}
					}
					else{
						fleet.enemies[i].y += 2;
						fleet.enemies[i].speed = -1;
					}
				}
			}
		}
	}
	else
	{
		createEnemy();
	}

	// creates one shooting enemy every 5 sec
	if(count >= enemy_create_speed)
	{
		count = 0;		// reset counter
		// 15 enemies: 10 non-shooting, 5 shooting
		for(int j = 0; j < 5; j++)
		{
			if(fleet.enemies[j+10].stat == 0)
			{
				fleet.enemies[j+10].stat = 1;
				//fleet.alive++;					// make the shooting enemies independent of the non-shooting enemies
				fleet.enemies[j+10].speed = 1;
				fleet.enemies[j+10].x = 288;
				fleet.enemies[j+10].y = -32;
				break;
			}
		}
	}

	// make the shooting enemies shoot
	for(int j = 0; j < 5; j++)
	{
		if((count == 180) && fleet.enemies[j+10].stat)			// shoots whenever their sprite changes
		{
			createBullet(ENEMY1_1);
		}
	}

	// write into VRAM
	for (uint8_t i = 0; i < 15; i++)
	{
		if(fleet.enemies[i].explode == 0)			// if this enemy has not been hit
		{
			if(i < 10){
				hdmi_ctrl->VRAM[ENEMY_OFFSET+i] = (fleet.enemies[i].stat << 23) | (sprt1 << 18) | (fleet.enemies[i].x << 9) | (mask_y & fleet.enemies[i].y);
			}
			else{	// draw the sprite of the different/shooting enemies
				hdmi_ctrl->VRAM[ENEMY_OFFSET+i] = (fleet.enemies[i].stat << 23) | ((sprt1-2) << 18) | (fleet.enemies[i].x << 9) | (mask_y & fleet.enemies[i].y);
			}
		}
		else if(fleet.enemies[i].explode <= 30)		// variable 'explode' serves as both the counter and indicator
		{
			hdmi_ctrl->VRAM[ENEMY_OFFSET+i] = (fleet.enemies[i].stat << 23) | (EXPLODE1 << 18) | (fleet.enemies[i].x << 9) | (mask_y & fleet.enemies[i].y);
			fleet.enemies[i].explode++;
		}
		else
		{
			hdmi_ctrl->VRAM[ENEMY_OFFSET+i] = (fleet.enemies[i].stat << 23) | (EXPLODE2 << 18) | (fleet.enemies[i].x << 9) | (mask_y & fleet.enemies[i].y);
			fleet.enemies[i].explode++;
			// ONCE the explosion is done animating, update...
			if(fleet.enemies[i].explode == 60){
				fleet.enemies[i].stat = 0;			// enemy dies
				fleet.enemies[i].explode = 0;		// stops exploding
				if(i < 10)
					fleet.alive--;						// fleet.alive decrements
			}
		}
	}
}

void createEnemy()
{
	//if(fleet.alive == 0)
	//{
		fleet.alive += 10;
		for(uint8_t i = 0; i < 10; i++)
		{
			fleet.enemies[i].stat = 1;
			fleet.enemies[i].speed = 1;
			fleet.enemies[i].x = i * 32;
			fleet.enemies[i].y = i * 10;
	 	}
	//}
}

void updateShip(uint8_t type)
{
	static uint8_t cntr = 0;
	if(type == ENEMY1_2)
		cntr = 30;

	if(type == SHIP_SPRT)
		hdmi_ctrl->VRAM[SHIP_OFFSET] = (1 << 23) | (SHIP_SPRT << 18) | (ship.x << 9) | (mask_y & ship.y);
	else{
		if(cntr != 0){
			hdmi_ctrl->VRAM[ENEMY_OFFSET] = (1 << 23) | (ENEMY1_2 << 18) | (ply2.x << 9) | (mask_y & ply2.y);
			cntr--;
		}
		else
			hdmi_ctrl->VRAM[ENEMY_OFFSET] = (1 << 23) | (ENEMY1_1 << 18) | (ply2.x << 9) | (mask_y & ply2.y);
	}
}


/*MULTI-PLAYER SPECIFIC HELPER FUNCTIONS*/

// checks for bullet collision for both players
void bulletCollideMulti()
{
	struct BULLET* bullet_temp;
	uint8_t		   hit = 0;					// used to indicate whether ship has been hit

	static int32_t  exp1_x = -1;			// used to indicate whether to draw explode animation
	static int32_t	exp1_y = -1;			// AND where to draw it
	static uint8_t  cntr1 = 0;				// counters to time the duration of the explosion animation
	static int32_t	exp2_x = -1;			// explosion for PLY2
	static int32_t	exp2_y = -1;
	static uint8_t	cntr2 = 0;

	// 15 PLY2 bullets -> PLY1 ship
	for(uint8_t i = 0; i < 15; i++)
	{
		hit = 0;			
		bullet_temp = &(enemy_ammo.bullets[i]);

		// if there is a bullet
		if(bullet_temp->stat == 1)
		{
			// check if the bullet hits the ship
				// y-position: only checks whether bullet hit ship from above; hit from below is negligible
			if((ship.y < (bullet_temp->y + 15)) && ((bullet_temp->y + 15) < (ship.y+32)))
			{
				// x-position, when the width of bullet is within that of the enemy
				if((ship.x <= (bullet_temp->x + 13)) && ((bullet_temp->x + 19) <= (ship.x+32))) {
					hit = 1;
				}
				else
					continue;
			}
		}
		else
			continue;

		// PLAYER 1 HIT
		if(hit)
		{
			if(ship.lives != 1){
				// turn on explosion animation (before position is updated)
				exp1_x = ship.x;
				exp1_y = ship.y;
				// update live, score, and position of both players
				ship.lives--;
				ship.x = X_CENTER;
				ship.y = Y_BOTTOM;
				ply2.score++;
				ply2.x = X_CENTER;
				ply2.y = Y_TOP;
				// get rid of the bullet
				bullet_temp->stat = 0;
				enemy_ammo.alive -= 1;
			}
			// if this is PLY1 life, return to start-screen
			else{
				// clear all bullets
				for(int i = 0; i < ship_ammo.limit; i++){
					ship_ammo.bullets[i].stat = 0;
					enemy_ammo.bullets[i].stat = 0;
					hdmi_ctrl->VRAM[BULLET_OFFSET+i] = 0;
					hdmi_ctrl->VRAM[ENEM_BULL_OFFSET+i] = 0;
				}
				ship_ammo.alive = 0;
				enemy_ammo.alive = 0;
				hdmi_ctrl->VRAM[ENEMY_OFFSET] = 0;		// kill ply2 sprite
				// clear the score keeping text for multi-player (preserve only KILLS)
				hdmi_ctrl->palette[18] = 0;
				hdmi_ctrl->palette[48] = 0;
				state = START;
				return;
			}
		}
	}
	// Explosion Animation
	if(0 <= exp1_x)
	{
		cntr1++;
		if(cntr1 <= 30)
			// use unused memory location allocated for other enemies in one-player mode
			hdmi_ctrl->VRAM[ENEMY_OFFSET+1] = (1 << 23) | (EXPLODE1 << 18) | (exp1_x << 9) | (exp1_y);
		else{
			hdmi_ctrl->VRAM[ENEMY_OFFSET+1] = (1 << 23) | (EXPLODE2 << 18) | (exp1_x << 9) | (exp1_y);
			if(cntr1 == 60){
				hdmi_ctrl->VRAM[ENEMY_OFFSET+1] = (0 << 23);		// turn off drawing indicator in hardware
				cntr1 = 0;
				exp1_x = -1;
				exp1_y = -1;
			}
		}
	}

	// 15 SHIP bullets -> PLY2 ship
	for(uint8_t i = 0; i < 15; i++)
	{
		hit = 0;			
		bullet_temp = &(ship_ammo.bullets[i]);

		// if there is a bullet
		if(bullet_temp->stat == 1)
		{
			// check if the bullet hits PLY2
				// y-position: only checks whether bullet hit PLY2 from below; hit from above is negligible
			if((ply2.y < (bullet_temp->y + 17)) && ((bullet_temp->y + 17) < (ply2.y+32)))
			{
				// x-position, when the width of bullet is within that of the enemy
				if((ply2.x <= (bullet_temp->x + 13)) && ((bullet_temp->x + 19) <= (ply2.x+32))) {
					hit = 1;
				}
				else
					continue;
			}
		}
		else
			continue;

		// PLAYER 2 HIT
		if(hit)
		{
			if(ply2.lives != 1){
				// turn on explosion animation (before position is updated)
				exp2_x = ply2.x;
				exp2_y = ply2.y;
				// update live, score, and position of both players
				ply2.lives--;
				ply2.x = X_CENTER;
				ply2.y = Y_TOP;
				ship.score++;
				ship.x = X_CENTER;
				ship.y = Y_BOTTOM;
				// get rid of the bullet
				bullet_temp->stat = 0;
				ship_ammo.alive -= 1;
			}
			// if this is PLY2 last life, return to start-screen
			else{
				// clear all bullets
				for(int i = 0; i < ship_ammo.limit; i++){
					ship_ammo.bullets[i].stat = 0;
					enemy_ammo.bullets[i].stat = 0;
					hdmi_ctrl->VRAM[BULLET_OFFSET+i] = 0;
					hdmi_ctrl->VRAM[ENEM_BULL_OFFSET+i] = 0;
				}
				ship_ammo.alive = 0;
				enemy_ammo.alive = 0;
				// kill ply2 sprite (to prevent it from affecting next game play)
				hdmi_ctrl->VRAM[ENEMY_OFFSET] = 0;
				// clear the score keeping text for multi-player (preserve only KILLS)
				hdmi_ctrl->palette[18] = 0;
				hdmi_ctrl->palette[48] = 0;
				state = START;
				return;
			}
		}
	}
	// Explosion Animation
	if(0 <= exp2_x)
	{
		cntr2++;
		if(cntr2 <= 30){
			// use unused memory location allocated for other enemies in one-player mode
			hdmi_ctrl->VRAM[ENEMY_OFFSET+2] = (1 << 23) | (EXPLODE1 << 18) | (exp2_x << 9) | (exp2_y);
		}
		else{
			hdmi_ctrl->VRAM[ENEMY_OFFSET+2] = (1 << 23) | (EXPLODE2 << 18) | (exp2_x << 9) | (exp2_y);
			if(cntr2 == 60){
				hdmi_ctrl->VRAM[ENEMY_OFFSET+2] = (0 << 23);		// turn off drawing indicator in hardware
				cntr2 = 0;
				exp2_x = -1;
				exp2_y = -1;
			}
		}
	}
}

