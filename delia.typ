#import "prelude.typ": *

Slides: #link("https://www.irif.fr/~kesner/enseignement/mpri/ll/Proof-Nets.pdf")

// == Multiplicative Exponential Linear Logic

// - *Why not* $?$
// - *Of course (bang)* $!$

== Why Linear Logic?

- *Purpose*: control duplication and erasure
- *Insights*: proof-nets, cbn vs cbv as logic, implicit complexity & cost models
- *Revisit*: evaluation & typing, new calculus

== MLL (two-sided) sequent

#mathpar(
  rule(
    $A tack.r A$,
    name: msmcp("Ax")
  ),
  rule(
    $Gamma, Gamma' tack.r Delta, Delta'$,
    $Gamma tack.r A, Delta$,
    $A, Gamma' tack.r Delta'$,
    name: msmcp("Cut")
  )
)

== MLL (unilateral) sequent

If we want to move lhs of $tack.r$ to rhs, we negate formulas on lhs and move them to rhs. In this process, there would be no need to have separate left and right rules.

#mathpar(
  rule(
    $tack.r A^bot, A$,
    name: msmcp("Ax")
  ),
  todo[Cut]
)

== Proof-Nets

*Problem*: From the same premise, there might be *multiple proofs (derivations)* to the same conclusion. Any possible derivation captures a particular constructor *history*.

*Solution*: *MLL Proof-Net (PN)* with conclusions $overline(A)$, a graph defined by induction as:

#todo[]

How to read these graphs:
+ White squares are whatever that expose the interface shown below it.
+ Disjoint white squares are independent (parallel) proof-nets.

Terminology

*Interface*: leaf formulas.

+ If you just keep to the interface, you get the current proof status.
+ Interfaces can be connected and they are no longer interfaces while a new node would become an interface.
+ All proofs of the same formula can be represented as a single proof-net. The very reason is that PNs can _parallelize_ different parts of the proof. (#todo[so only for reasoning systems that have _subformula property_?])

=== Pre Proof-Nets

Pre proof-nets are a weaker version of proof-nets that ignores all independence requirements.

E.g.

```
 ax
_|_
A A⊥
---
 |
 cut
```
is a pre proof-net but it's not a proof-net because two inputs of the cut rule are not independent.

=== Correctness Criteria

But what makes a pre proof-net a proof-net?

*Acyclic Connected Criteria*

$P^-$ is a Pre PN, but mark angles with dependent precedences with a red arc.

*Contractibility*

+ Merge two edges with a red arc if the precedence is a single common node.
+ Merge an edge with its two connected nodes into one node if the edge is the only edge connected to these two nodes.

*Theorem*: A pre proof-net is a proof-net iff its $P^-$ is contractible (reduces to a single node).

== MELL

MLL + weakening and contraction.

If one want to weaken/contract a variable, one must mark it explicitly with a $!$.
To allow a variable to be weakened, one can introduce a $!$.

#note[*Duality* a $!$ in the left is a $?$ in the right.]

*Promotion* rules are interesting, while when applying promotion, one allows a formula to 

Introduce weakening and dereliction constructs.

Note that a graph with bare weakening is a pre PN but it's not a PN because you need something to weaken first.

#note[
  There's a typo on a MLTT reduction example where two derivations don't have the same conclusion, but the PN is correct.
]