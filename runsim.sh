#!/bin/bash
iverilog -o sim src/*.v tb/testbench_led_test.v
vvp sim
gtkwave wave.vcd