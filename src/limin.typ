#import "/prelude.typ": *

= Security

== Definition

System security is often defined via:
- *Security Properties*: what the system should guarantee (e.g., confidentiality, integrity, availability).
- *Attack Models*: what the system should protect against (e.g., unauthorized access, data breaches).

== Security + Formal PL Methods

*General PL* problems are *pure* and what is optimal is often clear and well-defined.

 *Security* in industry is *constrained* by budget and performance considerations. A best solution *might not be feasible* in practice.

Formal PL techniques can be used to *formalize* _security properties_ and _attack models_.

== Questions to consider when evaluating system security

- Model the *Target System*
- Model *Adversaries*
- Specify *Security Guarantees*
- Analyze effectiveness of *Approaches*

== Techniques

- Model
- Reasoning

= Information Flow

= History

- Multi-level Security: split data into different levels of sensitivity, e.g., Top Secret, Secret, Confidential, Unclassified.
  - *BLP Model (Confidentiality only) - No Write Down*: a subject at a higher security level cannot write to an object at a lower security level, #tred[but a subject at a lower security level can write an object at a higher security level, compromising data integrity].
  - *Biba Model (Integrity only) - No Write Up*: a subject at a lower trust level cannot write an object at a higher trust level.
  - *Lattice Model*: formalized policies
    $(N, P, S C, plus.circle, ->)$
    + $N$: objects
    + $P$: subjects
    + *BLP*:
      - $S C = {"secret", "open"}$
      - $-> = {"open" -> "secret"}$
      - equations: $"open" plus.circle "secret" = "secret"$
    + *Biba*:
      - $S C = {"trusted", "untrusted"}$
      - $-> = {"trusted" -> "untrusted"}$
      - equations: $"trusted" plus.circle "untrusted" = "untrusted"$
- *Modern Lattice Model*:
  - $L$: set of security labels
  - $subset.eq$: a partial order on $L$ specifying allowed information flow
  - #todo[Expand ?]

= From Local to Global

- *Local* properties:
  - *BLP*: low users can't write high files; secrets can't be written to unclassified files
  - *Biba*: low integrity users can't write high integrity files; low integrity files can't be read by high integrity users
- *Global* property: *Non-interference*
  + _Secrets_ can't *interfere* with the *observation* of users who are not allowed to see them.
  + _Untrusted data_ can't *interfere* with the *operations* (*observation*) of trusted data.

In other words, for a system to be secure in the information flow sense, it must ensure that *secret input* does not flow to *public output*.

#todo[what does this mean?]

= Non-interference

Let $P(tgreen(I_"pub"), tred(I_"priv")) = tgreen(O_"pub"), tred(O_"priv")$.\
For any two executions of $P$ with the #tgreen[*same public input $I_"pub"$*], the #tgreen[*public output $O_"pub"$*] must be the *same*, *regardless of* the #tred[private input $I_"priv"$].

#note[I revised the original expression.]

== Examples

=== Password Manager

Components:
- `report`: crash report
- `pwd`: user passwords
- `send`: crash report sending (Network API) function

*Bad Example*:

From the most naive one:

```C
send pwd;
```

... to a complex one:

```C
output := "";
for (i = 0; i < pwd.length; i++) {
  c = pwd[i];
  switch (c) {
    case 'a': output += "a"; break;
    case 'b': output += "b"; break;
    case 'c': output += "c"; break;
    // ...
  }
}
send output;
```

*Information-flow Witness*:
- `pwd` is a secret input, and `output` is a public output.
- Notice how `output` depends on `c` which in term depends on `pwd` on _Line 4-9_.

=== Strava heatmap around a military base

Strava leaked aggregated data about users' activities, which allowed adversaries to infer sensitive information about military personnel's movements.

*Intuition*: normally aggregation is a good privacy preserving technique, but in this case the aggregation leaks sensitive location information preserved through aggregation.

=== Eager Password Manager

```C
c := input();
while (c != null) {
  if (c == password[i])
    c = input(); i++;
  else
    return fail;
}
return success;
```

#todo[I failed to keep up with how this example is bad in terms of information flow 😭]

=== Side-channel attacks

- Timing

```C
F(x) {
  if (secret == 0 || x == 0)
    skip
  else
    complex_operation;
}
```

- Cache timing (meltdown attack):
  + `secret` is sensitive data
  + Program `P` tries to access a probe array `array[secret * PAGE_SIZE]`, which gets the page containing `secret` into the cache.
  + Attacker scans the probe array after `P` runs to find the index with the shortest access time, which reveals the value of `secret` because its page is still in the cache line.

=== Permission-based access control

Global variables are accessible to every extension in Firefox.
- `FlashGot` reads global variable `files` and has *write permission*.
- `Greasemonkey` reads global variable `$exe` and has *execute permission*.
- #tred[`Attacker`] writes to `files` and `$exe`. While it *does not have any permission*, it can still *download and execute code*.

*Intuition*:
+ Global state is bad
+ Permission control is too local to enforce global security properties.

*Lessons taken*: Information flow sense, permission should be _transitive_.

== Information Flow Security

- *Confidentiality*: guard against data leaking to attackers
- *Integrity*: guard against data from attackers flowing to core components

= Nondeterministic systems

== Noninterference?

Let $P(tgreen(I^"pub"), tred(I^"priv")) = Sigma_i (tgreen(O^"pub"_i), tred(O^"priv"_i))$.\
For any two executions of $P$ with the #tgreen[*same public input $I_"pub"$*], the *#tgreen[public output set] of the first execution $O^"pub"_1$* must be a *subset* of *#tgreen[public output set] of the second execution $O^"pub"_2$*, *regardless of* the #tred[private input $I_"priv"$].

#note[I revised the original expression.]

== Problem

#todo[]

= Enforcement measures

+ Type system: $"int" tred(S), "int" tgreen(P)$. Whenever the type rejects the program, it means that the program *might* violate the security property. Note that this is an over-approximation.
+ Runtime monitors: monitor terminates the program in runtime if it violates the security property.