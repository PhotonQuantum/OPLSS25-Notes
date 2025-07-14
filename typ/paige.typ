#import "/prelude.typ": *
#show: prelude-init.with(
  title: [Introduction to Category Theory],
  author: [Prof. Paige Randall North \@ OPLSS25\ Notes by: Yanning Chen],
)

= Category Theory

*Q:* What is Category Theory?

#grid(columns: (auto, 1fr))[*A:*][
  + Understanding math objects via relations with each other, i.e. taking an external view, so you do not inspect the internal structure of the objects.
  + A whole independent field of study.
]

*Q:* What is a category?

*A:* objects + morphisms

#example[
  #table(
    columns: (auto, auto, auto),
    stroke: none,
    table.hline(stroke: .08em),
    table.header(align(center)[*Category*], align(center)[*Objects*], align(center)[*Morphisms*]),
    table.hline(stroke: .05em),
    [*Set*], [sets], [functions],
    [*Group*], [groups], [group homomorphisms],
    [*Top*], [topological spaces], [continuous functions],
    [*Prop*], [propositions], [derivation/implication],
    [*Type*], [types], [derivation/function],
    [*Type Theory*], [type theories], [translations],
    [*Prog Spec*],
    [program spece],
    [programs turning any program of one spec into a program of another spec],
    table.hline(stroke: .08em),
  )

  *Counterexample*: what is the category of *probablistics*?
]

What if two kinds of notions of morphisms are all useful? *Double category*!

#example[
  - *Set* - _objects_: sets; _morphisms_: #tred[functions]
  - *Set* - _objects_: sets; _morphisms_: #tred[relations]
]

== Definition

#let ob = $text("ob")$

#definition(name: "Category")[A *category* $cal(C)$ is
  - a collection of objects $ob cal(C)$
  - for every $X, Y in ob cal(C)$,
    a collection of morphisms $hom_cal(C)(X, Y)$
  - *Id*: for each $X in ob cal(C)$, an id morphism $id_X in hom_cal(C)(X, X)$
  - *Comp*: for each $f: X -> Y, g: Y -> Z$,
    a morphism $g compose f: X -> Z$ in $hom_cal(C)(X, Z)$,
    _such that_

    - $f compose id_X = f = id_Y compose f$

    #remark[Normally we don't differentiate left and right identity. There was one particular notion that did, but then they were shown to be equivalent.]
  - for any $f: X -> Y, g: Y -> Z, h: Z -> A$,
    $h compose (g compose f) = (h compose g) compose f$.
]

#example(name: "Prop Category")[
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
]

== Commutative Diagrams

Categories often involve lots of morphisms and relations between them. To simplify the picture, we can use _commutative diagrams_ to represent the relations.

#example[
  $f compose id_X = f$ can be represented as
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
]

#remark[
  There are also _string diagrams_, which is very similar to _proof nets_.
]

= Basic Concepts

== Terminal Object

#definition(name: "Terminal Object")[
  A *terminal object* ($*$) $T$ in a category $cal(C)$ is an object such that for every object $Z in cal(C)$, there is a unique morphism $Z ->^! T$.
]

_e.g._
- a singleton set ($\{top\}$) in _Set_
- unit type ($1$) in _Ty_
- $A$ in _a category that contains exactly one object $A$_.

== Isomorphism

#definition(name: "Isomorphism")[
  Two objects $X, Y$ in a category $cal(C)$ are *isomorphic* if there exists morphisms $f: X -> Y$ and $g: Y -> X$ such that $g compose f = id_X$ and $f compose g = id_Y$.
]

#remark[
  If $x tilde.equiv y$, we say
  + $f$ is an _isomorphism_ that $f: X tilde.equiv Y$, $f: X ->^tilde Y$
  + $g$ as $f^(-1)$, and  $f^(-1): Y tilde.equiv X$, $f^(-1): Y ->^tilde X$
]

_e.g._
- _bijection_ in _Set_
- _bi-implication_ in _Prop_

#lemma[
  If $f: X tilde.equiv Y$, then for any $Z$, we have
  - $f_*: hom(Z, X) scripts(tilde.equiv)_(italic("Set")) hom(Z, Y)$.
  - $f^*: hom(Z, X) scripts(tilde.equiv)_(italic("Set")) hom(Z, Y)$.
]
#proof[
  - $=>$\
    For any $g in hom(Z, X)$, we have $g: Z -> X$. Also we know $tpurple(X ->^f Y)$. So, $tpurple(f) compose g : Z ->^g X ->^tpurple(f) Y$.

  - $arrow.double.l$\
    For any $h in hom(Z, Y)$, we have $h: Z -> Y$. Also we know $tpurple(Y ->^(f^(-1)) X)$. So, $tpurple(f^(-1)) compose h : Z ->^h Y ->^tpurple(f^(-1)) X$.
]

#lemma[
  Terminal objects are _unique up to isomorphism_.
]

