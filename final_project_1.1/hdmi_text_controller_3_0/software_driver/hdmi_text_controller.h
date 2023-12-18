#ifndef HDMI_TEXT_CONTROLLER_H
#define HDMI_TEXT_CONTROLLER_H

/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xparameters.h"
#include "..\..\..\..\mb_galaga_1_1\src\lw_usb\GenericTypeDefs.h"

/*MACROS*/
#define COLUMNS 80
#define ROWS 30
#define PALETTE_START 0x2000
#define SHIP_OFFSET 50	            // location of ship storage
#define ENEMY_OFFSET 51             // location of enemy storage
#define BULLET_OFFSET 66            // location of SHIP bullet storage
#define ENEM_BULL_OFFSET 81         // location of ENEMY or PLAYER2 bullet storage
#define X_CENTER    144             // sprite locations that places them at the indicated position
#define Y_TOP       0
#define Y_BOTTOM    448
// SPRITE IDENTIFIERS
#define SHIP_SPRT   0
#define PLY2_TAG    0xFF
#define EXPLODE1    5
#define EXPLODE2    6
#define ENEMY1_1    7
#define ENEMY1_2    8
#define ENEMY2_1	9
#define ENEMY2_2	10

/*STRUCT DEFINITIONS*/
// states for FSM in lw_usb_main.c AND hdmi_text_controller.c
typedef enum Game_State{
	START, ONE, MULTI
}game;
game state;

/*
    vblank indicator is stored in mem location 100: 1 -> FIFO is updating, 0 -> OK to keep updating game logic

    // sprite code
    parameter [4:0] ship     = 5'b00000;    // ROM 0
    parameter [4:0] pac_1    = 5'b00001;    //     1
    parameter [4:0] pac_2    = 5'b00010;    //     2
    parameter [4:0] bullet   = 5'b00011;    //     3
    parameter [4:0] bllt_inv = 5'b00100;    //     4
    parameter [4:0] explode1 = 5'b00101;    //     5
    parameter [4:0] explode2 = 5'b00110;    //     6
    parameter [4:0] enemy1_1 = 5'b00111;    //     7
    parameter [4:0] enemy1_2 = 5'b01000;    //     8
    parameter [4:0] enemy2_1 = 5'b01001;    //     9
    parameter [4:0] enemy2_2 = 5'b01010;    //     10
    // background
    bit0:
        0 for gameplay background
        1 for start-screen
    bit1:
        1 for special effect (int val 3)
*/

struct TEXT_HDMI_STRUCT {
	uint32_t		    VRAM [1200]; 	// 32 bits as one unit								 //Week 2 - extended VRAM
	//modify this by adding const bytes to skip to palette, or manually compute palette
	const uint8_t 		mem_gap[0x2000 - 0x12C0];
	uint8_t			    palette[64];    // use this to express 64 characters now
};

/* STRUCTS FOR SPRITES IN MY GAME*/

struct BULLET{
    uint8_t             stat;           // live or death
    uint32_t            x;
    int32_t             y;
};

// the collection of all the bullets
struct BULLET_COLLECT{
    uint8_t             speed;
    uint8_t             limit;          // maximum number of bullets allowed
    uint8_t             alive;          // number of bullets alive
    struct BULLET       bullets[15];
};

struct ENEMY{
    uint8_t             stat;           // live or death
    uint8_t             explode;        // 0 < indicate hit and draw explosion
    int8_t              speed;
    uint32_t            x;
    int32_t             y;
};

// the collection of all the enemies
struct ENEMY_COLLECT{
    uint8_t             limit;          // maximum number of enemies on screen
    uint8_t             alive;          // number of enemies alive
    uint8_t             swap;           // cntr for enemy sprite switching
    struct ENEMY        enemies[15];
};

struct SHIP{
    uint8_t             speed;
    uint8_t             lives;          // number of lives
    uint16_t            score;          // score of player
    uint32_t            x;
    int32_t             y;           
};

/*END OF USER STRUCT DECLARATION*/


/*STRUCT DEINITIONS*/
//you may have to change this line depending on your platform designer: 0_S_AXI_BASEADDR
static volatile struct TEXT_HDMI_STRUCT* hdmi_ctrl = XPAR_HDMI_TEXT_CONTROLLER_0_AXI_BASEADDR;

static struct BULLET_COLLECT ship_ammo = {2, 15, 0};    // speed: 2, limit: 15, alive: 0

static struct BULLET_COLLECT enemy_ammo = {2, 15, 0};   // also used as ply2_ammo

static struct ENEMY_COLLECT fleet = {15, 0, 0};
// fleet->limit = 15;
// fleet->alive = 0;

static struct SHIP ship = {1, 0, 0, X_CENTER, Y_BOTTOM};  // speed: 1, lives: 0, score: 0, x: 144, y: 448
static struct SHIP ply2 = {1, 0, 0, X_CENTER, Y_TOP};   // speed: 1, lives: 0, score: 0, x: 144, y: 0

/**************************** Type Definitions *****************************/
/**
 *
 * Write a value to a HDMI_TEXT_CONTROLLER register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the HDMI_TEXT_CONTROLLERdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void HDMI_TEXT_CONTROLLER_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define HDMI_TEXT_CONTROLLER_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a HDMI_TEXT_CONTROLLER register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the HDMI_TEXT_CONTROLLER device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 HDMI_TEXT_CONTROLLER_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define HDMI_TEXT_CONTROLLER_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the HDMI_TEXT_CONTROLLER instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
// functions added by me
void start_state(BYTE keycode[6]);
void one_state(BYTE keycode[6]);
void multi_state(BYTE keycode[6]);
void shipHit();
void bulletEnemyCollide();
void updateShipBullet();
void updateEnemyBullet();
void createBullet(uint8_t ammo_type);                // argument indicates what type of bullet to create and what ammo to add it to
void updateEnemy();
void createEnemy();
void updateShip(uint8_t type);
void bulletCollideMulti();

#endif // HDMI_TEXT_CONTROLLER_H
