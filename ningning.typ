#import "prelude.typ": *

#show: codly-init.with()
#codly(languages: codly-languages)

= Effects

IO, exceptions, states, concurrency, backtracking, etc.

*Problem*: ad-hoc implementation, unsound combinations

What are effect handlers?
A *composable* and *structured* control-flow abstraction.

_But why not monads?_
Monads are more expressive but algebraic effects are more composable.

= Definition

An *algebraic effect* is:
- operations (effect constructors) with _signatures_
- _axioms_

E.g. _one boolean location_

*Signature*: `put_t: 1, put_f: 1, get: 2`
- $"put"_b (m)$: put $b$ ($t$/$f$) then continue with $m$
- $"get" (m, n)$: get the value then continue with $m$ if true, $n$ if false
*Axioms*:
- `get(m, m) = m`
- `get(get(m, m'), get(n, n')) = get(m, n')` (load elim)
- `put_b(put_b'(m)) = put_b'(m)` (store elim)
- `get(put_t(m), put_f(n)) = get(m, n)` (load store elim)
- `put_b(get(m_t, m_f)) = put_b(m_b)` (store load elim)

#note[
  When one tries to implement an algebraic effect, one usually comes up with axioms, then tries to implement the effect in a way that respects the axioms, instead of the other way around.
]

*Interpretation (semantics)*

$
  T_b(X) = B -> (X times B)\
  bracket.double c bracket.double.r &= lambda s. (c, s)\
  bracket.double "get"(m, n) bracket.double.r &= lambda s. "if" s "then" bracket.double m bracket.double.r s "else" bracket.double n bracket.double.r s\
  bracket.double "put"_b(m) bracket.double.r &= lambda tgray(s). bracket.double m bracket.double.r b\
$

*Theorem*: the interpretation is _sound_ and _complete_ with respect to the _axioms_.
$ m = n <=> bracket.double m bracket.double.r = bracket.double n bracket.double.r $
*Proof*:
  - $=>$: by direct case analysis on axioms and expanding the interpretation.
  - $arrow.double.l$: by induction on the structure of axioms.

#note[
  P.S. It can be proven that the `get-get` equation is redundant.
]

*Interpretation B*

This time, we keep track of all history states.

