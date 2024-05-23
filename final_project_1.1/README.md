### Description
For my ECE 385 final project, I developed the arcade game Galaga. On a high level abstraction, the game logic was implemented in the software while the drawing mechanism was done in the hardware.

In the hardware, a frame buffer is used to ensure a smooth and detailed gameplay. The module mainly responsible for controlling what is drawn into the frame buffer is blitter.sv. In the frame buffer, which is basically a BRAM, each word is 32 bits, and each pixel is represented with 8 bits because this is the smallest modifiable unit. Since the available on-chip memory is limited on our Urbana FPGA board (details available on Real Digital website), each pixel is represented with the least number of bits possible.

The three least significant bits are used to store the palette code that would be used to decode the corresponding sprite's palette that outputs 32-bit colors. The other 5 bits are used to decode which sprite is being drawn. The disadvantage of this organization is that each sprite can only have 8 colors. I realized too late that allocating 5 bits to represent the sprites was unnecessary for the game I was making and the time I had. 

### Note


### Reference
felis(Oleg Mazurov) (10 May 2009) lightweight-usb-host. https://github.com/felis/lightweight-usb-host
