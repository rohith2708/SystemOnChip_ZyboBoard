# SystemOnChip_ZyboBoard
to add a peripheral to the ARM core on the Z-Board/Zybo FPGA. The peripherals are 32x 32 bit registers which are readable and writeable. One register drives LEDs and an other receives inputs fron switches/buttons. The connection between the ARM and the register is the AXI bus.
The goal of the project is to create a comprehensive System-On-Chip model that utilizes the Zybo board.
This model will communicate with the ARM 9 Processor via 32x32-bit AXI communication registers. It
should have the ability to control the Zybo board’s LEDs and switches and must be scan-testable using
a TAP controller. To accomplish this, a finite state machine will be executed with appropriate data and
instruction registers using VHDL programming in the Vivado Model Composer tool
