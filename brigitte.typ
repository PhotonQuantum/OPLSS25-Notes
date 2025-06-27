#import "prelude.typ": *

#show: codly-init.with()

#codly(languages: codly-languages)

== Judgment

Analytic judgments are those that become evident by conceptual analysis.

#prooftree(rule(
  $J_c$,
  $J_1$,
  $dots$,
  $J_n$,
))

#let wf = `wf`

+ *Syntax*: well-formed

  E.g.
  #mathpar(
    rule(
      $T #wf$,
    ),
    rule(
      $A circle B #wf$,
      $A wf$,
      $B wf$,
    ),
  )

+ *Semantics*: true
  + *I*: _introduce_ a connective
  + *E*: _extract_ info out of a pure connective

  E.g.

  #mathpar(rule($A and B$, $A$, $B$, name: $and I$), rule($A$, $A and B$, name: $and E_1$))


== Hypothetical Reasoning

Given $P$, $Q$ holds.

+ *$=>I$*: Internalizing a reasoning process.

  E.g.

  #prooftree(rule($P_1, P_2 => Q$, rule($Q$, rule(
    $dots$,
    $P_1$,
    $P_2$,
  ))))

Note that $P$s and $Q$s cease to exist in the conclusion, thus "internalized".

+ *$=>E$*: modus ponens

== Properties of assumtions (structural)

*Weakening*: assumptions can be unused

#prooftree(rule(
  $A => B => A$,
  rule(
    tpurple($B => A$),
    rule(
      tpurple($A$),
      name: $u$,
    ),
    rule(
      tgreen($B$),
      name: $w$,
      label: "(unused)",
    ),
    name: tgreen($=>I^w$),
  ),
  name: tpurple($=>I^u$),
))

*Contraction*: assumptions can be used multiple times

*Substitution*: #todo[]

== Context

Notice the two dimensional rule of $=>I$:

#prooftree(rule($P_1, P_2 => Q$, rule($Q$, rule(
  $dots$,
  $P_1$,
  $P_2$,
))))

It's kind of awkward to keep this hypothetical strcture around.
Instead, we write

#prooftree(rule($Gamma tack.r P_1, P_2 => Q$, $Gamma, h_1: P_1, h_2: P_2 tack.r Q$))

Note that we declare

#prooftree(rule($Gamma tack.r A$, $x: A in Gamma$, name: $x$))

By following the same principle, we can rewrite *Weakening* and *Contraction*.

*Weakening*:
#prooftree(rule(
  $Gamma, x: A tack.r B$,
  $Gamma tack.r B$,
))

*Contraction*:
#prooftree(rule(
  $Gamma, x: A, y: A tack.r B$,
  $Gamma, x: A tack.r B$,
))

*Substitution*:
#prooftree(rule(
  $Gamma tack.r C$,
  $Gamma, x: A tack.r C$,
  $Gamma tack.r A$,
))

== Local Soundness/Completeness

*Local* in the sense that these properties only discuss *a single connective*, not the whole system. It's a weak witness that this system makes sense.

+ *Local Soundness*: the combination of intro and elim is not too strong, i.e. they don't allow us to infer more than what's already known.

  E.g. the proof
  #prooftree(rule(
    tred($Gamma tack.r A$),
    rule(
      $Gamma tack.r A times B$,
      tred($Gamma tack.r A$),
      $Gamma tack.r B$,
      name: $times I$,
    ),
    name: $times E_1$,
  ))
  collapses to
  #prooftree(rule($Gamma tack.r A$, $Gamma tack.r A$))
  so there's no additional information provided by the intro and elim rules.

+ *Local Completeness*: the combination of intro and elim is sufficiently strong, in terms of rebuilding the info we have.

  E.g. there's no information loss in the rebuild process of the connective $A times B$
  #prooftree(rule(
    $Gamma tack.r A times B$,
    rule(
      $Gamma tack.r A$,
      $Gamma tack.r A times B$,
      name: $times E_1$,
    ),
    rule(
      $Gamma tack.r B$,
      $Gamma tack.r A times B$,
      name: $times E_2$,
    ),
    name: $times I$,
  ))

