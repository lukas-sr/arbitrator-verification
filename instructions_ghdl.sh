#!/bin/bash
echo "GHDL Running..."

ghdl -a arb1.vhd
ghdl -a arb_tb1.vhd
ghdl -e arb_tb1
ghdl -r arb_tb1
ghdl -a arb2.vhd
ghdl -a arb_tb2.vhd
ghdl -e arb_tb2
ghdl -r arb_tb2 --wave=wave_arb_tb2.ghw --stop-time=750ns
gtkwave wave_arb_tb2.ghw
