# CFG Parser Grammar Specification (CFG)

This document defines the context-free grammar (CFG) used by cfg-parser
to parse and evaluate arithmetic expressions.

It serves as a production-oriented reference for contributors
analyzing syntax, operator precedence, and parser semantics.

---

## 1. Scope

Supported language features:
- Signed decimal numbers (through unary minus)
- Binary operators: `+`, `-`, `*`, `/`
- Exponentiation: `^`
- N-th root operator: `$` (example: `27$3`)
- Parenthesized and nested sub-expressions
- Implicit multiplication (examples: `2(3+4)`, `(1+2)(3+4)`)
- End-of-input delimiter: `=`

---

## 2. Grammar Notation

| Symbol type | Meaning |
| --- | --- |
| `F`, `E`, `P`, `U`, `B` | Non-terminals |
| Quoted token (for example `"+"`) | Terminal |
| `ε` | Empty production |
| `->` | Production definition |

---

## 3. Formal Grammar

```text
F  -> E "="

E  -> P E'
E' -> "+" P E'
    | "-" P E'
    | ε

P  -> U P'
P' -> "*" U P'
    | "/" U P'
    | ImplicitMult U P'
    | ε

U  -> B U'
U' -> "^" U
    | "$" U
    | ε

B  -> "-" B
    | unsigned_number
    | "(" E ")"
```

`ImplicitMult` is not a lexical token; it is a parser-level
transition triggered by constrained token adjacency
within the product context.

---

## 4. Non-Terminal Semantics

| Non-terminal | Purpose | Notes |
| --- | --- | --- |
| `F` (Formula) | Full input expression | Must terminate with `=` |
| `E` (Expression) | Addition and subtraction layer | Lowest arithmetic precedence |
| `P` (Product) | Multiplication, division, implicit multiplication | Mid precedence |
| `U` (Unit) | Exponentiation and root | Right-associative |
| `B` (Base) | Atomic operand | Number, unary negation, or parenthesized expression |

---

## 5. Implicit Multiplication

`ImplicitMult` is accepted only in `P'` and only for the following token transitions:

| Previous token | Next token | Interpreted as |
| --- | --- | --- |
| `)` | `(` | `) * (` |
| `number` | `(` | `number * (` |
| `)` | `number` | `) * number` |

Examples:
- `2(3+1)` -> `2 * (3+1)`
- `(1+2)(3+4)` -> `(1+2) * (3+4)`
- `(1+2)3` -> `(1+2) * 3`

---

## 6. Precedence and Associativity

| Level (high -> low) | Operators / form | Associativity |
| --- | --- | --- |
| 1 | Unary minus (`-B`) | Right-associative (via recursive production) |
| 2 | `^`, `$` | Right-associative |
| 3 | `*`, `/`, implicit multiplication | Left-to-right evaluation |
| 4 | `+`, `-` | Left-to-right evaluation |

Parser note:
- `U' -> "^" U` and `U' -> "$" U` enforce right-associative chaining.
- `E'` and `P'` are evaluated with an accumulator loop, producing left-to-right behavior for additive and multiplicative operators.

---

## 7. Semantic Rules

### 7.1 Formula termination

Every valid full expression must match:

`F = E "="`

The token `=` is a delimiter, not an arithmetic operator.

### 7.2 Root operator semantics

Definition:

`a$b ≡ a^(1/b)`

Examples:
- `27$3 = 3`
- `16$2 = 4`

Validation constraints:
- `b = 0` is invalid (division by zero in exponent `1/b`)
- Even root of a negative base is invalid over real numbers
- Negative base with non-integer root index is invalid over real numbers

---

## 8. Parser Method Mapping

| Grammar rule | Parser method |
| --- | --- |
| `F` | `evaluate` |
| `E` | `evaluate_e` |
| `E'` | `evaluate_e_prime` |
| `P` | `evaluate_p` |
| `P'` | `evaluate_p_prime` |
| `U` | `evaluate_u` |
| `U'` | `evaluate_u_prime` |
| `B` | `evaluate_b` |

Pipeline split:
1. Tokenization: converts input text into `Token` stream
2. Parsing and evaluation: recursive-descent traversal with integrated semantic checks

---

## 9. Valid Examples

| Input expression | Normalized interpretation | Expected result |
| --- | --- | --- |
| `2 + 3 * 4 =` | `2 + (3 * 4)` | `14` |
| `-5.3 + 2 =` | `(-5.3) + 2` | `-3.3` |
| `2(3 + 1) =` | `2 * (3 + 1)` | `8` |
| `(1 + 2)(3 + 4) =` | `(1 + 2) * (3 + 4)` | `21` |
| `(.12)(1*9/2.3) =` | `0.12 * (9 / 2.3)` | approximately `0.469565` |
| `2^3 =` | `2^3` | `8` |
| `27$3 =` | `cube_root(27)` | `3` |
| `4^2 $ 2 =` | `(4^2)^(1/2)` | `4` |
| `((8 - 9.81 * 3.14) - .12(1*9/2.3) + -5.17) =` | mixed operators + implicit multiplication | valid expression |

---

## 10. Invalid Examples

| Input expression | Failure reason | Error class |
| --- | --- | --- |
| `2 + =` | Missing right operand after `+` | Invalid expression |
| `2 * (3 + 4` | Missing closing `)` | Unmatched parenthesis |
| `5 5 =` | Ambiguous consecutive numbers | Invalid expression |
| `2 ^ =` | Missing exponent | Unexpected end / invalid expression |
| `27 $ =` | Missing root index | Unexpected end / invalid expression |

---

## 11. Error Categories

| Category | Typical cases |
| --- | --- |
| Token/syntax errors | invalid number, unexpected end, unexpected token, invalid operator, unmatched parenthesis |
| Semantic/math errors | division by zero, overflow/underflow, invalid exponentiation, invalid root, even root of negative number |

---

## 12. Design Rationale

### Recursive Descent Approach

The parser is implemented using a hand-written recursive descent strategy.

This choice was preferred over parser generators in order to:
- Maintain full control over operator precedence and associativity
- Integrate semantic validation directly during parsing
- Support implicit multiplication without grammar ambiguity
- Keep the evaluation logic tightly coupled with syntax traversal

The grammar is intentionally structured in precedence layers (`E -> P -> U -> B`) to reflect arithmetic hierarchy explicitly.

---

### Precedence Encoding

Operator precedence is encoded structurally in the grammar:
- `E` handles additive operators
- `P` handles multiplicative operators
- `U` handles exponentiation and root
- `B` represents atomic operands

This avoids the need for explicit precedence tables and makes evaluation deterministic.

---

### Right-Associative Exponentiation

Exponentiation and root operators are implemented as right-associative through the recursive productions:

```text
U' -> "^" U
U' -> "$" U
```

This ensures correct evaluation of chained expressions such as:

`2^3^2 -> 2^(3^2)`

---

### Implicit Multiplication Strategy

Implicit multiplication is not treated as a lexical token. Instead, it is resolved at parsing time under constrained token adjacency conditions within the product layer (`P'`).

This design prevents ambiguity while preserving intuitive mathematical notation, such as:
- `2(3+4)`
- `(1+2)(3+4)`