#proof[
  Let $T, T'$ be two terminal objects in a category $cal(C)$.\
  Since $T$ is terminal, there exists a unique morphism $f: T' ->^(!') T$. Similarly, there exists a unique morphism $g: T ->^! T'$.\
  Now $! compose !': T ->^(!') T' ->^! T = id_T$. Similarly, $!' compose ! = id_(T')$.
]

#remark[
  We know $T ->^(!') T' ->^! T$ is $id_T$ because $T$ is terminal, which means for every object $Z$ there is a _unique_ morphism $Z ->^! T$. In particular, for $Z = T$, there is a _unique_ morphism $T ->^! T$. And we know $id_T: T -> T$ is one of the morphisms, so that's it.

  Generally, there could be multiple morphisms to oneself, but in this case it's the terminal part that makes it unique.
]

== Duality

#definition(name: "Dual Category")[
  Given a category $cal(C)$, we can define its *dual category* $cal(C)^{op}$ by reversing the direction of all morphisms.
  $ ob cal(C)^op := ob cal(C), hom_cal(C)^{op}(X, Y) := hom_cal(C)(Y, X) $
]

#lemma[
  $cal(C)^op$ is a category.
]

#lemma[
  If $X tilde.equiv Y$ in $cal(C)$, then $X tilde.equiv Y$ in $cal(C)^op$.
]

== Initial Object

#definition(name: "Initial Object")[
  An *initial object* $I$ in a category $cal(C)$ is the terminal object in $cal(C)^op$.
]

or,

#definition(name: "Initial Object, Alternative")[
  An *initial object* $I$ in a category $cal(C)$ is an object such that for every object $Z in cal(C)$, there is a unique morphism $I ->^excl.inv Z$.
]

#lemma[
  Initial objects are _unique up to isomorphism_.
]
#proof[
  Follows dually from the uniqueness of terminal objects.
]

_e.g._
- empty set ($emptyset$) in _Set_
- empty type ($0$) in _Ty_
- false ($bot$) in _Prop_

= Product

#definition(name: "Product")[
  A *product* of two objects $A, B$ in a category $cal(C)$ contains
  - an _object_ $A times B in ob(cal(C))$
  - _morphisms_ $A times B ->^(pi_A) A, A times B ->^(pi_B) B$,\
    s.t. for any $Z in ob(cal(C))$ and morphisms in the diagram, we have a *unique* morphism $U_Z: Z ->^! A times B$ such that the diagram commutes.
  // #q=WzAsNCxbMSwwLCJaIl0sWzAsMSwiQSJdLFsxLDEsIkEgdGltZXMgQiJdLFsyLDEsIkIiXSxbMCwyLCJVX3oiXSxbMiwxLCJwaV9BIl0sWzIsMywicGlfQiIsMl0sWzAsMSwiZXRhX0EiLDJdLFswLDMsImV0YV9CIl1d
  $
    #diagram(
      node((0, -2), $Z$),
      node((-1, -1), $A$),
      node((0, -1), $A times B$),
      node((1, -1), $B$),
      edge((0, -2), (0, -1), $U_z$, "-->"),
      edge((0, -1), (-1, -1), $pi_A$, "->", label-side: left),
      edge((0, -1), (1, -1), $pi_B$, "->", label-side: right),
      edge((0, -2), (-1, -1), $eta_A$, "->"),
      edge((0, -2), (1, -1), $eta_B$, "->"),
    )
  $
  #remark[
    This *uniqueness* depends on the specific choice of $pi_A$ and $pi_B$. One must realize that _product_ is not just an object, but also the morphisms $pi_A, pi_B$.
  ]
]

#remark[Only _some_ categories have products.]

#remark[If $U_Z$ does not need to be unique, it's called a _weak product_.]

_e.g._
- cartesian product in _Set_
- $and$ in _Prop_

#theorem[
  The product $A times B$ $(A times B, pi_1, pi_2)$ of $A, B in ob(cal(C))$ is unique up to _unique isomorphism_.
]

