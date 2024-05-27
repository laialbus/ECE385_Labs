## Description
For my ECE 385 final project, I developed the arcade game Galaga. On a high level abstraction, the game logic was implemented in the software while the drawing mechanism was done in the hardware. Since this project uses custom IP adapted from Lab 7, the names of some components also extend from those in Lab 7.

### Hardware
In the hardware, a frame buffer is used to ensure a smooth and detailed gameplay. The module mainly responsible for controlling what is drawn into the frame buffer is blitter.sv. In the frame buffer, which is basically a BRAM, each word is 32 bits, and each pixel is represented with 8 bits because this is the smallest modifiable unit. Since the available on-chip memory is limited on our Urbana FPGA board (details available on Real Digital website), each pixel is represented with the least number of bits possible.

The three least significant bits are used to store the palette code that would be used to decode the corresponding sprite's palette that outputs 32-bit colors. The other 5 bits are used to decode which sprite is being drawn. The disadvantage of this organization is that each sprite can only have 8 colors. I realized too late that allocating 5 bits to represent the sprites was unnecessary for the game I was making and the time I had. 

### Software
The game logic design takes inspiration from a python project I completed in 2022. More details about project is shared in the directory alien_invasion_py. The game logic software is placed in the directory hdmi_text_controller_3_0/software_driver. In the code, hdmi_ctrl is set to the starting memory address at which the custom IP is mapped to in the CPU (MicroBlaze is used in this project). AXI-4 LITE interface is used to communicate the necessary information, such as the location of each sprite, computed in the MicroBlaze to the custom IP.

Another critical aspect is the USB driver. An issue encountered was that the driver sat idle for too long when there is no new inputs from the keyboard. Since the game logic runs within the polling while loop of the USB driver, the idling time would cause enormous lags in the game. After making numerous modifications to the driver, I realized that the idling time was simply determined by the parameter USB_NAK_LIMIT in project_config.h. Thus, after decreasing this parameter, the game ran smoothly. 

## Reference
felis(Oleg Mazurov) (10 May 2009) lightweight-usb-host. https://github.com/felis/lightweight-usb-host
