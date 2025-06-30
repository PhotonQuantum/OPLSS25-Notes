#import "prelude.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Category Theory

*Q:* What is Category Theory?

*A:*
+ Understanding math objects via relations with each other, i.e. taking an external view, so you do not inspect the internal structure of the objects.
+ A whole independent field of study.

*Q:* What is a category?

*A:* objects + morphisms

*Example*:

- *Set* - _objects_: sets; _morphisms_: functions
- *Group* - _objects_: groups; _morphisms_: group homomorphisms
- *Top* - _objects_: topological spaces; _morphisms_: continuous functions
- *Program Spec* - _objects_: program specifications; _morphisms_: programs that trun any program metting one spec into a program meeting another spec
- *Prop* - _objects_: propositions; _morphisms_: derivation/implication
- *Type* - _objects_: types; _morphisms_: derivation/function
- *Type Theory* - _objects_: type theories; _morphisms_: translations

*Counterexample*: what is the category of *probablistics*?

What if two kinds of notions of morphisms are all useful? *Double category*!

*Example*:
- *Set* - _objects_: sets; _morphisms_: #tred[functions]
- *Set* - _objects_: sets; _morphisms_: #tred[relations]

== Definition

#let ob = $text("ob")$

A *category* $cal(C)$ is
- a collection of objects $ob cal(C)$
- for every $X, Y in ob cal(C)$,
  a collection of morphisms $hom_cal(C)(X, Y)$
- *Id*: for each $X in ob cal(C)$, an id morphism $id_X in hom_cal(C)(X, X)$
- *Comp*: for each $f: X -> Y, g: Y -> Z$,
  a morphism $g compose f: X -> Z$ in $hom_cal(C)(X, Z)$,
  _such that_

  - $f circle id_X = f = id_Y circle f$

    #note[Normally we don't differentiate left and right identity. There was one particular notion that did, but then they were shown to be equivalent.]
  - for any $f: X -> Y, g: Y -> Z, h: Z -> A$,
    $h circle (g circle f) = (h circle g) circle f$.

=== Commutative Diagrams

*E.g.* $f circle id_X = f$

// #q=WzAsMyxbMCwwLCJYIl0sWzEsMCwiWCJdLFsxLDEsIlkiXSxbMCwxLCJpZF9YIl0sWzEsMiwiZiJdLFswLDIsImYiLDJdXQ==
$
  #diagram(
    node((-1, -1), $X$),
    node((0, -1), $X$),
    node((0, 0), $Y$),
    edge((-1, -1), (0, -1), $id_X$, "->"),
    edge((0, -1), (0, 0), $f$, "->"),
    edge((-1, -1), (0, 0), $f$, "->", label-side: right),
  )
$

Notice how the two paths from $X$ to $Y$ yield the same morphism.

#note[
  There are also _string diagrams_, which is very similar to _proof nets_.
]

Let's get back to a concrete example.

=== Prop Category

- $ob "Prop"$ - the collection of propositions
- $
    hom_"Prop"(P, Q) = cases(
      {top} & "if" P -> Q,
      emptyset & "otherwise"
    )
  $
- *Id*: $id_P = top$ for all $P in ob "Prop"$, because $P -> P$ is always true.
- *Comp*: by modus ponens, $Q -> P$ and $P -> R$ implies $Q -> R$. Properties: trivial.

#todo[this is cat but i don't see how it is useful. all morphisms are trivial.. maybe it serves as a gentle introduction to the concept of category that does not serve any real-world purpose?]
