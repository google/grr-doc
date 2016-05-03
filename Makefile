HTML = $(patsubst %.adoc,%.html,$(shell find -name \*.adoc)) 

all: $(HTML)

clean: 
	rm -f $(HTML) 

%.html: %.adoc
	cd $(<D) && asciidoc $(<F) 

.PHONY: all clean 