$
  T_log (X) = B -> (X times tpurple("list") B)\
  bracket.double c bracket.double.r &= lambda s. (c, tpurple([s]))\
  bracket.double "get"(m, n) bracket.double.r &= lambda s. "if" s "then" bracket.double m bracket.double.r s "else" bracket.double n bracket.double.r s\
  bracket.double "put"_b(m) bracket.double.r &= lambda tgray(s'). "let" (n, tpurple(s)) <- bracket.double m bracket.double.r "in" (n, tpurple(b :: s))\
$

*Theorem*: the interpretation is _complete_ with respect to the _axioms_.
$ m = n arrow.double.l bracket.double m bracket.double.r = bracket.double n bracket.double.r $
*Proof*: same as before.

*Theorem*: the interpretation is *unsound* with respect to the _axioms_.
$ m = n arrow.double.not bracket.double m bracket.double.r = bracket.double n bracket.double.r $
*Proof*: consider $"put"_b ("put"_b' (m)) != "put"_b' (m)$.

*Interpretation C*

Let's throw away the state completely. One can see it's _sound_, of course, but it's _incomplete_ because it equates all programs as if there's no state so it recognizes much more programs than the axioms allow.

e.g. exception

*Signature* `raise_e: 0 (e ∈ E)`

*Axioms* None

*Interpretation* `T_e(X) = X + e`. Return is `inl` and `raise` is `inr`.

e.g. non-determinism

#note[$dots$ skiped for brevity]

_But how to tell if a set of axioms is good enough?_

- *equationally inconsistent*: $forall x, y, x = y$. Explosion! This is what we want to avoid: #tred[unsound].
- *Hilbert-Post complete*: adding any _unprovable_ equation makes it _equationally inconsistent_. This means our set of axioms is very #tblue[complete].

= How are algebraic effects _algebraic_?

#strike[#todo[Insert fancy commute diagram here #footnote[Plotkin, Gordon, and John Power. 2001. ‘Semantics for Algebraic Operations’. Electronic Notes in Theoretical Computer Science 45: 332–45. [#link("https://homepages.inf.ed.ac.uk/gdp/publications/sem_alg_ops.pdf")[PDF]]]]]

Instead of a categorical definition, in a program sense, _algebraic_ means:

#tgray[Assume the notion of _evaluation context_ (the $square | E " " n | (lambda x.m) E$ thing)],\
for any `op: n`, $E["op"(m_1, dots, m_n)] = "op"(E[m_1], dots, E[m_n])$

#note[i.e. $E$ and $"op"$ commute]

= Computational Trees

Effectful programs can be represented as _computational trees_, trees whose _leaves_ are _values_ and _internal nodes_ are _operations_.

#todo[put the second example figure here]

i.e. `get(or(raise, t), put_t(f))`

#note[_Interaction tree_ is a coinductive version of computational tree.]

== As free monads

```haskell
data Free f a = Pure a | Free (f (Free f a))
```

- `Pure a` (_triangle_) - pure value
- `Free (f (Free f a))` (_rect_) - an `op` that produces another `Free f a` computation

```haskell
return c >>= r = r c
op(m1, ..., mn) >>= r = op(m1 >>= r, ..., mn >>= r)
```

#note[
  One can see that the binding operation behaves (not by coincidence) super similar to the very definition of _algebraic_ effects.
]

= Parametrized

== Parametrized Operations

*Motivation*: Consider if we want to generalize the single location boolean effect to location indexed by countable _loc_ and also we want to store nat instead. It's infeasible to define infinite operations and axioms.

_e.g._

```haskell
update: loc x nat ~> 1
lookup: loc ~> nat
```

== Parametrized Arguments

*Problem* previously, we have `get(m, n)` where `m` is for `true` and `n` is for `false`. However, now we are trying to store a nat, which means we essentially need to provide infinite branches!

*Solution*: we can use _parametrized arguments_.

e.g.
```haskell
lookup(l, λx. nat. m)
```

Q: _how are we going to define algebraic in this case?_

$E[op (tpurple(p), lambda x: n. m)] = op (tpurple(p), lambda x: n. E[m])$

#note[
  E is not squashed into #tpurple[p] in this case. #todo[why?]
]

_e.g._
$"lookup"(l, lambda x. m) n = "lookup"(l, lambda x. m n)$

= Generic Effects

*Motivation* #todo[]

#mathpar(
  rule(
    $"gen_update" m: 1$,
    $m: "loc" times "nat"$
  ),
  rule(
    $"gen_lookup" n: "nat"$,
    $n: "loc"$
  )
)

` lookup(l, λ x: nat. m) ` vs ` gen_lookup(l): nat `

#note[
  Intuitively, they are just a let binding away.
  + `gen_update(l, 42) ≡ update(l, 42), λx. x)`
  + `update((l, 42). λx. m) ≡ let x = gen_update((l, 42)) in m`
]

= Example Calculus

== Syntax

Imagine _STLC_ with bools and `if` statements, formated in a contextual semantics way (eval ctx), #tpurple[but with `op e` in terms]. 

#note[`op` is not a value.]

We'll extend it with handlers in the next subsection.

_e.g._

```haskell
choose: () ~> bool
fail: () ~> a

drunkToss () =
  if choose () then
    if choose () then Heads else Tails
  else fail ()
```

= Effect Handler

== Syntax

```haskell
  handle { op ↦ λx k. e₁, return ↦ λx. e₂ } e
```

- `x` is the operation argument
- `k` is the _delimited continuation_
- `return` is for when the omputation returns a pure value

