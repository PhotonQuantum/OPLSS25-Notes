# Lecture Notes for OPLSS25

This is a collection of notes I made during [OPLSS25](https://opls.org/opls25/).

Note that I'm still organizing the notes, so most of the lectures may not be complete.
[Introduction to Category Theory](https://oplss25-notes.lightquantum.me/paige) is the most complete one, but it's still a work in progress.

There are two versions of the notes:
- [PDF](https://github.com/PhotonQuantum/OPLSS25-Notes/tree/master/pdfs): great for reading on desktop or paper
- [Website](https://oplss25-notes.lightquantum.me): great for reading on mobile devices or link sharing

Note that due to an upstream issue with the typst renderer, the website version does **not** work on _Firefox_.

## Compiling the notes

1. Build PDF and typst-ts vector formats
```bash
make all-pdfs   # PDF
make all-assets # vector formats
```

2. Build the website
```bash
pnpm run build
```