== C.H.

- Propositions - Types
- Proof - Programs
- Nat. Ded. - $lambda$-calculus

Importance:
+ Guiding program language design
+ Basis of Type Theory
+ Proving logic consistency by looking at programs

=== Typing Judgment

#box(
  inset: 5pt,
  stroke: 1pt,
  $tgreen(Gamma) tack.r tblue(M): tred(A)$,
)

Given some assumptions in the context #tgreen($Gamma$),
- #tblue($M$) is a proof term corresponding to the proposition #tred($A$).
- #tblue($M$) is a program that has a type #tred($A$).

*C.H.*: $Gamma tack.r A$ iff $Gamma tack.r M: A$

Example: conjunction

#mathpar(
  rule(
    $Gamma tack.r tblue(⟨M, N⟩): A and B$,
    $Gamma tack.r M: A$,
    $Gamma tack.r N: B$,
    name: $and I$,
  ),
  rule(
    $Gamma tack.r tblue(M.1): A$,
    $Gamma tack.r tblue(M): A and B$,
  ),
  rule(
    $Gamma tack.r tblue(M.2): B$,
    $Gamma tack.r tblue(M): A and B$,
  ),
)

Example: implication

#mathpar(
  rule(
    $tgreen(Gamma) tack.r tblue(M) : tred(A -> B)$,
    $#tgreen($Gamma, x: A$) tack.r tblue(lambda x: A. M): tred(B)$,
    name: $=> I^x$,
  ),
  rule(
    $tgreen(Gamma) tack.r tblue(M N): tred(B)$,
    $tgreen(Gamma) tack.r tblue(M): tred(A -> B)$,
    $tgreen(Gamma) tack.r tblue(N): tred(A)$,
    name: $=> E$,
  ),
)

*Thm* (Local Soundness)

#box(prooftree(rule($Gamma tack.r tblue(⟨M, N⟩.1): tred(A)$, rule(
  $Gamma tack.r tblue(⟨M, N⟩): A and B$,
  $Gamma tack.r tblue(M): tred(A)$,
  $Gamma tack.r tblue(N): B$,
))))
collapses to
#box(prooftree(rule(
  $Gamma tack.r tblue(M): tred(A)$,
)))

#box(prooftree(rule(
  $Gamma tack.r tblue((lambda x: A. M) N): tred(B)$,
  rule(
    $Gamma tack.r tblue(lambda x: A. M): A -> B$,
    $Gamma, x: A tack.r tblue(M): tred(B)$,
    name: $=> I^x$,
  ),
  $Gamma tack.r tblue(N): A$,
  name: $=> E$,
)))
collapses to
#box(prooftree(rule(
  $Gamma tack.r tblue(M[N"/"x]): tred(B)$,
)))

+ *Logic*: not gaining any information through this intro and elim detour.
+ *Program*: type is *preserved* through this detour.

The "collapse" can then be written as:\
*Reduction* $tblue(⟨M, N⟩.1) arrow.double.long tblue(M)$ and $tblue((lambda x: A. M) N) arrow.double.long tblue(M[N"/"x])$.

#block(fill: gray.lighten(80%), inset: 10pt)[
  *Thm* (Subject Reduction)

  If $Gamma tack.r tblue(M): A$ and $tblue(M) arrow.double.long tblue(M')$, then $Gamma tack.r tblue(M'): A$
]

*Thm* (Local Completeness)

#box(prooftree(rule($Gamma tack.r tblue(M): A and B$))) expands to
#box(prooftree(rule(
  $Gamma tack.r tblue(⟨M.1, M.2⟩): tred(A and B)$,
  rule(
    $Gamma tack.r tblue(M.1): A$,
    $Gamma tack.r tblue(M): tred(A and B)$,
    name: $and E_1$,
  ),
  rule(
    $Gamma tack.r tblue(M.2): B$,
    $Gamma tack.r tblue(M): tred(A and B)$,
    name: $and E_2$,
  ),
  name: $and I$,
)))

