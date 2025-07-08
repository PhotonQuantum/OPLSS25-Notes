#import "colors.typ"
#import "smcp.typ"

#let _details(
  color: colors.black,
  key: none,
  name: none,
  prefix: "",
  stroke: true,
  fill: true,
  body,
) = {
  let kind = if stroke { "details" } else { "detail" }
  let key = if key == none { prefix } else { key }
  let name-content = if name == none [] else [ _(#name)_]
  let numc = "A"
  let numh = "1.1.1"
  let num = n => {
    let loc = query(figure.where(kind: kind)).at(n - 1).location()
    let loc = query(selector(<meta:det>).after(loc)).first().location()
    let hea = numbering(numh, ..counter(heading).at(loc))
    let cur = numbering(numc, ..counter(key).at(loc))
    hea + cur
  }
  let (hea, cur) = (counter(heading), counter(key))
  // keep track of previous heading for this key
  let old = counter(key + " h")
  figure.with(
    placement: none,
    kind: kind,
    numbering: if name == none { num } else { _ => "" },
    supplement: if name == none { prefix } else { name },
  )({
    set align(left)
    let b = if fill {
      block.with(
        inset: .5em,
        stroke: if stroke { (left: color + .25em) } else { none },
        fill: color.transparentize(95%),
      )
    } else { block }.with(width: 100%)

    // if inside new heading
    context if old.get() != hea.get() {
      old.update(hea.get())
      cur.update(0)
    }

    cur.step()
    let hea = context hea.display(numh)
    let cur = context cur.display(numc)
    b[#text(color)[*#smcp.smcp[#prefix #hea#cur]*#name-content.] #body<meta:det>]
  })
}

#let definition = _details.with(prefix: "Definition", color: colors.aqua)
#let theorem = _details.with(prefix: "Theorem", color: colors.teal)
#let lemma = _details.with(prefix: "Lemma", key: "Theorem", color: colors.teal)
#let corollary = _details.with(
  prefix: "Corollary",
  key: "Theorem",
  color: colors.teal,
)
#let conjecture = _details.with(prefix: "Conjecture", color: colors.orange)
#let algorithm = _details.with(prefix: "Algorithm", color: colors.pink)
#let remark = _details.with(prefix: "Remark", color: colors.mauve, stroke: false)
#let pitfall = _details.with(prefix: "Pitfall", color: colors.red, stroke: false)
#let example = _details.with(prefix: "Example")
#let proposition = _details.with(
  prefix: "Proposition",
  color: colors.teal,
  stroke: false,
)

#let proof(body) = {
  [_*Proof.*_]
  let _append(body) = context {
    let b = if body.has("children") and body.children.last() == [ ] {
      body.children.slice(0, -1).join()
    } else { (children: (body,)) }
    let last = b.children.last()
    if (
      last.func() == math.equation and last.block and math.equation.numbering == none
    ) {
      // equation
      b.children.slice(0, -1).join()
      set math.equation(numbering: _ => $square$, number-align: bottom)
      last
    } else if last.func() == enum.item or last.func() == list.item {
      // enum or item
      b.children.slice(0, -1).join()
      last.func()(_append(last.body))
    } else [
      #body#h(1fr)$square$
    ]
  }
  _append(body)
}

#let details(body) = {
  show figure.where(kind: "details"): set block(spacing: 0pt, breakable: true)
  show figure.where(kind: "detail"): set block(spacing: 1em, breakable: true)
  show par: block.with(spacing: 1em)
  body
}