#proof[
  + #grid(columns: (1fr, 1fr))[
      Recall the very definition of product (an object, and two project morphisms). First we introduce $A times B$ and $A times' B$:
    ][
      // #q=WzAsNCxbMSwwLCJBIHRpbWVzIEIiXSxbMSwxLCJBIHRpbWVzJyBCIl0sWzAsMiwiQSJdLFsyLDIsIkIiXSxbMCwyLCJwaV9BIiwyXSxbMCwzLCJwaV9CIl0sWzEsMiwicGknX0EiXSxbMSwzLCJwaSdfQiIsMl1d
      $
        #diagram(
          node((0, -1), $A times B$),
          node((0, 0), $A times' B$),
          node((-1, 1), $A$),
          node((1, 1), $B$),
          edge((0, -1), (-1, 1), $pi_A$, "->"),
          edge((0, -1), (1, 1), $pi_B$, "->"),
          edge((0, 0), (-1, 1), $pi'_A$, "->", label-side: left),
          edge((0, 0), (1, 1), $pi'_B$, "->", label-side: right),
        )
      $
    ]
  + #grid(columns: (1fr, 1fr))[
      Compare the previous diagram with the universal property of product. "Instantiate" the universal property of $A times' B$ and we have a unique morphism #tpurple($A times B ->^(!f) A times' B$):
    ][
      // #q=WzAsNCxbMSwwLCJBIHRpbWVzIEIiXSxbMSwxLCJBIHRpbWVzJyBCIl0sWzAsMiwiQSJdLFsyLDIsIkIiXSxbMCwyLCJwaV9BIiwyXSxbMCwzLCJwaV9CIl0sWzEsMiwicGknX0EiXSxbMSwzLCJwaSdfQiIsMl0sWzAsMSwiZiIsMCx7ImNvbG91ciI6WzI3MCw2MCw2MF0sInN0eWxlIjp7ImJvZHkiOnsibmFtZSI6ImRhc2hlZCJ9fX0sWzI3MCw2MCw2MCwxXV1d
      $
        #diagram(
          node((0, -1), $A times B$),
          node((0, 0), $A times' B$),
          node((-1, 1), $A$),
          node((1, 1), $B$),
          edge((0, -1), (-1, 1), $pi_A$, "->"),
          edge((0, -1), (1, 1), $pi_B$, "->"),
          edge((0, 0), (-1, 1), $pi'_A$, "->", label-side: left),
          edge((0, 0), (1, 1), $pi'_B$, "->", label-side: right),
          edge((0, -1), (0, 0), text(fill: color.hsl(270deg, 60%, 60%), $!f$), label-side: left, "-->", stroke: color.hsl(270deg, 60%, 60%)),
        )
      $
    ]
    #pitfall[
      #grid(columns: (1fr, 1fr))[
        One might attempt to do the following thing to close the proof:

        This is not correct, because for $A times B$ and $A times' B$ to be isomorphic one also needs to show
        $ !f' compose !f = id_(A times B) $
        which is not depicted in the diagram.
      ][
        // #q=WzAsNCxbMSwwLCJBIHRpbWVzIEIiXSxbMSwxLCJBIHRpbWVzJyBCIl0sWzAsMiwiQSJdLFsyLDIsIkIiXSxbMCwyLCJwaV9BIiwyXSxbMCwzLCJwaV9CIl0sWzEsMiwicGknX0EiXSxbMSwzLCJwaSdfQiIsMl0sWzAsMSwiIWYiLDJdLFsxLDAsIiFmJyIsMix7ImN1cnZlIjoxLCJjb2xvdXIiOlsyNzAsNjAsNjBdLCJzdHlsZSI6eyJib2R5Ijp7Im5hbWUiOiJkYXNoZWQifX19LFsyNzAsNjAsNjAsMV1dXQ==
        $
          #diagram(
            node((0, -1), $A times B$),
            node((0, 0), $A times' B$),
            node((-1, 1), $A$),
            node((1, 1), $B$),
            edge((0, -1), (-1, 1), $pi_A$, "->"),
            edge((0, -1), (1, 1), $pi_B$, "->"),
            edge((0, 0), (-1, 1), $pi'_A$, "->", label-side: left),
            edge((0, 0), (1, 1), $pi'_B$, "->", label-side: right),
            edge((0, -1), (0, 0), $!f$, "->", label-side: right),
            edge((0, 0), (0, -1), text(fill: color.hsl(270deg, 60%, 60%), $!f'$), "-->", stroke: color.hsl(270deg, 60%, 60%), bend: -15deg),
          )
        $
      ]
    ]
  + #grid(columns: (1fr, 1fr))[
      For sake of reasoning, let's duplicate $A times B$ below $A times' B$ and exercise the universal property of $A times B$ with "apex" $A times' B$ to show #tpurple($A times' B ->^(!g) A times B$):
    ][
      // #q=WzAsNSxbMSwwLCJBIHRpbWVzIEIiXSxbMSwxLCJBIHRpbWVzJyBCIl0sWzAsMiwiQSJdLFsyLDIsIkIiXSxbMSwyLCJBIHRpbWVzIEIiXSxbMCwyLCJwaV9BIiwyXSxbMCwzLCJwaV9CIl0sWzEsMiwicGknX0EiXSxbMSwzLCJwaSdfQiIsMl0sWzAsMSwiIWYiLDJdLFs0LDIsInBpX0EiXSxbNCwzLCJwaV9CIiwyXSxbMSw0LCIhZyIsMix7ImNvbG91ciI6WzI3MCw2MCw2MF0sInN0eWxlIjp7ImJvZHkiOnsibmFtZSI6ImRhc2hlZCJ9fX0sWzI3MCw2MCw2MCwxXV1d
      $
        #diagram(
          node((0, -1), $A times B$),
          node((0, 0), $A times' B$),
          node((-1, 1), $A$),
          node((1, 1), $B$),
          node((0, 1), $A times B$),
          edge((0, -1), (-1, 1), $pi_A$, "->"),
          edge((0, -1), (1, 1), $pi_B$, "->"),
          edge((0, 0), (-1, 1), $pi'_A$, "->", label-side: left),
          edge((0, 0), (1, 1), $pi'_B$, "->", label-side: right),
          edge((0, -1), (0, 0), $!f$, "->", label-side: right),
          edge((0, 1), (-1, 1), $pi_A$, "->", label-side: left),
          edge((0, 1), (1, 1), $pi_B$, "->", label-side: right),
          edge((0, 0), (0, 1), text(fill: color.hsl(270deg, 60%, 60%), $!g$), "-->", stroke: color.hsl(270deg, 60%, 60%), label-side: right),
        )
      $
    ]
  + #grid(columns: (1fr, 1fr))[
      We can also "instantiate" the universal property of the lower $A times B$ with apex being the upper $A times B$, to show there exists a unique morphism #tpurple($A times B -> A times B$):
    ][
      // #q=WzAsNSxbMSwwLCJBIHRpbWVzIEIiXSxbMSwxLCJBIHRpbWVzJyBCIl0sWzAsMiwiQSJdLFsyLDIsIkIiXSxbMSwyLCJBIHRpbWVzIEIiXSxbMCwyLCJwaV9BIiwyXSxbMCwzLCJwaV9CIl0sWzEsMiwicGknX0EiXSxbMSwzLCJwaSdfQiIsMl0sWzAsMSwiIWYiLDJdLFs0LDIsInBpX0EiXSxbNCwzLCJwaV9CIiwyXSxbMSw0LCIhZyIsMl0sWzAsNCwiIiwyLHsiY3VydmUiOi0xLCJjb2xvdXIiOlsyNzAsNjAsNjBdLCJzdHlsZSI6eyJib2R5Ijp7Im5hbWUiOiJkYXNoZWQifX19XV0=
      $
        #diagram(
          node((0, -1), $A times B$),
          node((0, 0), $A times' B$),
          node((-1, 1), $A$),
          node((1, 1), $B$),
          node((0, 1), $A times B$),
          edge((0, -1), (-1, 1), $pi_A$, "->"),
          edge((0, -1), (1, 1), $pi_B$, "->"),
          edge((0, 0), (-1, 1), $pi'_A$, "->", label-side: left),
          edge((0, 0), (1, 1), $pi'_B$, "->", label-side: right),
          edge((0, -1), (0, 0), $!f$, "->", label-side: right),
          edge((0, 1), (-1, 1), $pi_A$, "->", label-side: left),
          edge((0, 1), (1, 1), $pi_B$, "->", label-side: right),
          edge((0, 0), (0, 1), $!g$, "->", label-side: right),
          edge((0, -1), (0, 1), "-->", stroke: color.hsl(270deg, 60%, 60%), bend: 15deg),
        )
      $
    ]

  + Note that $A times B ->^(!g compose !f) A times B$, and also $A times B ->^(id_(A times B)) A times B$. By the previous reasoning, there exists only one morphism, so $!g compose !f = id_(A times B)$. Similarly, $!f compose !g = id_(A times' B)$.
    By uniqueness of $!f$ and $!g$, this isomorphism is _unique_.

    #pitfall[
      This _uniqueness_ depends on a specific choice of $pi_A$ and $pi_B$. In other words, if we only consider the product objects $A times B$ and $A times' B$, their isomorphism might not be unique because we have the freedom to choose different projection morphisms $pi_A, pi_B$ and $pi'_A, pi'_B$, and they form their own unique isomorphism.
    ]
]

#definition(name: "Product Category")[
  Define new category $cal(C)_(A, B)$,

  + *Objects*: diagrams of the form
    // #q=WzAsMyxbMSwwLCJaIl0sWzAsMSwiQSJdLFsyLDEsIkIiXSxbMCwxLCJldGFfQSIsMl0sWzAsMiwiZXRhX0IiXV0=
    $
      #diagram(
        node((0, -1), $Z$),
        node((-1, 0), $A$),
        node((1, 0), $B$),
        edge((0, -1), (-1, 0), $eta_A$, "->"),
        edge((0, -1), (1, 0), $eta_B$, "->"),
      )
    $
    It can also be called a _span_ from $A$ to $B$.
  + *Morphisms*: $tpurple(f)$ shown in the following diagram
    // #q=WzAsNCxbMSwwLCJaIl0sWzAsMSwiQSJdLFsyLDEsIkIiXSxbMSwyLCJZIl0sWzAsMSwiZXRhX0EiLDJdLFswLDIsImV0YV9CIl0sWzMsMSwieV9BIl0sWzMsMiwieV9CIiwyXSxbMywwLCJmIiwyLHsiY29sb3VyIjpbMjcwLDYwLDYwXX0sWzI3MCw2MCw2MCwxXV1d
    $
      #diagram(
        node((0, -1), $Z$),
        node((-1, 0), $A$),
        node((1, 0), $B$),
        node((0, 1), $Y$),
        edge((0, -1), (-1, 0), $eta_A$, "->"),
        edge((0, -1), (1, 0), $eta_B$, "->"),
        edge((0, 1), (-1, 0), $y_A$, "->"),
        edge((0, 1), (1, 0), $y_B$, "->"),
        edge((0, 1), (0, -1), text(fill: color.hsl(270deg, 60%, 60%), $f$), "->", stroke: color.hsl(270deg, 60%, 60%)),
      )
    $
]

#theorem[
  _Product_ of A,B in $cal(C)$ is the _terminal object_ in $cal(C)_(A, B)$.
]

