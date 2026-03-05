# Architecture Overview

This document explains the internal architecture of the parser
and how expressions move through the two main stages:

1. Tokenization
2. Parsing and evaluation

The design is intentionally linear and deterministic: input text is first converted to tokens, then tokens are parsed according to CFG rules and evaluated into a final numeric result.

---

## High-Level Flow

```text
Input expression (String)
        |
        v
Tokenizer -> Vec<Token>
        |
        v
MathExpressionParser -> f64 result or structured error
```

Main modules in `src/main.rs`:

- `Tokenizer`: lexical analysis over raw text.
- `MathExpressionParser`: recursive-descent parser with precedence-aware evaluation.
- Error model: `TokenError`, `MathError`, and unified `CalcError`.

---

## Phase 1: Tokenizer

The tokenizer reads the input expression character by character and converts it into a sequence of typed tokens.

### Responsibilities

- Skip whitespace.
- Parse numeric literals (`f64`, including decimals).
- Recognize operators and symbols (`+`, `-`, `*`, `/`, `^`, `$`, `(`, `)`, `=`).
- Reject invalid symbols with explicit errors.

### Output

- `Ok(Vec<Token>)` if tokenization succeeds.
- `Err(TokenError)` if the input is malformed.

### Typical Tokenizer Errors

- `InvalidNumber`
- `InvalidOperator`
- `UnexpectedEnd` (when context requires more input)

### Visual Reference

![Tokenizer phase](../example/tokenizer.png)

---

## Phase 2: Parser + Evaluator

The parser consumes `Vec<Token>` and applies CFG production rules using a recursive-descent approach.
Evaluation is performed during parsing.  
The current design does not build an intermediate AST; grammar rules directly compute results.

### Responsibilities

- Enforce grammar structure and operator precedence.
- Evaluate expressions while traversing grammar rules.
- Support implicit multiplication (e.g. `2(3+4)`, `(1+2)(4-1)`).
- Validate semantic/math constraints (division by zero, invalid roots, overflow/underflow).

### Grammar Layers (Operator Precedence)

- `F`: full formula (must terminate with `=`)
- `E`: addition/subtraction
- `P`: multiplication/division/implicit multiplication
- `U`: exponentiation/root (right-associative)
- `B`: base value (number, unary minus, parenthesized expression)

### Output

- `Ok(f64)` if parsing and evaluation succeed.
- `Err(CalcError)` if parsing or math evaluation fails.

### Visual Reference

![Parser phase](../example/parser.png)

---

## Error Architecture

The project separates concerns between lexical, parsing, and mathematical errors.

- `TokenError` — generated during tokenization when invalid characters, malformed numbers, or unexpected input are encountered.
- `MathError` — generated during evaluation for semantic or numeric issues (e.g. division by zero, invalid roots, overflow).
- `CalcError` — unified error type returned by the public API, encapsulating both tokenization and evaluation failures.

This structure keeps failure modes explicit and improves diagnostics during both development and CLI usage.

---

## Why Two Phases

Separating tokenization from parsing provides several advantages:

- Better maintainability: lexical and grammar logic are isolated.
- Easier debugging: token stream can be inspected independently.
- Extensibility: new operators or token forms can be added with minimal coupling.
- Predictable control flow: deterministic pass from text to tokens to result.

---

## Extension Points

If you want to evolve the parser, the most natural extension points are:

- Add new token kinds in `Token` and `Tokenizer::from_char`/`tokenize`.
- Extend grammar functions (`evaluate_e`, `evaluate_p`, `evaluate_u`, `evaluate_b`).
- Add new `MathError` and `TokenError` variants for clearer diagnostics.
- Add tests for both tokenization and grammar-level behavior before changing semantics.

