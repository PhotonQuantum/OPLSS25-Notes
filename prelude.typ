#import "@preview/curryst:0.5.1": prooftree, rule
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/cetz:0.4.0"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/hydra:0.6.1": hydra
#import "@preview/shiroa:0.2.3": *
#import "/prelude/details.typ": *
#import "/prelude/smcp.typ": *

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

#let __parse-length(s) = {
  if type(s) == str {
    let unit = s.slice(-2)
    let value = int(s.slice(0, -2))
    if unit == "cm" {
      value * 1cm
    } else if unit == "pt" {
      value * 1pt
    } else {
      panic("Unknown unit: " + unit)
    }
  } else if type(s) == length {
    s
  } else {
    panic("Unknown type: " + type(s))
  }
}

#let target = sys.inputs.at("x-target", default: "pdf")
#let page-width = __parse-length(sys.inputs.at("x-page-width", default: "21cm"))
#let is-web-target = target.starts-with("web")

#let __heading-meta() = {
  query(heading.where(outlined: true)).map(section => {
    let loc = section.location()
    let pos = loc.position()
    let meta = (
      title: plain-text(section.body),
      level: section.level,
      numbering: numbering(section.numbering, ..counter(heading).at(loc)),
      position: pos,
    )
    meta
  })
}

#let emit-meta(title, author) = context [
  #metadata((
    title: plain-text(title),
    author: plain-text(author),
    headings: __heading-meta(),
  ))<article-meta>
]

#let set-text-size(c) = {
  set text(size: 16pt) if is-web-target
  show heading.where(level: 1): set text(size: 28pt) if is-web-target
  show heading.where(level: 2): set text(size: 24pt) if is-web-target
  show heading.where(level: 3): set text(size: 20pt) if is-web-target
  show heading.where(level: 4): set text(size: 16pt) if is-web-target
  show heading.where(level: 5): set text(size: 14pt) if is-web-target
  show heading.where(level: 6): set text(size: 12pt) if is-web-target

  c
}

#let prelude-init(smcp-simulate: false, title: "Lorem Ipsum", author: "John Doe", body) = {
  set document(title: title, author: plain-text(author))

  set-smcp(simulate: smcp-simulate)

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
  }) if not is-web-target

  set page(
    margin: (
      // reserved beautiful top margin
      top: 20pt,
      // reserved for our heading style.
      // If you apply a different heading style, you may remove it.
      left: 20pt,
      // Typst is setting the page's bottom to the baseline of the last line of text. So bad :(.
      bottom: 0.5em,
      // remove rest margins.
      rest: 0pt,
    ),
    width: page-width,
    height: auto,
  ) if is-web-target

  show: set-text-size

  show: codly-init.with()
  codly(languages: codly-languages)

  align(center)[
    #text(if is-pdf-target() { 16pt } else { 28pt }, strong(title))

    _#(author)_
  ]

  set heading(numbering: "1.1.1")
  outline()

  emit-meta(title, author)

  body
}

// #let mcal = math.cal
#let cal = text.with(font: "Pxsy")

#let diagram = diagram.with(spacing: 2em, label-sep: 0em)