#definition(name: "Product, Alternative")[
  Consider $A, B in ob(cal(C))$, the product of $A, B$ is an object $A times B in ob(cal(C))$ with the property that
  $ hom_cal(C)(Z, A times B) tilde.equiv hom_(C)(Z, A) times hom_(C)(Z, B) $
]

#theorem[
  This formation of product is equivalent to the previous two.
]

#todo[
  This reminds me of _natural transformations_. Instead of producting objects (as in the first definition), we are producting morphisms now.
]

We can also revisit the definition of terminal object and define it as follows:

#definition(name: "Terminal Object, Alternative")[
  The *terminal object* of $cal(C)$ is an object $T$ s.t.
  $ hom(Z, T) tilde.equiv {top} $
]

#todo[i heard the word terminal?? pull out T?? what is a limit here???]

== Coproduct

#definition(name: "Coproduct")[
  A *coproduct* ($A + B$) of two objects $A, B$ in a category $cal(C)$ is the _product_ of $A, B$ in $cal(C)^(op)$.
  // #q=WzAsNCxbMSwxLCJBK0IiXSxbMCwxLCJBIl0sWzIsMSwiQiJdLFsxLDAsIloiXSxbMSwwLCJ0YXVfQSJdLFsyLDAsInRhdV9CIiwyXSxbMSwzLCJldGFfQSIsMl0sWzIsMywiZXRhX0IiXSxbMCwzLCIiLDEseyJzdHlsZSI6eyJib2R5Ijp7Im5hbWUiOiJkYXNoZWQifX19XV0=
  $
    #diagram(
      node((0, 0), $A+B$),
      node((-1, 0), $A$),
      node((1, 0), $B$),
      node((0, -1), $Z$),
      edge((-1, 0), (0, 0), $iota_A$, "->", label-side: right),
      edge((1, 0), (0, 0), $iota_B$, "->", label-side: left),
      edge((-1, 0), (0, -1), $eta_A$, "->"),
      edge((1, 0), (0, -1), $eta_B$, "->"),
      edge((0, 0), (0, -1), "-->"),
    )
  $
]

