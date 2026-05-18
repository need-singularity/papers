#!/usr/bin/env tape
# AGENTS.tape — dancinlab/papers (the complete paper collection)
# SSOT: this file. AGENTS.md is a derived view (h1). CLAUDE.md → AGENTS.tape symlink (h2).

# ─── §1 Spec version ──────────────────────────────────────────────────

@V := "tape" :: spec [active]
  version = "1.2"
  uses = [@I, @C, @L, @D, @F, @X, @N, @H, "<:", "@>", "[required]", heredoc, "[@id]"]
  primer = "see top-of-file 35-line comment block"

@X hexa_verify := "hexa verify — verification via hexa CLI only" :: guide [active]
  tldr = "Any correctness / purity / grade / identity claim → verify with `hexa <verb>` or `hexa run <verifier>.hexa` (e.g. `hexa run tool/atlas_verify.hexa`) and paste the verdict VERBATIM. NEVER cite sympy / PyPhi / Wolfram / Mathematica output as evidence."
  detail = "~/core/atlas/VERIFY.tape"

@X wilson_pool := "wilson pool — resource utilization" :: guide [active]
  tldr = "Heavy / deterministic work (build · drill · probe · compile · test-sweep · GPU fire) → do NOT serialize on localhost; route to the host pool: `wilson pool list` then `wilson pool on <host> <cmd>`, or a ToolUse `\"host\"` field. Empty roster = degrade-to-local, fine."
  detail = "~/core/atlas/POOL.tape"

# ─── §2 Identity claims (what this project IS) ────────────────────────

@I id001 := "papers" :: identity-claim [d=2026-05-14 active]
  kind = "dancinlab paper collection · complete archive across four active projects"
  brief = "complete paper collection · 92 papers · Zenodo DOIs · umbrella DOI 10.5281/zenodo.19271599"
  parent = "dancinlab"
  total = "92 papers (README §Collection)"
  umbrella-doi = "10.5281/zenodo.19271599"
  axis = "publication archive · Zenodo-primary · OSF-mirror · CC BY 4.0"
  license = "CC BY 4.0"
  author = "Park, Min Woo — Independent Researcher · nerve011235@gmail.com"
  browse = "https://dancinlab.github.io/papers/"

@I id002 := "papers.organization" :: identity-claim [d=2026-05-14 active]
  <: id001
  layout-style = "manifest-driven flat list — `manifest.json` is canonical SSOT for paper entries"
  grouping = "by project · README tables emit 4 sections (nexus · anima · CANON · hexa-lang)"
  per-paper-record <<~EOF
    Each paper is a manifest.json entry with:
      - id (e.g. `P-001`, `PA-11b`, `PS-23`, `P-NEW-1`, `P-HEXA`)
      - title, repo (anima/nexus/canon/hexa-lang/tecs-l), file (path-in-repo)
      - status (Published / Draft / Pending), doi (10.5281/zenodo.<n>), date, tier
      - keywords[], abstract_first_line
    On-disk artifacts live in the originating repo's `tecs-l/`, `nexus/`, `anima/`, etc.
    This repo aggregates the manifest — it is the citation / verify / publish hub.
  EOF
  cli = "`papers list` · `papers cite <id>` · `papers verify` · `papers publish <id>` · `papers sync`"

# ─── §3 Config ────────────────────────────────────────────────────────

@C c1 := "manifest-path" :: config [active]
  value = "manifest.json"
  why = "canonical SSOT for all 92 entries; every CLI verb reads this file"

@C c2 := "zenodo-token-source" :: config [active]
  value = "secret get zenodo.token"
  why = "no hard-coded tokens; `secret` CLI manages credentials for `papers publish`"

@C c3 := "osf-token-source" :: config [active]
  value = "secret get osf.token"
  why = "dual-archive: Zenodo primary, OSF mirror"

# ─── §4 Repo layout ───────────────────────────────────────────────────

@L l1 := "repo-layout" :: structure [active]
  README.md     -> "human intro · 92-paper table grouped by project (nexus/anima/CANON/hexa-lang)"
  AGENTS.tape   -> "this file · governance + identity (.tape v1.2)"
  CLAUDE.md     -> "symlink → AGENTS.tape (Claude Code auto-discovery)"
  manifest.json -> "SSOT for paper entries (id · title · repo · file · status · doi · date · tier · keywords)"
  keyword_index.json -> "derived index over manifest keywords"
  bin/papers    -> "bash dispatcher (sole binary entry-point)"
  tool/         -> "11 hexa-lang tools (doi_verify · zenodo_publish · osf_publish · zenodo_sync · meta_scanner · ...)"
  tool/lib/     -> "shared helpers"
  papers/       -> "in-repo hexa modules (core/ · doc/ · module/ · lint.hexa)"
  state/        -> "audit ledgers + scan output (state/papers_lint_audit/audit.jsonl)"
  anima/        -> "anima paper sources (mirrored from anima repo)"
  nexus/        -> "nexus paper sources (mirrored from nexus repo)"
  n6-architecture/ -> "CANON / n6-architecture paper sources"
  cross_repo_publish/ -> "publish pipeline shared across dancinlab repos"
  project.hexa  -> "hexa project root marker"
  LICENSE       -> "CC BY 4.0"

