# Typst files to compile (excluding prelude.typ)
SOURCES = $(shell find . -name "*.typ" -not -name "prelude.typ")
PDFS = $(SOURCES:.typ=.pdf)

# Default target
all: $(PDFS)

# Rule to compile .typ files to .pdf
%.pdf: %.typ
	typst compile $< $@

# Clean generated PDFs
clean:
	rm -f $(PDFS)

# Phony targets
.PHONY: all clean