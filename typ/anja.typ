#import "/prelude.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()

#codly(languages: codly-languages)

#let eqd = $attach(=, t: .)$

== Judgments

- *Well-formed Type (Type Formation)* $Gamma tack.r A "type"$
- *Judgmentally Equal Types* $Gamma tack.r A eqd B "type"$
- *Well-formed Term* $Gamma tack.r a: A$
- *Judgmentally Equal Terms* $Gamma tack.r a eqd b: A$

== Context (Telescope)

$#tred($x_1: A_1, dots, x_(k-1): A_(k-1)(x_1, dots, x_(k-2))$) tack.r A_k(x_1, dots, x_(k-1)) "type"$

== Dependent Stuff

- *type family (dependent types)* $Gamma, x: A tack.r B(x) "type"$
- *section (dependent terms)* $Gamma, x: A tack.r b(x): B(x)$

#note[Why is it called "section"? Category warning!]

#todo[]
#cetz.canvas({
  import cetz.draw: *
})

== Rules

- *Structural Rules*
  + Equivalence, as you expect
  + Variable Conversion
    #prooftree(rule(
      $Gamma, x: tred(A'), Delta tack.r tblue(cal(J)"[") B(x) tblue("]")$,
      $Gamma tack.r tblue(A) eqd tred(A') "type"$,
      $Gamma, x: tblue(A), Delta tack.r tblue(cal(J) "[") B(x) tblue("]")$,
    ))
    #note[the following rule (_element conversion_) is derivable, as we'll see later]
    #prooftree(rule(
      $Gamma tack.r a: A'$,
      $Gamma tack.r A eqd A' "type"$,
      $Gamma tack.r a : A$,
    ))
  + Substitution
    #prooftree(rule(
      $Gamma, tred(Delta[a"/"x]) tack.r tblue(cal(J))[a"/"x]$,
      $Gamma tack.r a: A$,
      $Gamma, #tred($x: A, Delta$) tack.r tblue(cal(J))$,
      name: msmcp("Subst"),
    ))

    This $tblue(cal(J))$ here stands for whatever judgment we are talking about. It could be _type formation, judgmental equal terms/types_, or _typing judgments_. In real life there will be 4 rules here.

    Also note how $tred(Delta)$ is getting substituted because it can depends on $x$.

    #note[Usually we want #smcp("Subst") to be an admissible rule. For today, we see it as an axiom.]
  + Weakening
    #prooftree(rule(
      $tblue(Gamma), x: A, Delta tack.r cal(J)$,
      $tblue(Gamma) tack.r A "type"$,
      $Gamma, Delta tack.r cal(J)$,
      name: $W$,
    ))
    Note how we are adding $x$ to $tblue(Gamma)$.
  + Contraction, which is derivable from how we defined substitution.

    #todo[I think defining substitution as an axiom is not a good idea, especially when it mixes substitution and structural properties up. My intuition is that structural properties are a direct consequence of how you define substitution, which in turn is the very core definition of the semantics of your type theory.]
  + Generic element (variable rule)
    #prooftree(rule(
      $Gamma, x: A tack.r x: A$,
      $Gamma tack.r A "type"$,
      name: $delta$,
    ))

== Derivation

A finite tree where
- *nodes*: inferences
- *root*: conclusion
- *leaves*: hypotheses

E.g.

*Thm* (_element conversion_):
#prooftree(rule(
  $Gamma tack.r a: A'$,
  $Gamma tack.r A eqd A' "type"$,
  $Gamma tack.r a : A$,
))

*Proof*.
#prooftree(rule(
  $Gamma tack.r a: A'$,
  $Gamma tack.r a: A$,
  rule(
    $Gamma, x: A tack.r x: A'$,
    rule($Gamma tack.r A' eqd A "type"$, $Gamma tack.r A eqd A' "type"$, name: $eqd msmcp("Sym")$),
    rule($Gamma, x: A' tack.r x: A'$, $Gamma tack.r A' "type"$, name: $x$),
    name: msmcp("VarConv"),
  ),
  name: msmcp("Subst"),
))
$square$

== Types

We define types by giving its formation ($F$), congruence ($eq$), introduction ($I$), elimination ($E$), and computation ($beta$/$eta$) rules.

=== Pi (Dependent function)

$Pi_(x: A) B(x)$

