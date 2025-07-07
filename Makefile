# Typst files to compile (excluding prelude.typ)
SOURCES = $(shell find . -name "*.typ" -not -name "prelude.typ" -not -path "./prelude/**")
PDFS = $(SOURCES:.typ=.pdf)
FONT_PATH = $(PWD)/prelude/fonts

# Default target
all: $(PDFS)

# Rule to compile .typ files to .pdf
%.pdf: %.typ
	typst compile --font-path $(FONT_PATH) $< $@

# Clean generated PDFs
clean:
	rm -f $(PDFS)

# Phony targets
.PHONY: all clean