# ------------------------------------------------------------
# type "make" command in the Linux terminal create report.pdf
#
# type "make clean" to delete all generated files
# ------------------------------------------------------------

all:
	$ printf "96536" | ./t2_datagen.py > data.txt
	make -C mat
	make -C sim
	make -C doc
	cp doc/report.pdf RC_circuit_analysis_report.pdf
	evince RC_circuit_analysis_report.pdf &

clean:
	make -C mat clean
	make -C sim clean
	make -C doc clean
	rm -f *.pdf

.PHONY: all clean


