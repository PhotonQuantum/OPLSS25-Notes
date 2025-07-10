# Typst files to compile (excluding prelude.typ)
SOURCES = $(shell find typ -name "*.typ")
PDFS = $(SOURCES:typ/%.typ=pdfs/%.pdf)
ASSETS_SIR = $(SOURCES:typ/%.typ=public/assets/%.multi.sir.in)
ASSETS_META = $(SOURCES:typ/%.typ=public/assets/%.meta.json)
FONT_PATH = $(PWD)/prelude/fonts

# Default target
all: all-pdfs all-assets

all-assets: $(ASSETS_SIR) $(ASSETS_META)

all-pdfs: $(PDFS)

# Rule to compile .typ files to .pdf
pdfs/%.pdf: typ/%.typ
	typst compile --root $(PWD) --font-path $(FONT_PATH) $< $@

# Clean generated PDFs
clean-pdfs:
	rm -f $(PDFS)

clean-assets:
	rm -f $(ASSETS_SIR) $(ASSETS_META)

clean: clean-pdfs clean-assets

public/assets/%.multi.sir.in public/assets/%.meta.json: typ/%.typ
	pnpx jiti scripts/render-typst.ts --root $(PWD) --font-path $(FONT_PATH) -o public/assets $<

# Phony targets
.PHONY: all all-pdfs all-assets clean clean-pdfs clean-assets