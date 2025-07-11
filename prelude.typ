#import "@preview/curryst:0.5.1": prooftree, rule
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/cetz:0.4.0"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/hydra:0.6.1": hydra
#import "@preview/shiroa:0.2.3": *
#import "/prelude/details.typ": *
#import "/prelude/smcp.typ": *
#import "/templates/page.typ": project

#let tred(c) = text(fill: colors.red, c)
#let tblue(c) = text(fill: blue.darken(10%), c)
#let tgreen(c) = text(fill: green.darken(10%), c)
#let tgray(c) = text(fill: gray.darken(10%), c)
#let tpurple(c) = text(fill: colors.mauve, c)

#let todo(c) = box(
  stroke: orange,
  outset: (x: 3pt, y: 3pt),
  box(inset: (right: 5pt), box(fill: orange, outset: 3pt, text(fill: white, "TODO"))) + c,
)
#let note(c) = box(
  stroke: purple,
  outset: (x: 3pt, y: 3pt),
  box(inset: (right: 5pt), box(fill: purple, outset: 3pt, text(fill: white, "NOTE"))) + c,
)
#let warn(c) = box(
  stroke: red,
  outset: (x: 3pt, y: 3pt),
  box(inset: (right: 5pt), box(fill: red, outset: 3pt, text(fill: white, "WARN"))) + c,
)

#let mathpar(..rules) = block(rules.pos().map(prooftree).map(c => box(inset: 5pt, c)).join(h(0.5cm)))

#let pdf-only(c) = context {
  if is-pdf-target() {
    c
  }
}

#let web-only(c) = context {
  if is-web-target() {
    c
  }
}

#let __heading_collection = state("heading-collection", [])

#let prelude-init(smcp-simulate: false, title: "Lorem Ipsum", author: "John Doe", body) = {
  show: project.with(title: title)

  set-smcp(simulate: smcp-simulate)

  show heading: h => {
    __heading_collection.update(it => it + h)
    h
  }

  show smallcaps: set text(font: "Libertinus Serif")
  show math.equation: set text(font: "Libertinus Math")

  set par(justify: true)
  set page(numbering: "1", header: context {
    if here().page() == 1 {
      return
    }
    if calc.odd(here().page()) {
      [
        #box(stroke: (bottom: 0.5pt), inset: (bottom: .5em))[
          _#hydra(1)_
          #h(1fr)
          #title
        ]
      ]
    } else {
      [
        #box(stroke: (bottom: 0.5pt), inset: (bottom: .5em))[
          _#hydra(2)_
          #h(1fr)
          #title
        ]
      ]
    }
  })

  show: codly-init.with()
  codly(languages: codly-languages)

  align(center)[
    #text(if is-pdf-target() { 16pt } else { 28pt }, strong(title))

    _#(author)_
  ]

  set heading(numbering: "1.1.1")
  outline()

  body
}

// #let mcal = math.cal
#let cal = text.with(font: "Pxsy")

#let diagram = diagram.with(spacing: 2em, label-sep: 0em)
