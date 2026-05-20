---
schema: papers/module/ai-native/1
last_updated: 2026-05-02
ssot:
  interface: papers/core/source.hexa
  registry:  papers/core/registry.hexa
  router:    papers/core/router.hexa
  aggregator: papers/core/papers_main.hexa
upstream_dependency:
  manifest: papers/manifest.json   # 183 KB, 433+ paper SSOT
  bin:      papers/bin/papers      # 12-verb CLI dispatch
  tools:
    - papers/tool/manifest_query.hexa   # 986 LOC, read-only query engine
    - papers/tool/doi_verify.hexa       # 201 LOC, link health verifier
    - papers/tool/zenodo_publish.hexa   # 619 LOC, Zenodo publish workflow
markers:
  triplet_landed: papers/state/markers/papers_raw270_triplet_landed.marker
roadmap_entry: .roadmap.papers cond.1 / cond.2
status: 3 FACADE modules wrapping authoritative tool/* (additive only)
mk2_scope: peer (papers repo, additive raw 270/271/272/273 land)
---

# papers domain modules (AI-native)

raw 270/271/272/273 (mk2 arch.001) canonical 4-file pattern applied to the
`papers` self-domain. Every operation module here is a thin FACADE over an
existing `tool/<name>.hexa`. The underlying tools are NOT modified — this is
additive layer that exposes the canonical interface for cold-read agents.

## TL;DR for an agent reading this cold

- Three operations: `manifest_query`, `doi_verify`, `zenodo_publish`.
- Each module exports two functions: `papers_op_meta_<name>()` and
  `papers_op_invoke_<name>(args)`.
- The aggregator is `papers/core/papers_main.hexa` (raw 270 stem-equals-
  feature rule; aggregator MUST be `papers_main.hexa`, not `main.hexa`).
- FACADE meta-only by default. Set `PAPERS_FACADE_SHELL=1` to actually shell
  out to the underlying `tool/<name>.hexa` via `hexa.real`.
- Force a single op for diagnostic: `PAPERS_OP_FORCE=manifest_query`.
- The live entrypoint remains `papers/bin/papers` — this layer is additive only.

## Architecture map

```
caller
  |- papers/core/router.hexa        (verb -> op routing)
       |- papers/core/registry.hexa (name -> module)
            |- papers/module/manifest_query.hexa  WRAPPED  papers.cond.1
            |    `- tool/manifest_query.hexa              (986 LOC, SSOT)
            |- papers/module/doi_verify.hexa      WRAPPED  cross_repo_publish.cond.3
            |    `- tool/doi_verify.hexa                  (201 LOC, SSOT, py3 heredoc)
            `- papers/module/zenodo_publish.hexa  WRAPPED  cross_repo_publish.cond.2
                 `- tool/zenodo_publish.hexa              (619 LOC, SSOT, requires secret)
```

## Public API contract

```hexa
struct PapersOpMeta {
    name:           str   // canonical short id, snake_case
    tool_path:      str   // delegation target (papers/tool/<name>.hexa)
    domain_cond:    str   // .roadmap.* cond mapping
    bin_verb:       str   // canonical bin/papers verb
    is_readonly:    int   // 0/1
    requires_net:   int   // 0/1
    requires_secret: int  // 0/1
    status:         str   // "WRAPPED" | "FACADE" | "NATIVE"
    tool_loc:       int   // upstream tool/<name>.hexa LOC
}

struct PapersOpResult {
    ok:        int       // 0 on any failure
    exit_code: int       // shell exit code (when shell-out engaged)
    stdout_:   str       // captured stdout body (truncated 4096 B)
    stderr_:   str       // captured stderr body (truncated 4096 B)
    message:   str       // human-readable diagnostic
}

// Per-module: papers/module/<name>.hexa exports
fn papers_op_meta_<name>() -> PapersOpMeta
fn papers_op_invoke_<name>(args: [str]) -> PapersOpResult
```

## Operation table (canonical)

| Operation | Verb(s) | tool/* SSOT | LOC | Read-only | Net | Secret | Cond mapping |
|-----------|---------|-------------|----:|----------:|----:|-------:|--------------|
| `manifest_query` | list / get / cite / validate | `tool/manifest_query.hexa` | 986 | yes | no | no | papers.cond.1 |
| `doi_verify` | verify | `tool/doi_verify.hexa` | 201 | yes | yes | no | cross_repo_publish.cond.3 |
| `zenodo_publish` | publish | `tool/zenodo_publish.hexa` | 619 | no | yes | yes | cross_repo_publish.cond.2 |

## Invocation patterns

### Meta-only (default; CI-safe, no shell-out)

```hexa
let m = papers_op_meta_manifest_query()
let r = papers_op_invoke_manifest_query(["list", "--json"])
// r.ok == 1, r.message == "facade-meta-only"
// r.stdout_ contains the FACADE description string
```

### Opt-in shell-out (engages tool/<name>.hexa via hexa.real)

```bash
PAPERS_FACADE_SHELL=1 hexa.real /Users/ghost/core/papers/papers/module/manifest_query.hexa
```

### Force-single-op for diagnostic

```bash
PAPERS_OP_FORCE=zenodo_publish hexa.real /Users/ghost/core/papers/papers/core/router.hexa
```

## Adding a new papers operation (template)

1. Create `papers/tool/<new_op>.hexa` with the actual logic (this is where the
   real implementation lives).
2. Create `papers/module/<new_op>.hexa` with the two exported fns and
   two structs (mirror `manifest_query.hexa`).
3. Register in `papers/core/registry.hexa` (add dispatch case +
   `papers_registry_names()` entry).
4. Add verb mapping in `papers/core/router.hexa` if a new bin/papers
   verb dispatches here.
5. Update `papers_main.hexa` aggregator (`_meta_for` + `names` array).
6. Update this README's operation table row.
7. Land marker: `papers/state/markers/papers_op_<new_op>_landed.marker`.

## Invariants (lint-checkable, raw 270 conformance)

- `papers/core/<f>.hexa` MUST contain exactly four files: `source`,
  `registry`, `router`, `papers_main` (stem equals feature).
- Every `papers/module/<name>.hexa` MUST export both
  `papers_op_meta_<name>()` and `papers_op_invoke_<name>(args)`.
- This `README.ai.md` MUST exist as literal `README.ai.md` (raw 271 mandate).
- Import direction: T2 modules -> T1 core registry -> T0 source. Reverse FORBIDDEN.


1. **FACADE-only by default.** No shell-out unless `PAPERS_FACADE_SHELL=1`.
   The 3 modules NEVER duplicate logic from `tool/<name>.hexa`. Migration of
   tool logic into papers/module/ is NOT in scope this BG cycle (additive only).
2. **`tool/doi_verify.hexa` contains a python3 heredoc.** raw 9 hexa-only
   compliance is `.roadmap.papers cond.3` — not yet met. Tracked separately.
3. **`tool/zenodo_publish.hexa` requires `secret get zenodo.token`.** Calling
   without the token causes a downstream API auth failure (caught by exit code).
4. **No struct deduplication.** Each layer (source/registry/router/main +
   each module) re-declares `PapersOpMeta` and `PapersOpResult` because
   hexa-lang stage0 has no `import` for cross-file struct sharing. This
   mirrors the anima/core/rng/ prototype.
5. **`bin/papers` is the live entrypoint.** This layer adds a parallel cold-
   read surface; it does NOT replace `bin/papers` and does NOT wire into the
   12-verb dispatch in this BG cycle.
6. **Aggregator stem.** Raw 270 mandates `<feature>_main.hexa` — so the
   aggregator file is `papers_main.hexa` (NOT `main.hexa`). The sibling
   `cross_repo_publish` domain uses `main.hexa` per the user task spec; that
   choice intentionally diverges and is flagged as caveat C1 in handoff.
7. **No write to manifest.json.** All read-only ops are guaranteed; the only
   write op (`zenodo_publish`) writes the DOI back into manifest.json after
   publish, which is gated behind both `PAPERS_FACADE_SHELL=1` AND a non-
   `--dry-run` invocation of the underlying tool.

## Verified at land time (2026-05-02)

- Aggregator selftest: 5 categories all PASS (meta-only invocation).
- All 3 modules: SELFTEST PASS (FACADE meta path).
- No shell-out engaged during selftest (CI-safe).
- tool/* sha unchanged (additive policy verified).

## File index

| Path | LOC | role |
|------|----:|------|
| `papers/core/source.hexa` | ~140 | T0 interface contract |
| `papers/core/registry.hexa` | ~190 | T1 name -> dispatch |
| `papers/core/router.hexa` | ~170 | T1 verb -> op routing |
| `papers/core/papers_main.hexa` | ~190 | T1 aggregator + selftest |
| `papers/module/manifest_query.hexa` | ~135 | T2 FACADE |
| `papers/module/doi_verify.hexa` | ~125 | T2 FACADE |
| `papers/module/zenodo_publish.hexa` | ~130 | T2 FACADE |
| `papers/module/README.ai.md` | this file | raw 271 mandate |

LOC approximate at land time. Re-pin via `wc -l` after edits.
