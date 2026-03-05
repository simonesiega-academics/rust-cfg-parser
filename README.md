<h1 align="center">
  <img src="docs/assets/cfg-parser-logo.svg" alt="CFG Parser logo" width="220" height="220" />
  <br />
  CFG Parser
</h1>

<p align="center">
A Rust CLI tool that parses and evaluates arithmetic expressions
using a Context-Free Grammar (CFG) engine.
</p>

<p align="center">
  <a href="https://github.com/simonesiega-academics/rust-cfg-parser/stargazers"><img src="https://img.shields.io/github/stars/simonesiega-academics/rust-cfg-parser?style=social" alt="GitHub stars" /></a>
  <a href="https://github.com/simonesiega-academics/rust-cfg-parser/issues"><img src="https://img.shields.io/github/issues/simonesiega-academics/rust-cfg-parser" alt="Open issues" /></a>
  <a href="https://github.com/simonesiega-academics/rust-cfg-parser/pulls"><img src="https://img.shields.io/github/issues-pr/simonesiega-academics/rust-cfg-parser" alt="Open pull requests" /></a>
  <a href="https://github.com/simonesiega-academics/rust-cfg-parser/commits/master"><img src="https://img.shields.io/github/last-commit/simonesiega-academics/rust-cfg-parser" alt="Last commit" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/simonesiega-academics/rust-cfg-parser" alt="License" /></a>
  <img src="https://img.shields.io/badge/rust-2024%20edition-black?logo=rust" alt="Rust 2024 edition" />
</p>

## Overview

CFG Parser is a Rust CLI project that tokenizes, parses, and evaluates arithmetic formulas based on a formal grammar.
It supports nested expressions, implicit multiplication, exponentiation, and n-th root operations with explicit error handling.

## Key Features

- Formal CFG-driven parsing pipeline.
- Separate tokenizer and parser/evaluator architecture.
- Real-number support (`f64`) with operator precedence.
- Implicit multiplication (`2(3+4)`, `(1+2)(4-1)`).
- Power (`^`) and n-th root (`$`) with semantic validation.
- Clear math/parsing error types for robust diagnostics.

## Supported Operators

| Operator | What it does | Example |
| --- | --- | --- |
| `+` | Adds two values | `3 + 2 =` |
| `-` | Subtracts one value from another | `7 - 4 =` |
| `*` | Multiplies two values | `6 * 5 =` |
| `/` | Divides one value by another | `8 / 2 =` |
| `^` | Raises a base to a power | `2 ^ 3 =` |
| `$` | Computes the n-th root (`base $ index`) | `27 $ 3 =` |
| `( )` | Groups expressions and controls precedence | `(1 + 2) * 3 =` |
| `implicit *` | Multiplies adjacent terms without `*` | `2(3+4) =` |

## Grammar Docs

- Grammar details: [`Grammar`](docs/md/grammar.md)
- Docker guide: [`Docker`](docs/md/docker.md)
- Contribution guidelines: [`Contributing`](CONTRIBUTING.MD)

## Quick Start

### Run with Rust

```bash
cargo run
```

### Run Tests

```bash
cargo test
```

## Docker Usage

Build and run:

```bash
docker build -t mathsolver .
docker run --rm mathsolver
```

Run with custom input (CLI argument):

```bash
docker run --rm mathsolver "(1 + 2) * 3 ="
```

Run with custom input (environment variable):

```bash
docker run --rm -e MATHSOLVER_INPUT="27 $ 3 =" mathsolver
```

For full Docker workflows, troubleshooting, and compose examples, see [`Docker docs`](docs/md/docker.md).

## Example Expression

Simple example:

```text
1 + 2 * 3 =
```

Expected output:

```text
Result: 7.000
```

Complex example:

```text
(3 + 5 * (2 - 3) ^ 2) / (4 - 1) + -2 * (5 + 2) ^ 3 - 10 =
```

Expected output:

```text
Result: -693.333
```

## Error Handling

The parser reports structured errors such as:

- Division by zero.
- Invalid operators or malformed numbers.
- Unmatched parentheses.
- Invalid exponentiation/root cases.
- Overflow and underflow conditions.

## Contributing & support 🤝

Contributions are welcome.

- For bugs and feature requests, open an [Issue](https://github.com/simonesiega-academics/rust-cfg-parser/issues).
- For code contributions, open a **Pull Request** with a clear description of the change and its rationale.
- For direct contact, email me at [simonesiega1@gmail.com](mailto:simonesiega1@gmail.com) or reach out on [GitHub](https://github.com/simonesiega).

## License

This project is licensed under the MIT License. See [`LICENSE`](LICENSE).

## Authors 🧑‍💻

<p align="center">
  <a href="https://github.com/simonesiega-academics/rust-cfg-parser/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=simonesiega-academics/rust-cfg-parser&max=24&columns=12" alt="Contributors" />
  </a>
</p>