#box(prooftree(rule($Gamma tack.r tblue(M): A -> B$))) ($eta$-)expands to
#box(prooftree(rule(
  $Gamma tack.r tblue(lambda x: A. M x): tred(A -> B)$,
  rule(
    $Gamma, x: A tack.r M x: B$,
    rule(
      $Gamma, x: A tack.r tblue(M): A -> B$,
      $Gamma tack.r tblue(M): tred(A -> B)$,
    ),
    $Gamma, x: A tack.r x: A$,
    name: $=> E$,
  ),
  name: $=> I^x$,
)))

This *exhibits the actual structure* (i.e. *expands its internal term/proof structure*) of $M$ while preserving the type.

#tred[*Insight*]:
- Proof Reduction - Program Reduction
- Normalizing Proofs - Normalizing Programs

Compare both proofs

#todo[fill in the blanks]

#prooftree(rule(
  $tack.r tblue(lambda x: A and A. (lambda y: A. y) x.2): A and A -> A$,
))

== Disjunction

Let's now expand the previous example to disjunction.

=== Rules

#mathpar(
  rule(
    $tgreen(Gamma) tack.r tblue(iota_1 M): tred(A or B)$,
    $tgreen(Gamma) tack.r tblue(M): tred(A)$,
    name: $or I_1$,
  ),
  rule(
    $tgreen(Gamma) tack.r tblue(iota_2 M): tred(A or B)$,
    $tgreen(Gamma) tack.r tblue(M): tred(B)$,
    name: $or I_2$,
  ),
  rule(
    $tgreen(Gamma) tack.r tblue("cases" M "of" iota_1 x => N_1 | iota_2 x => N_2): tred(C)$,
    $tgreen(Gamma) tack.r tblue(M): tred(A or B)$,
    $#tgreen($Gamma, x: A$) tack.r tblue(N_1): tred(C)$,
    $#tgreen($Gamma, x: B$) tack.r tblue(N_2): tred(C)$,
    name: $or E$,
  ),
)

== Local Soundness

#todo[Fill in the blanks]
#prooftree(rule(
  $Gamma tack.r "case"$,
))

= Modal Logic S4

#quote(block: true, attribution: "Brigitte Pientka")[
  Truth is living in the moment - here and now.

  Validity is living forever and everywhere.
]

#quote[
  The world is full of possibilities, but not today.
]

== Necessity Modality $square A$

> Note what I originally wrote as $Gamma tack.r A$ is now $Gamma tack.r A "true"$ to make a clear distinction between *validity* and *true*.

=== Validity


- If $tred(epsilon) tack.r A "true"$ then $A "valid"$
- If $A "valid"$ then $tred(Gamma) tack.r A "true"$

Notice how the second rule allows weakening while the first rule does not. This means that *validity does not depend on any local assumptions*.

=== Judgment

$tpurple(Delta); tred(Gamma) tack.r A "true"$

- $tpurple(Delta)$ - the *global* context. It contains valid assumptions that holds *forever*.
- $tred(Gamma)$ - the *local* context. It contains assumptions that hold *here and now*.

So, the definition of validity can be written as:

#mathpar(
  rule(
    $Delta; Gamma tack.r A "true"$,
    $y: A "true" in Gamma$,
  ),
  rule(
    $Delta; Gamma tack.r A "true"$,
    $x: A "valid" in Delta$,
  ),
)

Now we start to introduce the modality $square$:

#mathpar(rule(
  $Delta; Gamma tack.r square A "true"$,
  $Delta; dot tack.r A "true"$,
  name: $square I$,
))

Just as $->$ is internalizing reasoning on implication, $square$ is internalizing reasoning on validity.

*T law* (_reflexivity_).

#mathpar(rule(
  $dot; dot tack.r square A -> A "true"$,
  $dot; x: square A tack.r A "true"$,
  name: $-> I^x$,
))

