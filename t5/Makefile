# ------------------------------------------------------------
# type "make" command in the Linux terminal create report.pdf
#
# type "make clean" to delete all generated files
# ------------------------------------------------------------

NAME=Bandpass_Filter

all:
	make -C mat
	make -C sim
	make -C doc
	cp doc/report.pdf $(NAME)_report.pdf
	evince $(NAME)_report.pdf &

clean:
	make -C mat clean
	make -C sim clean
	make -C doc clean
	rm -f $(NAME)_report.pdf

.PHONY: all clean


