CODE = ../../code/
SRC = $(CODE)/poweroninit.vhd $(CODE)/defs.vhd
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
