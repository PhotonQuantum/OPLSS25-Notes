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

== Terminal Object

A *terminal object* ($*$) $T$ in a category $cal(C)$ is an object such that for every object $Z in cal(C)$, there is a unique morphism $Z ->^! T$.

_E.g._
- a singleton set ($\{top\}$) in _Set_
- unit type ($1$) in _Ty_
- $A$ in _a category that contains exactly one object $A$_.

== Isomorphic

Two objects $X, Y$ in a category $cal(C)$ are *isomorphic* if there exists morphisms $f: X -> Y$ and $g: Y -> X$ such that $g circle f = id_X$ and $f circle g = id_Y$.

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
  For any $g in hom(Z, X)$, we have $g: Z -> X$. Also we know $tpurple(X ->^f Y)$. So, $tpurple(f) circle g : Z ->^g X ->^tpurple(f) Y$.

- $arrow.double.l$\
  For any $h in hom(Z, Y)$, we have $h: Z -> Y$. Also we know $tpurple(Y ->^(f^(-1)) X)$. So, $tpurple(f^(-1)) circle h : Z ->^h Y ->^tpurple(f^(-1)) X$.

*Lemma*. Terminal objects are _unique up to isomorphism_.

*Proof*.
Let $T, T'$ be two terminal objects in a category $cal(C)$.\
Since $T$ is terminal, there exists a unique morphism $f: T' ->^(!') T$. Similarly, there exists a unique morphism $g: T ->^! T'$.\
Now $! circle !': T ->^(!') T' ->^! T = id_T$. Similarly, $!' circle ! = id_(T')$.

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