#align(center)[
  #mathpar(
    rule(
      $Gamma tack.r Pi_(x: A) B(x) "type"$,
      $Gamma, x: A tack.r B(x) "type"$,
      name: $Pi_F$,
    ),
    rule(
      $Gamma tack.r Pi_(x: A) B(x) eqd Pi_(x: A') B'(x) "type"$,
      $Gamma tack.r A eqd A'$,
      $Gamma, x: A tack.r B(x) eqd B'(x)$,
      name: $Pi_"eq"$,
    ),
    rule(
      $Gamma tack.r lambda tpurple(x. b(x)): Pi_(x:A) B(x)$,
      $Gamma, x:A tack.r b(x): B(x)$,
      name: $Pi_I$,
    ),
    rule(
      $Gamma, x: A tack.r f " " x: B(x)$,
      $Gamma tack.r f: Pi_(x: A) B(x)$,
      name: $Pi_E$,
    ),
    rule(
      $Gamma, x: A tack.r (lambda y. b(y)) " " x eqd b(x): B(x)$,
      $Gamma,x : A tack.r b(x): B(x)$,
      name: $Pi_beta$,
    ),
    rule(
      $Gamma tack.r lambda x. f " " x eqd f: Pi_(x: A)B(x)$,
      $Gamma tack.r f: Pi_(x: A) B(x)$,
      name: $Pi_eta$,
    ),
  )
]

#note[#tpurple($x. b(x)$) (binding) is a general structural construct, while $lambda$ applies to a binding and it is MLTT-specific. It allows a form of "local" substitution.]

#note[$Pi_eta$ is normally derivable from #msmcp("Extensionality").]

#prooftree(rule(
  $Gamma tack.r f eqd g : Pi_(x: a) B(x)$,
  $Gamma tack.r f: Pi_(x:A) B(x)$,
  $Gamma tack.r g: Pi_(x:A) B(x)$,
  $Gamma, x: A tack.r f(x) eqd g(x): B(x)$,
  name: msmcp("Extensionality"),
))

It's convenient to have $Pi_eta$ rule in terms of computation but normally when we study metatheory we want extensionality.

=== Non-dependent function

A special const case of $Pi$ where codomain does not have dependency on the domain.

#prooftree(rule(
  $Gamma tack.r A -> B := Pi_(x:A) B "type"$,
  rule(
    $Gamma tack.r Pi_(x: A) B "type"$,
    rule($Gamma,x : A tack.r B "type"$, $Gamma tack.r A "type"$, $Gamma tack.r B "type"$, name: msmcp("Weaken")),
    name: $Pi_F$,
  ),
  name: $scripts(->)_F$,
))

Notice how $B$ does not depend on $x$.

E.g.

#prooftree(rule(
  $Gamma tack.r lambda g. lambda f. lambda x. g " " (f " " x): (B -> C) -> (A -> B) -> (A -> C)$,
  rule(
    $Gamma, g: B -> C tack.r lambda f. lambda x. g " " (f " " x) : (A -> B) -> (A -> C)$,
    rule(
      $Gamma, g: B -> C, f: A -> B tack.r lambda x. g " " (f " " x): A -> C$,
      rule(
        $Gamma, g: B -> C, f: A -> B, x: A tack.r g " " (f " " x): C$,
        rule(
          $Gamma, g: B -> C, f: A -> B, x: A tack.r f " " x : B$,
          rule(
            $Gamma, f: A -> B, x: A tack.r f " " x : B$,
            rule(
              $Gamma, f: A -> B tack.r f: A -> B$,
              name: $x$,
            ),
            name: $Pi_E$,
          ),
          name: msmcp("Weaken"),
        ),
        rule(
          $Gamma, g: B -> C, f: A -> B, x: A, y: B tack.r g " " y: C$,
          rule(
            $Gamma, g: B -> C, y: B tack.r g " " y: C$,
            rule(
              $Gamma, g: B -> C tack.r g: B -> C$,
              name: $x$,
            ),
            name: $Pi_E$,
          ),
          name: msmcp("Weaken"),
        ),
        name: msmcp("Subst"),
      ),
      name: $Pi_I$,
    ),
    name: $Pi_I$,
  ),
  name: $Pi_I$,
))

=== $NN$ Natural Numbers

