# ------------------------------------------------------------
# type "make" command in the Linux terminal create report.pdf
#
# type "make clean" to delete all generated files
# ------------------------------------------------------------

all:
	make -C mat
	make -C sim
	make -C doc
	cp doc/report.pdf AC_DC_converter_report.pdf
	evince AC_DC_converter_report.pdf &

clean:
	make -C mat clean
	make -C sim clean
	make -C doc clean
	rm -f AC_DC_converter_report.pdf

.PHONY: all clean