Handlers are _terms_, but not _values_.

_E.g._

```haskell
maybeFail = {
  fail ↦ λx k. Nothing,   -- if fail, return Nothing. We are changing the type of the computation to Maybe a
  return ↦ λx. Just x     -- if return, return Just x
}

trueChoice = {
  choose ↦ λx k. k true,  -- we resume the computation with `true`
  return ↦ λx. x           -- we just return the value.
}

allChoices = {
  choose ↦ λx k. k true ++ k false,  -- we resume the computation twice with either `true` or `false`
  return ↦ λx. [x]  -- we return a list of values. Note how we changed the type of the computation to List a
}
```

#todo[maybe it would be better to directly give the non-det choose example so we can explain k and type change at the same time]

== Delimited Continuation

Assume one understands what's a continuation,

a _delimited continuation_ is a continuation that captures the control flow up to *a certain point*, i.e. it *does not capture the whole program* but only the part that is relevant to the current effect.

In the setting of effect handlers, this delimited continuation captures from where the operation is called to where the handler is in the eval ctx.

_E.g._
```haskell
handle h E [op v]     -- where op is fresh in E
```
- `x`: `v`
- `k`: `λx. handle h E[x]`

This continuation delimits to the handler's scope. It does not handle any operation outside of the handler term.

== Handler composition

When we need to compose two handlers, the behavior can be different depending on the order of composition.

```haskell
handle allChoices (handle maybeFail (drunkToss ()))
  -> [Just Heads, Just Tails, Nothing]
```
, but
```haskell
handle maybeFail (handle allChoices (drunkToss ()))
  -> Nothing
```

One can make sense of this by looking into the return type of the handlers:
- *maybeFail* changes the return type from `a` to `Maybe a`
- *allChoices* changes the return type from `a` to `List a`
So,
- *allChoices ∘ maybeFail* changes the return type from `a` to `List (Maybe a)`
- *maybeFail ∘ allChoices* changes the return type from `a` to `Maybe (List a)`

== Dynamics

$
  "handle" h " " v -> f " " v quad "where" tblue("return") |-> f in h \
  "handle" h " " E[#tpurple($op$) v] -> f " " v (lambda x. "handle" h E[x]) quad "where" #tpurple($op$) |-> f in h, tred(op \# E)
$

#note[
  $tred(op \# E)$ means nothing inside $E$ is capturing $op$.
]

_E.g._ cooperative threads

=== Alternatives

*Shallow*
$
  "handle" h " " E[#tpurple($op$) v] -> f " " v (lambda x. tred(E[x])) quad "where" #tpurple($op$) |-> f in h, op \# E
$

#note[
  handler is not re-installed
]

_e.g._ Unix pipeline

```haskell
pipe(p, c) = handle { await ↦ λx k. copipe(k, p) } (c ())
copipe(k, p) = handle { yield ↦ λx k. pipe (k, λ_. c x) } (p ())
```

In this case, we are using shallow handlers to alternate between two handlers.

*Sheep*
$
  "handle" h " " E[#tpurple($op$) v] -> f " " v " " (lambda tred(h'). lambda x. tred("handler" h' " " E[x])) quad "where" #tpurple($op$) |-> f in h, op \# E
$

#note[
  _Users_ can choose to install a new handler `h'`. Of course, one can always choose to install the same handler `h` again, or install nothing at all.

  It's what's implemented in _WASM_ lol.
]

*Parametrized*
$
  "handle" h " " s " " E[#tpurple($op$) v] -> f " " v (lambda tred(s'). lambda x. "handler" h " " tred(s') " " E[x]) quad "where" #tpurple($op$) |-> f in h, op \# E
$

#note[
  It has the same expressiveness as deep handlers.
]

*Masking*
By `lift[op] e` one could specify to skip one handler when handling `op` in `e`.

*Named*
A name is attached to both the handler and the operation, so one can specify which handler to use for a particular operation term.