Intuitively, one can make sense of this syntax by thinking of $A + B$ as the disjoint union of $A$ and $B$.

= Syntactic Category of STLC $cal(C)_(TT)$

#definition(name: "Syntactic Category of STLC")[
  The *syntactic category* $cal(C)_(TT)$ for a _simply typed $lambda$-calculus_ $TT$ is defined as follows:
  - *Objects*: types
  - *Morphisms*: $x: S tack.r t: T$
  One can see it satisfies:
  - *Id*:
    #prooftree(rule(
      $x: S tack.r x: S$,
      name: $x$,
    ))
  - *Comp*:
    #prooftree(rule($x: S tack.r u[t"/"y]: U$, $x: S tack.r t: T$, $y: T tack.r u: U$, name: msmcp("Subst")))
]

Now let's add product to our $TT$.

#align(center)[
  #mathpar(
    rule(
      $A times B "type"$,
      $A "type"$,
      $B "type"$,
      name: $times_F$,
    ),
    rule($z: Z tack.r (a, b): A times B$, $z: Z tack.r a: A$, $z: Z tack.r b: B$, name: tpurple($times_I$)),
    rule($z: Z tack.r pi_A p: A$, $z: Z tack.r p: A times B$, name: tred($times_E_A$)),
    rule($z: Z tack.r pi_B p: B$, $z: Z tack.r p: A times B$, name: tred($times_E_B$)),
  )
]

and confirm it satisfies the universal property of product,

