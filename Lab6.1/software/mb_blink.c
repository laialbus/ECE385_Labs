//mb_blink.c
//
//Provided boilerplate "LED Blink" code for ECE 385
//First released in ECE 385, Fall 2023 distribution
//
//Note: you will have to refer to the memory map of your MicroBlaze
//system to find the proper address for the LED GPIO peripheral.
//
//Modified on 7/25/23 Zuofu Cheng

#include <stdio.h>
#include <xparameters.h>
#include <xil_types.h>
#include <sleep.h>

#include "platform.h"

volatile uint32_t* led_gpio_data = (volatile uint32_t*) XPAR_AXI_GPIO_0_BASEADDR;  //Hint: either find the manual address (via the memory map in the block diagram, or
															 	 	 	 	 	   //replace with the proper define in xparameters (part of the BSP). Either way
															 	 	 	 	 	   //this is the base address of the GPIO corresponding to your LEDs
															 	 	 	 	 	   //(similar to 0xFFFF from MEM2IO from previous labs).
volatile uint32_t* sw_gpio_data = (volatile uint32_t*) XPAR_AXI_GPIO_1_BASEADDR;	   // MEM ADDR FOR SWITCHES
volatile uint32_t* btn_gpio_data = (volatile uint32_t*) XPAR_AXI_GPIO_2_BASEADDR;   // MEM ADDR FOR BTN

int main()
{
    init_platform();

    /*
	while (1+1 != 3)
	{
		//sleep(1);
		*led_gpio_data |=  0x00000001;
		printf("Led On!\r\n");
		//sleep(1);
		*led_gpio_data &= ~0x00000001; //blinks LED
		printf("Led Off!\r\n");
	}
	*/

    int i = 0;	// button release indicator
    			// 0: button prev not pressed; 1: button prev pressed

    //*led_gpio_data = 0xFFFFFFFF;
    //xil_printf("%x\n", *led_gpio_data);

    while (1)
    {
    	if(*btn_gpio_data == 0x00000001)	// Clear/Reset function
    		*led_gpio_data = 0x00000000;

    	if(*btn_gpio_data == 0x00000002 && i == 0)
    	{
    		i = 1;

    		if(*led_gpio_data + *sw_gpio_data > 65535)
    		{
    			xil_printf("OVERFLOW ON LED\n");
    			*led_gpio_data = 0x00000000;
    		}
    		else
    		{
    			*led_gpio_data += *sw_gpio_data;
    			xil_printf("sw value: %lu\n", *sw_gpio_data);
    			xil_printf("led value: %lu\n", *led_gpio_data);
    		}
    	}

    	if(*btn_gpio_data == 0x00000000 && i == 1)
    	{
    		i = 0;
    		usleep(1000);
    	}
    }

    cleanup_platform();

    return 0;
}















