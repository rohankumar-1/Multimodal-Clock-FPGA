Rohan Kumar
# Multimodal Clock using VGA and FPGA

  The goal of this project was to learn more about HDLs and implementation of combinational+sequential logic on FPGAs. Contributions were made by Eric Chen, Emika Hammond, and Sora Kakigi, for the purpose of EC311 at Boston University.

## Specifications
The FPGA used in this project is the Digilent Nexys A7-100T. The attached [.xdc constraint file](/Nexys4DDR_Master.xdc) is the only constraint file necessary. The inputs to the top module are defined in this file. There is the screen reset, which will reset the VGA connection, the time reset, which sets time back to 0, the edit button which toggles edit mode, the increment hour button, the increment minute button, and the mode toggle button that switches between modes. To control the timer and stopwatch start/pause, two switches are used. The diagram of this implementation is shown below:
![instructions](/resources/nexys.jpg)

The idea behind the implementation is that we want to display this clock on a computer screen, and to do this, we use the FPGA and VGA capabilities. The 12h and 24h clock can be manually set to a start time, by toggling the edit mode ON, using the edit button, and then using the increment hour and increment second buttons. The timer can also be manually set to a start time, but instead of using the edit button, the timer switch must be OFF (timer is paused) in order to change the time manually. When the timer is ON, the time cannot be changed. The stopwatch does not have any set time capability, and will stop/start as the switch is turned OFF and ON.

The display has 9 digit: hours, minutes, seconds, and milliseconds, as shown below in the following image:
![timer](/resources/display.jpg)

The color of the display changes depending on the mode: 12h is purple, 24h is yellow, timer is red, and stopwatch is green. This is also the order of the modes as the mode is toggled via the button.


## What I Learnt
The single most important lesson I learnt from this project was the importance of creating buses for inputs/outputs, as well as properly and effectively naming any regs/wires/parameters/modules in a largescale endeavor. With the sheer amount of inputs passed from one module to another, without proper flow the Verilog would be almost impossible to search through for errors.
The design challenge of using the computer screen also taught me a lot about the VGA and how to use it in connection to an FPGA, and has given me many ideas on how to make more complicated structures with this new technique, such as moving animations or rounded edges to VGA display objects.
