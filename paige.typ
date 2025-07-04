#import "prelude.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let diagram = diagram.with(spacing: 2em, label-sep: 0em)

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

  - $f compose id_X = f = id_Y compose f$

    #note[Normally we don't differentiate left and right identity. There was one particular notion that did, but then they were shown to be equivalent.]
  - for any $f: X -> Y, g: Y -> Z, h: Z -> A$,
    $h compose (g compose f) = (h compose g) compose f$.

=== Commutative Diagrams

*E.g.* $f compose id_X = f$

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

== Terminal Object

A *terminal object* ($*$) $T$ in a category $cal(C)$ is an object such that for every object $Z in cal(C)$, there is a unique morphism $Z ->^! T$.

_E.g._
- a singleton set ($\{top\}$) in _Set_
- unit type ($1$) in _Ty_
- $A$ in _a category that contains exactly one object $A$_.

== Isomorphic

Two objects $X, Y$ in a category $cal(C)$ are *isomorphic* if there exists morphisms $f: X -> Y$ and $g: Y -> X$ such that $g compose f = id_X$ and $f compose g = id_Y$.

#note[
  If $x tilde.equiv y$, we say
  + $f$ is an _isomorphism_ that $f: X tilde.equiv Y$, $f: X ->^tilde Y$
  + $g$ as $f^(-1)$, and  $f^(-1): Y tilde.equiv X$, $f^(-1): Y ->^tilde X$
]

_E.g._
- _bijection_ in _Set_
- _bi-implication_ in _Prop_

*Lemma*. If $f: X tilde.equiv Y$, then for any $Z$, we have
- $f_*: hom(Z, X) scripts(tilde.equiv)_(italic("Set")) hom(Z, Y)$.
- $f^*: hom(Z, X) scripts(tilde.equiv)_(italic("Set")) hom(Z, Y)$.
*Proof*. ($f_*$)
- $=>$\
  For any $g in hom(Z, X)$, we have $g: Z -> X$. Also we know $tpurple(X ->^f Y)$. So, $tpurple(f) compose g : Z ->^g X ->^tpurple(f) Y$.

- $arrow.double.l$\
  For any $h in hom(Z, Y)$, we have $h: Z -> Y$. Also we know $tpurple(Y ->^(f^(-1)) X)$. So, $tpurple(f^(-1)) compose h : Z ->^h Y ->^tpurple(f^(-1)) X$.

*Lemma*. Terminal objects are _unique up to isomorphism_.

*Proof*.
Let $T, T'$ be two terminal objects in a category $cal(C)$.\
Since $T$ is terminal, there exists a unique morphism $f: T' ->^(!') T$. Similarly, there exists a unique morphism $g: T ->^! T'$.\
Now $! compose !': T ->^(!') T' ->^! T = id_T$. Similarly, $!' compose ! = id_(T')$.

#note[
  We know $T ->^(!') T' ->^! T$ is $id_T$ because $T$ is terminal, which means for every object $Z$ there is a _unique_ morphism $Z ->^! T$. In particular, for $Z = T$, there is a _unique_ morphism $T ->^! T$. And we know $id_T: T -> T$ is one of the morphisms, so that's it.

  Generally, there could be multiple morphisms to oneself, but in this case it's the terminal part that makes it unique.
]

== Duality

Given a category $cal(C)$, we can define its *dual category* $cal(C)^{op}$ by reversing the direction of all morphisms.
$ ob cal(C)^op := ob cal(C), hom_cal(C)^{op}(X, Y) := hom_cal(C)(Y, X) $

*Lemma*. $cal(C)^op$ is a category.

*Lemma*. If $X tilde.equiv Y$ in $cal(C)$, then $X tilde.equiv Y$ in $cal(C)^{op}$.

== Initial Object

An *initial object* $I$ in a category $cal(C)$ is the terminal object in $cal(C)^op$.

or,

An *initial object* $I$ in a category $cal(C)$ is an object such that for every object $Z in cal(C)$, there is a unique morphism $I ->^excl.inv Z$.

*Lemma*. Initial objects are _unique up to isomorphism_.\
*Proof*. Follows dually from the uniqueness of terminal objects.

_E.g._
- empty set ($emptyset$) in _Set_
- empty type ($0$) in _Ty_
- false ($bot$) in _Prop_

== Product

A *product* of two objects $A, B$ in a category $cal(C)$ contains
+ an _object_ $A times B in ob(cal(C))$
+ _morphisms_ $A times B ->^(pi_A) A, A times B ->^(pi_B) B$,\
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
  #note[
    This *uniqueness* depends on the specific choice of $pi_A$ and $pi_B$. One must realize that _product_ is not just an object, but also the morphisms $pi_A, pi_B$.
  ]

#note[Only _some_ categories have products.]

#note[If $U_Z$ does not need to be unique, it's called a _weak product_.]

_E.g._
- cartesian product in _Set_
- $and$ in _Prop_

*Theorem* The product $A times B$ $(A times B, pi_1, pi_2)$ of $A, B in ob(cal(C))$ is unique up to _unique isomorphism_.\
*Proof*.
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
  #warn[
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

  #warn[
    This _uniqueness_ depends on a specific choice of $pi_A$ and $pi_B$. In other words, if we only consider the product objects $A times B$ and $A times' B$, their isomorphism might not be unique because we have the freedom to choose different projection morphisms $pi_A, pi_B$ and $pi'_A, pi'_B$, and they form their own unique isomorphism.
  ]

*Alternative Definition 1* Define new category $cal(C)_(A, B)$,

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

*Theorem*. _Product_ of A,B in $cal(C)$ is the _terminal object_ in $cal(C)_(A, B)$.

*Alternative Definition*. Consider $A, B in ob(cal(C))$, the product of $A, B$ in an object $A times B in ob(cal(C))$ with the property that
$ hom_cal(C)(Z, A times B) tilde.equiv hom_(C)(Z, A) times hom_(C)(Z, B) $

*Theorem*. This formation of product is equivalent to the previous two.

#todo[
  This reminds me of _natural transformations_. Instead of producting objects (as in the first definition), we are producting morphisms now.
]

*Def* The terminal object of $cal(C)$ is an object $T$ s.t.
$ hom(Z, T) tilde.equiv {top} $

#todo[i heard the word terminal?? pull out T?? what is a limit here???]

== Coproduct

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

Intuitively, one can make sense of this syntax by thinking of $A + B$ as the disjoint union of $A$ and $B$.

== Syntactic Category of STLC

For a _simply typed $lambda$-calculus_ $Pi$, define its *syntactic category* $cal(C)_(Pi)$ as follows:
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

Now let's add product to our $Pi$.

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

Thus, there's an intepretation from $Pi$ to the category $cal(C)_(Pi)$. After that, one can construct morphisms from $cal(C)_(Pi)$ to other categories to give various different semantics to $Pi$.