i.e. If it's true everywhere and forever, then it's also true here and now.

*A detour*

One may be tempted to define $square_E$ as such

#prooftree(rule(
  $Delta; Gamma tack.r A$,
  $Delta; Gamma tack.r square A$,
))

Let's see if it's locally complete as a sanity check.

#prooftree(rule(
  $Delta; Gamma tack.r square A "true"$,
))

should be able to expand to

#prooftree(rule(
  $Delta; Gamma tack.r square A "true"$,
  rule(
    $Delta; dot tack.r A "true"$,
    rule(
      $dots$,
      $Delta; Gamma tack.r square A "true"$,
    ),
    name: tred("???"),
  ),
  name: $square I$,
))

Boom!

*The correct solution*

A `let`-style definition!

#mathpar(
  rule(
    $Delta; Gamma tack.r C "true"$,
    $Delta; Gamma tack.r square A "true"$,
    $Delta, u: A "valid"; Gamma tack.r C "true"$,
    name: $square E$,
  ),
  rule(
    $Delta; Gamma tack.r square A "true"$,
    $Delta; dot tack.r A "true"$,
    name: $square I$,
  ),
)

Let's see if it's locally sound.

#prooftree(rule(
  $Delta; Gamma tack.r C "true"$,
  rule(
    $Delta; Gamma tack.r square A "true"$,
    tpurple($Delta; dot tack.r A "true"$),
    name: $square I$,
  ),
  tred($Delta, u: A "valid"; Gamma tack.r C "true"$),
  name: $square E^u$,
))

(#tpurple($Delta; dot tack.r A "true"$) goes to #tred($Delta, u: A "valid"; Gamma tack.r C "true"$) via _modal substitution_)

collapses to

$Delta; Gamma tack.r C "true"$

*Lemma*.
+ (_Substitution_) If $Delta; Gamma, x: A "true" tack.r C "true"$ and #tpurple($Delta; Gamma tack.r A "true"$), then $Delta; Gamma tack.r C "true"$.
+ (_Modal Substitution_) If $Delta, y: A "valid"; Gamma tack.r C "true"$ and #tpurple($Delta; tred(dot) tack.r A "true"$), then $Delta; Gamma tack.r C "true"$.

*Thm* (_T_). $square$ satisfies _reflexivity_.

#prooftree(rule(
  $$,
))

*Thm* (_Distributivity_). $square$ satisfies _distributivity_.
$
  square (A -> B) -> square A -> square B
$

*Thm* (_4_). $square$ satisfies _transitivity_.
$
  square A -> square square A
$

To introduce a $square$, one may attempt to use $square_I$, but this would leave us with an empty $Gamma$ which is not good. So, we need to first preserve $x$ forever, which leads us to the use of $square_E$ - saving it to $Delta$.

#note[We usually put something to eternality via $square_E$ rule. Note that we are gaining information via $square_E$ while we give up information via $square_I$.]

#prooftree(rule(
  $dot; dot tack.r square A -> square square A "true"$,
  rule(
    $dot; x: square A "true" tack.r square square A "true"$,
    $dot; x: square A "true" tack.r square A "true"$,
    rule(
      $u: A "valid"; x: square A "true" tack.r square square A "true"$,
      rule(
        $u: A "valid"; dot tack.r square A "true"$,
        rule(
          $u: A "valid"; dot tack.r A "true"$,
          name: $u$,
        ),
        name: $square I$,
      ),
      name: $square I$,
    ),
    name: $square E^u$,
  ),
  name: $-> I^x$,
))

== Syntax

$
  "Terms" M ::= x | lambda x: A. M | M " " N | ⟨M, N⟩ | M.1 | M.2 | tpurple(u) | "box" M |
$

#note[$tpurple(u)$ for valid assumptions.]

Now let's add proof terms to logic rules.

