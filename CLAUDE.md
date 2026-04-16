# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What is Paperasse

A collection of AI skills (Markdown prompt files) for French administrative and accounting tasks. Each skill transforms an AI agent into a specialist: accountant, tax auditor, statutory auditor, notary, or property manager. The skills are consumed by AI agents that read the `SKILL.md` files as system prompts.

## Commands

### Fetch banking/payment data
```bash
npm run fetch           # Qonto + Stripe (all accounts)
npm run fetch:qonto     # Qonto only
npm run fetch:stripe    # Stripe only
```
Requires `.env` with `QONTO_ID`, `QONTO_API_SECRET`, `STRIPE_SECRET` (see `.env.example`).

### Generate accounting outputs
```bash
npm run statements      # Bilan, compte de résultat, balance
npm run fec             # Fichier des Écritures Comptables
npm run pdfs            # Convert statements to PDF (uses Puppeteer)
npm run closing         # FEC + statements + PDFs in sequence
```
These scripts read `company.json` and `data/transactions/*.json`.

### Data freshness
```bash
python3 scripts/update_data.py          # Check + update PCG and liasse fiscale
python3 scripts/update_data.py --check  # Check only, no downloads
python3 scripts/update_data.py --force  # Force re-download
```
Skills older than 6 months trigger a warning.

### Company lookup
```bash
python3 scripts/fetch_company.py <SIREN_OR_NAME>
python3 scripts/fetch_company.py <SIREN> --json
```

### Notaire open data
```bash
python3 scripts/fetch_notaire_data.py geocode "12 rue de Rivoli, Paris"
python3 scripts/fetch_notaire_data.py dvf --code-insee 75101 --limit 20
python3 scripts/fetch_notaire_data.py rapport "12 rue de Rivoli, Paris" --markdown
```

### Evals (requires `uv` and `ANTHROPIC_API_KEY`)
```bash
uv run --project evals evals/run_evals.py                    # All skills
uv run --project evals evals/run_evals.py --skill notaire    # One skill
uv run --project evals evals/run_evals.py --grade-only       # Re-grade existing runs
uv run --project evals evals/run_evals.py --skip-grading     # Collect outputs only
```
Evals run each scenario in two modes (`with_skill` / `without_skill`) and compute a delta. Results land in `evals-workspace/`.

## Architecture

### Skill structure
Each skill lives in its own directory:
```
<skill-name>/
├── SKILL.md              # The agent prompt (frontmatter + instructions)
├── references/           # Domain reference texts (law, rates, procedures)
├── templates/            # Document templates with {{placeholder}} syntax
├── data/                 # Skill-specific structured data (JSON)
└── evals/
    ├── evals.json        # Test scenarios (prompt + assertions)
    └── files/            # Test fixture files (company.json, transactions, etc.)
```

### SKILL.md frontmatter
```yaml
---
name: skill-name
metadata:
  last_updated: YYYY-MM-DD   # Skills > 6 months show an obsolescence warning
includes:
  - data/**                  # Shared data files from repo root to include
description: |
  One-paragraph description.
  Triggers: keywords that activate this skill
---
```

### Shared data (`data/`)
- `pcg_YYYY.json` — Plan Comptable Général (800+ accounts, JSON with a `flat` array indexed by `number`)
- `nomenclature-liasse-fiscale.csv` — Liasse fiscale case IDs (`id;lib` format)
- `sources.json` — Manifest of all data sources with `last_fetched` dates

### Company configuration (`company.json`)
The runtime configuration file for a user's company — not committed (only `company.example.json` is). Created by the `comptable` or `syndic` skill setup wizard. Contains SIREN, legal form, fiscal year, tax regime, bank accounts, and integration flags. API keys go in `.env`, never in `company.json`.

### Integrations
- `integrations/qonto/fetch.js` — Fetches all transactions via Qonto API, writes to `data/transactions/qonto-<slug>.json`
- `integrations/stripe/fetch.js` — Fetches charges/payouts per account, writes to `data/transactions/stripe-<id>.json`
- Transaction format is normalized across sources with fields: `id`, `source`, `date`, `amount`, `currency`, `label`, `our_category` (filled by the comptable skill)

### Evals runner (`evals/run_evals.py`)
Runs `claude --bare` as a subprocess in two modes per scenario, grades outputs with an LLM-as-judge (Haiku by default), and writes `grading.json` + `benchmark.json`. Parallel by default (8 workers). Path traversal is guarded via `_require_within()`.

## Adding a new skill

1. Create a directory with a French lowercase name (hyphens for spaces)
2. Write `SKILL.md` with the required frontmatter (`name`, `description`, `metadata.last_updated`)
3. Add `references/` with applicable law texts and rate tables
4. Add `evals/evals.json` with test scenarios using `assertions` array
5. Update `marketplace.json`

## Key conventions

- **Markdown line breaks before lists**: when writing Markdown that will be converted to EPUB/PDF via Pandoc, always add a blank line before any list block (items starting with `-` or `*`), including after lines ending with `:`.
- **Data files**: only open data from official French sources (data.gouv.fr, IGN, INSEE, DGFIP). Sources tracked in `data/sources.json`.
- **Skills are not legal advice**: every skill ends with a disclaimer that it does not replace a licensed professional.
