CODE = ../../code/
SRC = $(CODE)/defs.vhd $(CODE)/write_module.vhd $(CODE)/functionset.vhd $(CODE)/displayonoffcontrol.vhd $(CODE)/cleardisplay.vhd $(CODE)/entrymodeset.vhd $(CODE)/poweroninit.vhd
TB = poi_tb

.PHONY: default
default: run

.PHONY: analyze
analyze: $(SRC) $(TB).vhd
	ghdl -a $?

.PHONY: elaborate
elaborate: analyze $(TB).o
	ghdl -e $(TB)

.PHONY: run
run: elaborate
	ghdl -r $(TB)

.PHONY: makewave
makewave: elaborate
	ghdl -r $(TB) --vcd=tb.vcd

.PHONY: viewwave
viewwave: makewave
	gtkwave tb.vcd

.PHONY: ps2pdfwave
ps2pdfwave: makewave
	ps2pdf -dPDFSETTINGS=/prepress -dEPSCrop tb.ps