#mathpar(
  rule(
    $Delta; Gamma tack.r "box" M: tred(square A "true")$,
    $Delta; tpurple(dot) tack.r tpurple(M): tred(A "true")$,
    name: [$square I$ ($tpurple(M)$ is a closed term w.r.t. _local_ (_runtime_) assumptions)],
  ),
  rule(
    $Delta; Gamma tack.r "let box" u := M "in" N : tred(C "true")$,
    $Delta; Gamma tack.r M: tred(square A "true")$,
    $Delta, #tred($u: A "valid"$) ; Gamma tack.r N: tred(C "true")$,
    name: $square E$,
  ),
  rule(
    $Delta; Gamma tack.r x: tred(A "true")$,
    $x: tred(A "true") in Gamma$,
  ),
  rule(
    $Delta; Gamma tack.r u: tred(A "true")$,
    $u: tpurple(A "valid") in Delta$,
  ),
)

And now we have

+ (_Substitution_) If $Delta; Gamma, x: A "true" tack.r C "true"$ and #tpurple($Delta; Gamma tack.r A "true"$), then $Delta; Gamma tack.r C "true"$.
  e.g. $ ("box" N) [M "/" x] = "box" N $
+ (_Modal Substitution_) If $Delta, u: A "valid"; Gamma tack.r C "true"$ and #tpurple($Delta; tred(dot) tack.r A "true"$), then $Delta; Gamma tack.r C "true"$.
  e.g. $ ("box" N) bracket.double M "/" u bracket.double.r = "box" (N bracket.double M "/" u bracket.double.r) $

Now let's try to rephrase _locally soundness_

#prooftree(rule(
  $Delta; Gamma tack.r "let box" u := "box" M "in" N: C "true"$,
  rule(
    $Delta; Gamma tack.r "box" M: square A "true"$,
    $Delta; dot tack.r M: A "true"$,
    name: $square I$,
  ),
  $Delta, u: A "valid"; Gamma tack.r N: C "true"$,
  name: $square E^u$,
))

collapses to

$Delta; Gamma tack.r tpurple(N bracket.double M "/" u bracket.double.r): C$

== Real Programming Example

```haskell
nth: int -> (bool_vec -> bool)
```

This function does not do anything if you only pass it an integer. It just sits there, not producing anything meaningful.

How to avoid this situation and force it generate a real function?

```haskell
nth: int -> □(bool_vec -> bool)
nth 0 = box (fun v -> hd v)
nth (S n) =
  let box r = nth n in box (fun v -> r (tl v))
```

In this case, `box` makes sure the function generated does not depend on `int`.

Compare
```haskell
nth 1
= fun v -> tl (nth 0 v)
= fun v -> tl (hd v)
```

with

```haskell
nth 1
= let box r = nth 0 in box (fun v -> r (tl v))
= let box r = box (fun v -> hd v) in (fun v -> r (tl v))
= box (fun v -> (fun v0 -> hd v0) (tl v))
```

Notice how the returned function is not a closure over $n$.

However, if you compare these two functions you still find the latter one not satisfying cuz it's returning a redex and it's in a box so it get stuck.

*Contextual types* to the rescue!

== Contextual types

Previously, we wrote $square A$ to mean $A$ starts with an empty context, which is not sufficient in many cases. So instead, let's allow specifying a context $Gamma$ for $A$.

=== Examples

*Cooking metaphor*

+ Add eggs, flour, sugar
+ Add #box(stroke: 1pt, inset: (x: 10pt, y: 5pt)) (a liquid)

To type #box(stroke: 1pt, inset: (x: 10pt, y: 5pt)), it's $"eggs", "flour", "sugar" forces "liquid"$

*Theorem prover*

Holes in programs:

$"fun" x -> #box(stroke: 1pt, inset: (x: 10pt, y: 5pt)) +_"int" x$, you can see the hole here accepts an $x: "int" forces "int"$

Or $lambda x. lambda y. #box(stroke: 1pt, inset: (x: 10pt, y: 5pt)) y.2: (A -> B -> C) -> (A times B) -> C$, where the hole accepts an $x: A -> B -> C, y: A times B forces B -> C$