// #q=WzAsNCxbMSwwLCJaIl0sWzAsMSwiQSJdLFsxLDEsIkEgdGltZXMgQiJdLFsyLDEsIkIiXSxbMCwyLCJVX3oiXSxbMiwxLCJwaV9BIl0sWzIsMywicGlfQiIsMl0sWzAsMSwiZXRhX0EiLDJdLFswLDMsImV0YV9CIl1d
$
  #diagram(
    node((0, -2), $Z$),
    node((-1, -1), $A$),
    node((0, -1), $p: A times B$),
    node((1, -1), $B$),
    edge((0, -2), (0, -1), tpurple($times_I$), "-->", stroke: purple),
    // edge((0, -2), (0, -1), tred($times_I$), "-->", label-size: right, stroke: purple),
    // TODO make this ×I both purple and red
    edge((0, -1), (-1, -1), tred($times_E_A$), "->", label-side: left, stroke: red),
    edge((0, -1), (1, -1), tred($times_E_B$), "->", label-side: right, stroke: red),
    edge((0, -2), (-1, -1), tpurple($eta_A$), "->", stroke: purple),
    edge((0, -2), (1, -1), tpurple($eta_B$), "->", stroke: purple),
  )
$

Thus, there's an _intepretation_ from $TT$ to the category $cal(C)_(TT)$.

#remark[
  The _syntactic category_ $cal(C)_(TT)$ is very helpful to define alternative semantics for $TT$. With $cal(C)_(TT)$, one can construct morphisms from $cal(C)_(TT)$ to other categories to give various different semantics to $TT$.
]

= Functors

#definition(name: "Functor")[
  A *functor* $F: cal(C) -> cal(D)$ consists of

  + A function $ob F : ob cal(C) -> ob cal(D)$
  + A function $F_(X, Y): hom_cal(C)(X, Y) -> hom_(cal(D)) (F X, F Y)$ for all $X, Y in ob cal(C)$

  such that
  + (*Id*) $F_(X, X) id_X = id_(F X)$ for all $X in ob cal(C)$
  + (*Comp*) $F_(X, Z) (g compose f) = F_(Y, Z)(g) compose f_(X, Y)(f)$ for $X ->^f Y ->^g Z in cal(C)$
]

#remark[$ob F$ and $F_(X, Y)$ are just notations. It doesn't mean $F$ is a category.]

#theorem[
  Functors preserve isomorphisms.
]

#proof[
  + From
    // #q=WzAsMixbMCwwLCJYIl0sWzEsMCwiWSJdLFswLDEsImYiLDAseyJvZmZzZXQiOi0xfV0sWzEsMCwiZl4oLTEpIiwwLHsib2Zmc2V0IjotMX1dXQ==
    $#diagram(
      node((-1, -1), $X$),
      node((0, -1), $Y$),
      edge((-1, -1), (0, -1), $f$, "->", shift: -1pt),
      edge((0, -1), (-1, -1), $f^(-1)$, "->", label-side: left, shift: -1pt),
    )$
    this holds:
    // #q=WzAsMixbMCwwLCJYIl0sWzEsMCwiWSJdLFswLDEsImYiLDAseyJvZmZzZXQiOi0xfV0sWzEsMCwiZl4oLTEpIiwwLHsib2Zmc2V0IjotMX1dXQ==
    $#diagram(
      node((-1, -1), $F X$),
      node((0, -1), $F Y$),
      edge((-1, -1), (0, -1), $F f$, "->", shift: -1pt),
      edge((0, -1), (-1, -1), $F f^(-1)$, "->", label-side: left, shift: -1pt),
    )$
  + So, $F f compose F f^(-1) = F (f compose f^(-1)) = F id_Y = id_(F Y)$
    and vice versa.
]

_e.g._
+ _Id functor_ $"Id"_cal(C): cal(C) -> cal(C)$
+ _Functor comp_ $G compose F$:\
  Given $F: cal(C) -> cal(D)$ and $G: cal(D) -> cal(E)$, define $G compose F: cal(C) -> cal(E)$ by
  - $ob (G compose F): ob cal(C) -> ob cal(E) = lambda X. ob G (ob F (X))$
    #todo[$(G compose F) med x = G (F x)$]
  - $(G compose F)_(X, Y) : hom_cal(C)(X, Y) -> hom_cal(E)(G F X, G F Y) = G_(F X, F Y) compose F_(X, Y)$

== Category of Categories

#remark(name: "Category of Categories")[
  The *category of categories* $italic("Cat")$ is informally defined as follows:
  - *Objects*: categories
  - *Morphisms*: functors
]

Now we can define various functors on $italic("Cat")$.

#example[
  Consider $bb(1) = {A}$, and $X in ob cal(C)$, there's functor $[X]: bb(1) -> cal(C)$ such that
  + $ob_([X]) = ob bb(1) -> ob_(cal(C))$
  + $[X]_(Y, Z): hom_bb(1) (Y, Z) -> hom_(cal(C))(X, X) = lambda \_. id_X$
  Intuitively, this is picking one object $X$ out of $cal(C)$.
]

#example[
  Given $cal(C)$, there is a functor $!: cal(C) -> bb(1)$ such that
  + $ob !: ob cal(C) -> ob bb(1) := lambda \_. A$
  + $!_(X, Y) : hom_cal(C)(X, Y) -> hom_bb(1) (A, A) := lambda \_. id_A$
]