#mathpar(
  rule(
    $tack.r NN "type"$,
    name: $NN_F$,
  ),
  rule(
    $tack.r 0_NN: NN$,
    name: $NN_I_0$,
  ),
  rule(
    $tack.r S_NN: NN -> NN$,
    name: $NN_I_S$,
  ),
  rule(
    $Gamma tack.r "ind"_NN (p_0, p_"S"): Pi_(n:NN) P(n)$,
    $Gamma ,n: NN tack.r P(n) "type"$,
    $Gamma tack.r p_0: P(0_NN)$,
    $Gamma tack.r p_S: Pi_(n: NN)P(n) -> P(S_NN " " n)$,
    name: $NN_E$,
  ),
  rule(
    $Gamma tack.r "ind"_NN (p_0, p_S, 0_NN) eqd p_0: P(0_NN)$,
    $dots$,
    name: $NN_beta_0$,
  ),
  rule(
    $Gamma, n: NN tack.r "ind"_NN (p_0, p_S, S_NN " " n) eqd "ind"_NN (p_0, p_S, n): P(S_NN " " n)$,
    $dots$,
    name: $NN_beta_S$,
  ),
)

Example,

```haskell
addN: N -> N -> N
addN m 0 = m
addN m (S n) = S (addN m n)
```

#prooftree(rule(
  $m: NN tack.r "add"_NN " "m := "ind"_NN ("add"_NN 0 " " m, "add"_NN S " " m): NN -> NN$,
  $m: NN tack.r "add"_NN 0 := m : NN$,
  $m: NN, "add"_NN S: NN -> (NN -> NN) tack.r "add"_NN S := "TODO" : NN -> (NN -> NN)$,
))

#todo[]

=== $1$

#mathpar(
  rule(
    $Gamma tack.r 1 "type"$,
    name: $1_F$,
  ),
  rule(
    $Gamma tack.r star: 1$,
    name: $1_I$,
  ),
)

#note[No elimination rule]

=== $0$

#mathpar(
  rule(
    $Gamma tack.r 0 "type"$,
    name: $0_F$,
  ),
  rule(
    $Gamma tack.r "ind"_0: Pi_(x: 0) P(x)$,
    name: $0_E$,
  ),
)

or, the non-dependent version, $"ind'"_0 : 0 -> P$

#note[
  $not P := P -> 0$
]

=== Sigma (dependent sum/pair)

#mathpar(
  rule(
    $Gamma tack.r Sigma_(x: A)B(x) "type"$,
    $Gamma, x: A tack.r B(x) "type"$,
    name: $Sigma_F$,
  ),
  rule(
    $Gamma tack.r "pair"$,
  ),
)

#todo[]

=== Identity

#let deq = $scripts(=)$

#mathpar(
  rule(
    $Gamma tack.r a deq_A b "type"$,
    $Gamma tack.r a: A$,
    $Gamma tack.r b: A$,
    name: $deq_F$
  ),
  rule(
    $Gamma tack.r "refl"_a: a deq_A a$,
    $Gamma tack.r a : A$,
    name: $deq_I$
  ),
  rule(
    $Gamma tack.r J: Pi_(x: A)P(tred(x), tred(x), "refl"_x) -> Pi_(x:A)Pi_(y:A)Pi_(g: x deq_A y) P(tred(x), tred(y), g)$,
    $Gamma, x: A, y: A, p: x = y tack.r P(x, y, p) "type"$,
    name: $deq_E$
  ),
  rule(
    $Gamma tack.r J(d, a, a, "refl"_a) eqd d(a): P(a, a, "refl"_a)$,
    $Gamma, x: A, y: A, p: x deq_A y tack.r P(x, y, p) "type"$,
    $Gamma tack.r d: Pi_(x: A) P(x, x, "refl"_x)$,
    name: $deq_("compute")$
  )
)

So morally, $J$ rule is converting a proof on two _judgmentally equal_ things to two _definitionally equal_ things, by eliminating the `refl` constructor that smuggles a _judgmental equality_ inside a _definitional equality_.

#note[
  Notice that by its computation rule, $J$ is not computable if the proof is not `refl`.
]

Example.

*Thm* (Transitivity). #todo[]

#todo[Talk about how PAs hide J rule away from users, and show two different representations (J rule vs pm)]

*Thm* (Symmetry).

*Thm* (_Ap_). If $a deq_A b$ and $f: A -> B$, then $f(a)deq_B f(b)$.

*Thm* (_Transport_). If $a deq_A b$ and $B(a)$, then $B(b)$.

== C.H.

#todo[]

- Prop - Type
- Proof - Element
- $top$ - $1$
- $bot$ - $0$
- $P or Q$ - $A + B$
- $P and Q$ - $A * B$
- $P => Q$ - $A -> B$
- $not P$ - $A -> 0$
- $exists_x P(x)$ - $Sigma_(x: A) P(x)$
- $forall_x P(x)$ - $Pi_(x: A) P(x)$
- $P = Q$ - $P = Q$