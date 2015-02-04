.PHONY: default analyze elaborate wave run

default: run

analyze: write_tb.vhd ../code/write_module.vhd
	ghdl -a $?

elaborate: analyze write_tb.o
	ghdl -e write_tb

run: elaborate tb.vcd
	ghdl -r write_tb

wave: elaborate tb.vcd
	ghdl -r write_tb --vcd=tb.vcd; gtkwave tb.vcd
