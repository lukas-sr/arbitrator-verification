#!/bin/bash
echo "GHDL Running..."

ghdl -a arb1.vhd
ghdl -a arb_tb1.vhd
ghdl -e arb_tb1
ghdl -r arb_tb1 --wave=wave_arb_tb1.ghw --stop-time=750ns
gtkwave wave_arb_tb1.ghw
