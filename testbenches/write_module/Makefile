CODE = ../../code/
SRC = $(CODE)/write_module.vhd $(CODE)/defs.vhd
TB = write_tb

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