# ─── §5 Governance rules ──────────────────────────────────────────────

@D g_inherit := "inherit-wilson-governance" :: governance [required]
  rule = "Inherit the wilson governance principle array (atlas-knowledge · hexa-first · domain-meta-domain · lattice-as-tool · project-governance · …)."
  authority = "`~/core/wilson/plugins/governance/SPEC.md`"
  @> AGENTS.md

@D g1 := "manifest-is-ssot" :: governance [required]
  rule = "`manifest.json` is the canonical SSOT for all paper entries. README tables + keyword_index.json + papers CLI views are derived. Edits to paper metadata go through `manifest.json` only."
  applies-to = ["manifest.json", "README.md tables", "keyword_index.json"]
  @> AGENTS.md

@D g2 := "cc-by-4.0-only" :: governance [required]
  rule = "All papers ship under CC BY 4.0. No alternative license per-paper — collection-level uniformity."
  authority = "LICENSE · README §License"
  @> AGENTS.md

@D g3 := "tape-runtime-trace" :: governance [required]
  rule = "Runtime trace + agent identity + per-domain history use .tape grammar."
  applies-to = [AGENTS.tape, "SEED.tape", "*.tape"]
  why = "governance principle #9b · append-only event semantics"
  proof = "see `~/core/wilson/plugins/governance/SPEC.md` §#9b"

@D g4 := "domain-meta-domain" :: governance [required]
  rule = "Per-topic roadmaps as root `UPPERCASE.md` (one domain = one file). Cross-project lives in `~/core/atlas/PROJECT::DOMAIN.md`. Head + `---` + `## Log` (append at bottom, chronological)."
  authority = "wilson governance principle #9 · `~/core/wilson/plugins/governance/SPEC.md`"
  @> AGENTS.md

@D g_zenodo_doi_required := "zenodo-doi-required" :: governance [required]
  rule = "Every paper merged into `manifest.json` MUST carry a Zenodo DOI (`10.5281/zenodo.<n>`). Drafts may use `status: Draft / Pending` while a DOI is being minted, but Published status requires a verified DOI."
  enforcement = "`papers verify` (tool/doi_verify.hexa) on PR; lint catches missing/malformed DOI fields"
  exception = "`status: Pending` rows in README are allowed pre-publish; manifest entries still need a Zenodo reservation"
  authority = "README §Run table · `tool/doi_verify.hexa` · `tool/zenodo_sync.hexa`"
  @> AGENTS.md

