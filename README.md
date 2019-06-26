# VGA
This project is a VHDL implementation of a VGA displayer for my Zybo board. At the moment all it does it run some tests.

## Todo
~~[ ] Test the top model~~ Don't think this is needed anymore.
[X] Put it on the Zybo

## Running Tests
To test the modules when you have vivado 2018.1 installed use the following at the project root.
```bash
source run_vivado_tests.sh
```
The above will create a vivado project with the sources and test benches and run the test benches. The vivado project will remain open for browsing etc.

### Putting on the Hardware
To do this I created a piece of IP using the source files and brought it into the block diagram with a Zynq core. I used the clocking wizard to create a 25.2MHz clock signal.