=== Syntax

$
                       "Types" quad A & ::= dots | square (tpurple(psi) forces A) \
                       "Terms" quad M & ::= dots | "box" (tpurple(psi) . M)       \
  "Contexts" quad Gamma, tpurple(psi) & ::= dots
$

E.g. $"box" (#tpurple($x: "int"$). x + x): square(#tpurple($x: "int"$) forces "int")$

#note[But how to keep this thing stable under renaming?]

#mathpar(
  rule(
    $Delta; Gamma tack.r "box" (tpurple(psi). M): tred(square(tpurple(psi) forces A) "true")$,
    $Delta; tpurple(psi) tack.r M: tred(A "true")$,
    name: [$square I$],
  ),
  rule(
    $Delta; Gamma tack.r "let box" u := M "in" N : tred(C "true")$,
    $Delta; Gamma tack.r M: tred(square(psi forces A) "true")$,
    $Delta, #tred($u: A "valid"$) ; Gamma tack.r N: tred(C "true")$,
    name: $square E$,
  ),
  rule(
    $Delta; Gamma tack.r x: tred(A "true")$,
    $x: tred(A "true") in Gamma$,
  ),
  rule(
    $Delta; Gamma tack.r "clo"(u, tgreen(sigma)) : tred(A "true")$,
    $u: tpurple(psi forces A) "valid" in Delta$,
    $Delta, Gamma tack.r tgreen(sigma): tpurple(psi)$,
  ),
)

*Notes*

- *$tgreen(sigma)$* - substitution from $psi$ to $Delta, Gamma$ i.e.
#prooftree(rule(
  $Delta; Gamma tack.r (sigma, M "/" x): psi, x:A$,
  $Delta; Gamma tack.r sigma: psi$,
  $Delta; Gamma tack.r M: A$,
))
- *$"clo"(u, sigma)$* - delayed substitution $sigma$ that can be applied once $u$ is available.

  #note[*Computation rules for `clo`*

    Recall how we have

    $ ("box" N) [M "/" x] = "box" N $
    $ ("box" N) bracket.double M "/" u bracket.double.r = "box" (N bracket.double M "/" u bracket.double.r) $

    Now also,

    $ "clo"(u, sigma) bracket.double psi. M "/" u bracket.double.r = tpurple(M[sigma]) $

    Beware that $M[sigma]$ is a *local* substitution.
  ]


E.g.
$
  lambda x. "let box" u := x "in" "box" (lambda y. lambda z. u " " y) :
  tred(square (C -> A) -> square (C -> D -> A))
$
$
  lambda x.
  "let box" u := x "in" "box"(#tgreen($y: C, z: D$). tpurple("clo"(u, y "/" x')))
  : tred(square (tpurple(x' : C) forces A) -> square (#tgreen($y : C, z: D$) forces A))
$

With this, we can revise our `nth` example

```haskell
nth: int -> □(bool_vec -> bool)
nth 0 = box (fun v -> hd v)
nth (S n) =
  let box r =
    nth n in box (fun v -> r (tl v))
```

into this

```haskell
nth: int -> □(v: bool_vec ⊨ int)
nth 0 = box (v: bool_vec. hd v)
nth (S n) =
  let box u = nth n in
    box (v: bool_vec. clo(u, (tl v)/v)
```

then we make

```haskell
nth 1
= let box r = nth 0 in box (fun v -> r (tl v))
= let box r = box (fun v -> hd v) in (fun v -> r (tl v))
= box (fun v -> (fun v0 -> hd v0) (tl v))
```

into this

```haskell
nth 1
= let box u = nth 0 in
    box (v: bool_vec. clo(u, (tl v)/v))
= let box u = box (v: bool_vec. hd v) in
    box (v: bool_vec. clo(u, (tl v)/v))
= box (v: bool_vec. clo(hd v0, (tl v)/v0))
= box (v: bool_vec. hd (tl v))
```

Notice how the nested evaluation is eager.


#todo[What's the difference between functions and `clo`?]
