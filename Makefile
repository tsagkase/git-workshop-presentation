SLIDES := $(patsubst %.md,%.md.slides.pdf,$(wildcard *.md))
HANDOUTS := $(patsubst %.md,%.md.handout.pdf,$(wildcard *.md))

all : $(SLIDES) # $(HANDOUTS)

%.md.slides.pdf : %.md
	pandoc $^ -t beamer --slide-level 3 -V theme:Goettingen -o $@

%.md.handout.pdf : %.md
	pandoc $^ -t beamer --slide-level 3 -V handout -o $@
	pdfxup $@ --nup 1x2 --no-landscape --keepinfo \
		--paper letterpaper --frame true --scale 0.9 \
		--suffix "nup"
	mv $*.md.handout-nup.pdf $@
		

clobber : 
	rm -f $(SLIDES)
	rm -f $(HANDOUTS)

# all:
#	pandoc -t beamer README.md -o slides.pdf