#remark[
  - $bb(1)$ is terminal in $italic("Cat")$ because for any category $cal(C)$, there is a unique functor $cal(C) ->^! bb(1)$. It is unique because the only object in $bb(1)$ is $A$, and the only morphism is $id_A$.
  - Similarly, $bb(0)$ is initial in $italic("Cat")$ because for any category $cal(C)$, there is a unique empty functor $bb(0) ->^excl.inv cal(C)$.
]

_e.g._ $italic("Set") arrow.curve italic("Cat")$

_E.g._ $cal(C) times cal(D)$
- *Objects*: $ob cal(C) times ob cal(D)$
- *Morphisms*: $hom_(cal(C) times cal(D)) ((C, D), (C', D')) := hom_cal(C)(C, C') times hom_cal(D)(D, D')$

_E.g._ $cal(D) + cal(D)$
- *Objects*: $ob cal(C) + ob cal(D)$
- *Morphisms*:
  $
    & hom_(C + D) (C, C') && := hom_cal(C)(C, C') \
    & hom_(C + D) (D, D') && := hom_cal(D)(D, D') \
    & hom_(C + D) (C, D)  && := emptyset          \
    & hom_(C + D) (D, C)  && := emptyset
  $

#example(name: "Maybe Functor")[
  Consider $cal(C)$ with $+, top$.\
  We can define a *Maybe functor* $"Maybe": cal(C) -> cal(C)$ that behaves like a haskell `Maybe`:
  + $"Maybe" med X := X + T$
  + $hom_("Maybe" cal(C)) (X, Y)$ is depicted in the following diagram, while $tred(f)$ is the input morphism and $tpurple(f + id_T)$ is the result.
    // #q=WzAsNCxbMCwxLCJYIl0sWzIsMSwidG9wIl0sWzEsMSwiWCArIHRvcCJdLFsxLDAsIlkgKyB0b3AiXSxbMCwyLCJpb3RhX0EiXSxbMSwyLCJpb3RhX0IiLDJdLFswLDMsImlvdGFfQSBjb21wb3NlIGYiLDJdLFsxLDMsImlkIl0sWzIsMywiIiwxLHsic3R5bGUiOnsiYm9keSI6eyJuYW1lIjoiZGFzaGVkIn19fV1d
    $
      #diagram(
        spacing: 3em,
        node((-1, 0), $X$),
        node((1, 0), $top$),
        node((0, 0), $X + top$),
        node((0, -1), $Y + top$),
        edge((-1, 0), (0, 0), $iota_1$, "->"),
        edge((1, 0), (0, 0), $iota_2$, "->", label-side: right),
        edge((-1, 0), (0, -1), $iota_1 compose tred(f)$, "->"),
        edge((1, 0), (0, -1), $iota_2 compose id$, "->"),
        edge((0, 0), (0, -1), "-->", label: tpurple($f + id_T$), label-side: center, stroke: colors.mauve),
      )
    $
]

= CH-Lambek Correspondence

Define a category $cal(C)_(TT)$ (syntactic category) for a _simply typed $lambda$-calculus_ $TT$ with
+ structural rules
+ rules for unit type
+ rules for product type
+ constant symbols $C$ for types
+ constant symbols $c$ for terms

#remark[
  Recall that _objects_ are types and _morphisms_ are terms in $cal(C)_(TT)$.
]

#theorem[
  There is a _functor_ $F: tpurple(cal(C)_TT) -> tred(cal(D))$ where $D$ is a category with _products_ and _terminal object_ such that
  + $F(T)$ for all $T in C$
  + $F(t)$ for all $t in c$
  + $F("unit") := bb(1)$
  + $F(S times T) = F(S) times F(T)$
]
#todo[Proof that it is a functor.]

#definition(name: "Category of Models")[
  $cal(M)_TT$ is the category with
  + *Objects*: categories with terminal objects, products, interpretation $[C], [c]$ for each $T in C, t in c$.
  + *Morphisms*: functors that preserve terminal objects, products and interpretation.
    _E.g._ for any $F: cal(C) -> cal(D), F(bb(1)_C) tilde.equiv bb(1)_cal(D)$
]

*Fact*. $tpurple(cal(C)_TT)$ is the initial object of $cal(M)_TT$. $tred(cal(D))$ is an arbitrary object of $cal(M)_TT$.

#theorem(name: "Lambek")[
  The category of extensions of _STLC_ with _function types_ is *equivalent* to the category of categories with terminal objects, products, and _exponent objects_.
]

