<h1 align="center">Contributing to cfg-parser</h1>

<p align="center">
  Guidelines for contributing to <strong>cfg-parser</strong>.
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/simonesiega/cfg-parser?style=social" />
  <img src="https://img.shields.io/github/last-commit/simonesiega/cfg-parser" />
  <img src="https://img.shields.io/github/issues-pr/simonesiega/cfg-parser" />
  <img src="https://img.shields.io/github/issues/simonesiega/cfg-parser" />
  <img src="https://img.shields.io/github/license/simonesiega/cfg-parser" />
</p>

## Quick start 🚀

If you are new to the project, read [`README.md`](README.md) first, then pick one issue and keep the PR scope small.

| Step | Action |
| --- | --- |
| 1 | Fork the repository |
| 2 | Create a branch from `main` |
| 3 | Implement one focused change |
| 4 | Run checks locally |
| 5 | Open a PR with context and rationale |

Branch naming:

| Type | Pattern | Example |
| --- | --- | --- |
| Feature | `feat/<short-description>` | `feat/support-cli-input` |
| Bug fix | `fix/<short-description>` | `fix/invalid-root-validation` |
| Docs | `docs/<short-description>` | `docs/update-grammar-tables` |
| Maintenance | `chore/<short-description>` | `chore/deps-update` |

---

## Issues: bug reports and feature requests 

Before opening a new issue, check existing [Issues](../../issues) to avoid duplicates.

Please include:

| Field | Why it matters |
| --- | --- |
| Expected behavior | Defines the intended result |
| Actual behavior | Shows current failure or limitation |
| Reproduction steps | Makes debugging reliable |
| Environment (OS, Docker/Rust versions) | Helps isolate platform-specific issues |
| Logs / error output | Speeds root-cause analysis |
| Screenshots (if relevant) | Clarifies UI/CLI outcomes |

Tip: for architecture-level changes, open an issue first so we can align on design early.

---

## Local validation 

Choose one of the following workflows.

### Rust workflow

```bash
cargo fmt
cargo test
cargo run
```

### Docker workflow (no Rust installed)

```bash
docker compose up --build
```

Reference docs:
- [Docker](docs/md/docker.md)

---

## Pull request checklist 

Before requesting review, verify:

- [ ] Title and description explain what changed and why
- [ ] Local checks/tests were run when applicable
- [ ] Docs were updated if behavior or usage changed
- [ ] No secrets or personal data were committed
- [ ] PR is focused (no unrelated cleanup)

---

## Security policy 

If you discover a vulnerability, **do not** open a public issue.

Report privately to the maintainer with:
- Description
- Impact
- Reproduction steps
- Suggested mitigation (optional but appreciated)

---

## Community guidelines 🤝

Be respectful and constructive in issues, PRs, and reviews.

Clear, actionable feedback is always welcome.

---

## Contact 📬

For direct contact:
- Email: simonesiega1@gmail.com
- GitHub: https://github.com/simonesiega

Thanks again for contributing to CFG Parser.
