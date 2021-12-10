all: workshop-1.pdf workshop-2.pdf workshop-3.pdf

.SUFFIXES:

workshop.pdf: schedule.md Makefile
	pandoc --pdf-engine=xelatex --variable mainfont="Liberation Sans" -V geometry:margin=2cm schedule.md -o workshop.pdf


.SUFFIXES: .md .pdf
.md.pdf:
	pandoc --pdf-engine=xelatex --variable mainfont="Liberation Sans" -V geometry:margin=2cm $< -o $@

