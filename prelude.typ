#import "@preview/curryst:0.5.1": prooftree, rule
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/cetz:0.4.0"

#show: codly-init.with()

#codly(languages: codly-languages)

#let tred(c) = text(fill: red.darken(10%), c)
#let tblue(c) = text(fill: blue.darken(10%), c)
#let tgreen(c) = text(fill: green.darken(10%), c)
#let tgray(c) = text(fill: gray.darken(10%), c)
#let tpurple(c) = text(fill: purple.darken(10%), c)

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

#let smcp(s) = (
  s
    .clusters()
    .map(c => if c.contains(regex("[A-Z]")) {
      c
    } else if c.contains(regex("[a-z]")) {
      text(size: 0.8em, upper(c))
    } else {
      c
    })
    .join()
)

#let msmcp(s) = $upright(#text(size: 0.8em, smcp(s)))$
#let mathpar(..rules) = block(rules.pos().map(prooftree).map(c => box(inset: 5pt, c)).join(h(0.5cm)))
