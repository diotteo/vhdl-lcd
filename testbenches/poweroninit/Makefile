CODE = ../../code/
SRC = $(CODE)/defs.vhd $(CODE)/write_module.vhd $(CODE)/functionset.vhd $(CODE)/displayonoffcontrol.vhd $(CODE)/cleardisplay.vhd $(CODE)/entrymodeset.vhd $(CODE)/poweroninit.vhd
TB = poi_tb

.PHONY: default analyze elaborate wave run

default: run

analyze: $(SRC) $(TB).vhd
	ghdl -a $?

elaborate: analyze $(TB).o
	ghdl -e $(TB)

run: elaborate
	ghdl -r $(TB)

wave: elaborate
	ghdl -r $(TB) --vcd=tb.vcd; gtkwave tb.vcd
