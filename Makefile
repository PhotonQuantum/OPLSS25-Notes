# Typst files to compile (excluding prelude.typ)
SOURCES = $(shell find typ -name "*.typ")
PDFS = $(SOURCES:typ/%.typ=pdfs/%.pdf)
FONT_PATH = $(PWD)/prelude/fonts

# Default target
all: all-pdfs

all-pdfs: $(PDFS)

# Rule to compile .typ files to .pdf
pdfs/%.pdf: typ/%.typ
	typst compile --root $(PWD) --font-path $(FONT_PATH) $< $@

# Clean generated PDFs
clean-pdfs:
	rm -f $(PDFS)

clean: clean-pdfs

# Phony targets
.PHONY: all all-pdfs clean clean-pdfs