@D g_paper_immutability := "paper-immutability" :: governance [required]
  rule = "Published papers are immutable artifacts. Corrections ship as a NEW Zenodo version (new DOI suffix) — never as an in-place edit of a published file or DOI record."
  applies-to <<~EOF
    Any paper with manifest `status: Published`
    Any file whose path appears in a Published manifest entry's `file` field
    Any Zenodo record already minted (the record itself is immutable on Zenodo's side; we mirror that here)
  EOF
  remedy = "Create a new versioned record (Zenodo `new version` workflow) → add a new manifest entry → cross-link via README + manifest `supersedes` field (when added)."
  forbidden = "rewriting an already-Published markdown source · re-uploading to the same Zenodo record id · silently editing a published abstract"
  ?> g_zenodo_doi_required
  @> AGENTS.md

@D g_arch_vs_log_split := "v1.2 architecture-vs-history split" :: governance [required d=2026-05-14 active]
  rule = "UPPERCASE.tape files are EDITABLE architecture (latest-wins per id). Append-only event history lives in UPPERCASE.log.tape siblings."
  why = "declarative entries (governance · config · layout · identity) evolve naturally; locking them as append-only via ~> supersedes creates noisy histories. The split lets architecture stay current and history stay immutable."
  applies-to = "AGENTS.tape · all UPPERCASE.tape root files"
  authority = "[@x_tape_spec] §Domain-tape sibling §Architecture-vs-history split"
  @> AGENTS.md


# ─── §6 Forbidden patterns ────────────────────────────────────────────

@F f1 := "external-lattice-fit" :: governance [required deny:write]
  pattern = "n=6 / σφτ identity applied as DERIVATION rule to NASA · SpaceX · IPCC · IBC · constitutional bodies · external standards orgs"
  exception = "values may coincidentally match (e.g. 6 axes in some external spec) — that's allowed as observation, NOT derivation. Honest-caveat language required."
  authority = "[@x_lattice_policy] · wilson governance principle #10 (`lattice-as-tool`)"
  applies-to = "every paper that touches external bodies in its abstract / claim section"

@F f_unpublished_claim := "cite-unpublished-as-peer-reviewed" :: governance [required deny:write]
  pattern = "Citing an unpublished / Draft / Pending paper as if it were peer-reviewed or merely 'published'"
  rule = "Papers cited in another paper's text MUST disclose their status when it is anything other than Published-with-DOI. Use phrasing like 'preprint (Zenodo DOI 10.5281/zenodo.X)' or 'unpublished draft' explicitly."
  why = "scientific honesty · the collection is a living archive (README §header) and mixing draft/preprint with peer-reviewed without disclosure is misleading"
  ?> g_zenodo_doi_required
  @> AGENTS.md

# ─── §7 External citations ────────────────────────────────────────────

@X x_lattice_policy := "hexa-chip/LATTICE_POLICY.md" :: policy [active]
  url = "https://github.com/dancinlab/hexa-chip/blob/main/LATTICE_POLICY.md"
  scope = "lattice-as-tool (n=6 lattice is a tool, not a constraint) · forbidden lattice-fit on external entities · honest-caveat policy origin"
  authority-for = [f1]

@X x_tape_spec := "dancinlab/tape spec" :: spec [active]
  url = "https://github.com/dancinlab/tape"
  local = "~/core/tape/spec/tape.md"
  scope = ".tape v1.2 grammar · 17 entry types · 12 edges · 16 algorithms · 7 examples"
  authority-for = [g3]

@X x_zenodo := "Zenodo (CERN OpenAIRE)" :: policy [active]
  url = "https://zenodo.org/"
  scope = "primary archive for dancinlab papers · DOI minting · versioned records · CC BY 4.0 hosting"
  doi-scheme = "10.5281/zenodo.<integer>"
  versioning = "each correction = new record with new DOI; original DOI remains immutable"
  umbrella-doi = "10.5281/zenodo.19271599 (dancinlab papers collection-level)"
  api-token = "via `secret get zenodo.token` (see [@c2])"
  authority-for = [g_zenodo_doi_required, g_paper_immutability]

@X x_osf := "Open Science Framework" :: policy [active]
  url = "https://osf.io/"
  scope = "secondary mirror for most papers (osf.io/<5char> ids in README tables)"
  note = "dual-archive policy — Zenodo primary, OSF mirror; OSF token via `secret get osf.token` ([@c3])"

@X x_agents_md := "agents.md standard" :: convention [active]
  url = "https://agents.md/"
  scope = "third-party AI-agent harness file convention (Claude Code · Aider · Cursor)"
  note = "AGENTS.tape is the dancinlab tape-native alternative; CLAUDE.md → AGENTS.tape symlink preserves auto-discovery; AGENTS.md is the legacy emit (h1)"

# ─── §8 Notes (LLM-only hints) ────────────────────────────────────────

@N n1 := "manifest-vs-readme-mismatch" :: note [active]
  text <<~EOF
    `manifest.json::_meta.total_papers` reads 120 because it aggregates across multiple
    repos (anima · nexus · CANON · TECS-L · papers). The README header claims 92 — the
    paper collection's own scope. If you're counting, prefer the README breakdown when
    answering "how many papers are in dancinlab/papers".
  EOF

@N n2 := "publish-flow" :: note [active]
  text <<~EOF
    Publishing a new paper:
      1. Add manifest.json entry (status: Draft).
      2. `papers publish <id> --target zenodo` → mints DOI.
      3. `papers sync` → manifest absorbs the minted DOI.
      4. `papers publish <id> --target osf` → mirror to OSF.
      5. Flip manifest status to Published; commit.
      6. Once Published, treat as immutable ([@g_paper_immutability]).
  EOF

# ─── §9 Generator hooks ───────────────────────────────────────────────

@H h1 := "agents-md-emit" :: generator [active]
  @> AGENTS.md
  consumer = "agents.md ecosystem tooling that doesn't speak .tape yet (Claude Code · Aider · Cursor)"
  algorithm = "tape_to_agents_md (algorithms/tape_to_agents_md.hexa)"
  trigger = "pre-commit hook + CI"
  fallback-only = true   # AGENTS.tape is SSOT; AGENTS.md is derived view

@H h2 := "claude-md-symlink" :: generator [active]
  rule = "ship `CLAUDE.md -> AGENTS.tape` symlink so Claude Code auto-discovery picks up the grammar primer first"
  command = `ln -sf AGENTS.tape CLAUDE.md`
