This is a project directory of Lightweight USB host for Microchip PIC18 and Maxim MAX3421E USB Host controller.
This is a migration from FreeRTOS implementation, which I decided to stop developing because the end product will not fit into PIC18.
Therefore, you will find fragments of strange code every now and then. 

The code is compiled using Microchip C18 compiler in MPLAB. MPLAB project file is provided but not guaranteed to work on your system
due to absolute path issue. You can manually edit the .mcp file or make your own. The project uses standard linker script and headers.

In addition, logic analyzer trace is provided in LPF file. Too see the trace you will need to download Logicport software from Intronix,
http://www.pctestinstruments.com/downloads.htm

For hardware implementation information go to http://www.circuitsathome.com

## Note
This description was automatically added when the driver source code was uploaded. This is the description from the repository of the referenced code, which was cited in final_project_1.1/README.