#remark[
  - product - product
  - unit - terminal object
  - function type - exponent object

  Intuitively, isomorphism of categories $cal(C)$ and $cal(D)$ looks like:
  // #q=WzAsMixbMCwwLCJYIl0sWzEsMCwiWSJdLFswLDEsImYiLDAseyJvZmZzZXQiOi0xfV0sWzEsMCwiZl4oLTEpIiwwLHsib2Zmc2V0IjotMX1dXQ==
  $
    #diagram(
      node((-1, -1), $cal(C)$),
      node((0, -1), $cal(D)$),
      edge((-1, -1), (0, -1), $F$, "->", shift: -1pt),
      edge((0, -1), (-1, -1), $G$, "->", label-side: left, shift: -1pt),
    )
  $
  where $G compose F tilde.equiv "Id"_cal(C)$ and $F compose G tilde.equiv "Id"_cal(D)$.

  #todo[This part needs clarification.]
]

#todo[
  Given a $TT$
  + Look at objects in $cal(M)_TT$
  + Look at objects ?? with morphisms $cal_TT -> cal(D)$
]

= Moral
+ Type theory is category theory.
+ Category of CCC contains categories of _real_ objects (sets, topological spaces, types, etc.)
+ (_A category of a certain model_) can be used to show certain statements are not provable.
+ Type theory is an _informal language_ for these categories.

= Bonus: Inductive types $NN$

$NN$ in PL is defined as:
$
  O & : "unit" -> NN \
  S & : NN -> NN
$

Inspired by this, to make it a category, we want to define $"unit" + NN -> NN$.
// #q=WzAsNCxbMSwwLCJcInVuaXRcIiArIE5OIl0sWzAsMCwiXCJ1bml0XCIiXSxbMiwwLCJOTiJdLFsxLDEsIk5OIl0sWzEsMF0sWzEsMywiTyIsMl0sWzIsMywiUyJdLFsyLDBdLFswLDMsIk8gKyBTIiwxLHsic3R5bGUiOnsiYm9keSI6eyJuYW1lIjoiZGFzaGVkIn19fV1d
$
  #diagram(
    node((0, 0), $"unit" + NN$),
    node((-1, 0), $"unit"$),
    node((1, 0), $NN$),
    node((0, 1), $NN$),
    edge((-1, 0), (0, 0), "->"),
    edge((-1, 0), (0, 1), $O$, "->", label-side: right),
    edge((1, 0), (0, 1), $S$, "->", label-side: left),
    edge((1, 0), (0, 0), "->"),
    edge((0, 0), (0, 1), $O + S$, "-->", label-side: center, label-fill: true),
  )
$

This looks very similar to *induction*: we can generalize it a bit and say that $NN$ has $O, S$ but that functions $NN -> A$ corresponds to
$
  Z & : "unit" -> A \
  O & : A -> A
$
i.e. $"unit" + A -> A$

Naturally, functor _Maybe_ ($cal(C) -> cal(C)$) might be helpful: $A |-> "unit" + A$
#remark[$cal(C)$ could be syntactic category for a type theory]

#definition(name: "Maybe-Algebra")[
  Define a category $a l g_"Maybe"$ of Maybe-algebras:
  - *Objects*: $(A, a)$ where $A in ob cal(C), a: "Maybe" A -> A$
  - *Morphisms*: $(A, a) ->^f (B, b)$ are morphisms $A ->^f B$ in $cal(C)$ s.t.
    // #q=WzAsNCxbMCwwLCJcInVuaXRcIitBIl0sWzEsMCwiQSJdLFswLDEsIlwidW5pdFwiK0IiXSxbMSwxLCJCIl0sWzAsMiwiaWRfXCJ1bml0XCIgKyBmIl0sWzAsMSwiYSIsMl0sWzIsMywiYiJdLFsxLDMsImYiLDJdXQ==
    $
      #diagram(
        node((-1, -1), $"unit"+A$),
        node((0, -1), $A$),
        node((-1, 0), $"unit"+B$),
        node((0, 0), $B$),
        edge((-1, -1), (-1, 0), $id_"unit" + f$, "->"),
        edge((-1, -1), (0, -1), $a$, "->", label-side: right),
        edge((-1, 0), (0, 0), $b$, "->"),
        edge((0, -1), (0, 0), $f$, "->", label-side: right),
      )
    $
    i.e. $f$ is a morphism that preserves the structure of Maybe-algebra. $ f compose a = b compose "Maybe" f $
    #remark[
      $f$ is unique regarding a given pair of $(A, a)$ and $(B, b)$. #todo[why?]
    ]
]

*Observation.* $NN$ is the initial object of $a l g_"Maybe"$.

#remark[
  Not every functor has a initial object in its category of algebras. It's a privilege of _polynomial endo-functors_.
]

Recall that we can prove _Set_ is a model of _MLTT_.

Similarly,

*Claim.* $NN$ is the _genuine_ natural number.

Recall we can add _co-_ prefixes to concepts in category theory lol,

Define $italic("Co-alg")_F$ on
$(A, a)$ where $A in ob cal(C), a: A -> F A$

And we take its _terminal object_. That's how we get _coinductive types_.

= References

Lambek + Scott. Intro to higher order categorical logic. (Background required: logic)
Altenkirch: Category theory for the lazy functional programmers
Ahrens, Wullaert: Category theory for programmers
