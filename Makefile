# Typst files to compile (excluding prelude.typ)
SOURCES = $(shell find src -name "*.typ")
PDFS = $(SOURCES:src/%.typ=pdfs/%.pdf)
FONT_PATH = $(PWD)/prelude/fonts

# Default target
all: all-pdfs book

all-pdfs: $(PDFS)

# Rule to compile .typ files to .pdf
pdfs/%.pdf: src/%.typ
	typst compile --root $(PWD) --font-path $(FONT_PATH) $< $@

# Rule to build book
book: dist/.timestamp
dist/.timestamp: | $(SOURCES)
	mkdir -p dist && shiroa build --font-path $(FONT_PATH) && touch $@

# Clean generated PDFs
clean-pdfs:
	rm -f $(PDFS)

# Clean generated book
clean-book:
	rm -rf dist

clean: clean-pdfs clean-book

# Phony targets
.PHONY: all all-pdfs book clean clean-pdfs clean-book