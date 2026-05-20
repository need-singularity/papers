---
schema: cross_repo_publish/module/ai-native/1
last_updated: 2026-05-02
ssot:
  interface: cross_repo_publish/core/source.hexa
  registry:  cross_repo_publish/core/registry.hexa
  router:    cross_repo_publish/core/router.hexa
  aggregator: cross_repo_publish/core/main.hexa  # NOTE: stem 'main' per user task spec; raw 270 normally requires '<feature>_main' (caveat C1)
upstream_dependency:
  manifest: papers/manifest.json
  bin:      papers/bin/papers
  tools:
    - papers/tool/zenodo_publish.hexa          # 619 LOC, single-paper publish
    - papers/tool/zenodo_sync.hexa             # 207 LOC, manifest <-> Zenodo bulk sync
  blocked:
    - papers/tool/osf_publish.hexa             # NOT YET LANDED (cross_repo_publish.blk.1)
markers:
  triplet_landed: papers/state/markers/papers_raw270_triplet_landed.marker
roadmap_entry: .roadmap.cross_repo_publish cond.1 / cond.2 / cond.3 (+ blk.1)
status: 3 FACADE modules, OSF dual-archive Phase 2 stub blocker active
mk2_scope: peer (papers repo, additive raw 270/271/272/273 land)
---

# cross_repo_publish domain modules (AI-native)

raw 270/271/272/273 (mk2 arch.001) canonical 4-file pattern applied to the
`cross_repo_publish` flow domain. Three FACADE modules wrap authoritative
`tool/*.hexa` files. Sister-repo paper artifacts route through here per

## TL;DR for an agent reading this cold

- Three operations: `publish`, `sync`, `validate`.
- Each module exports `xrp_op_meta_<name>()` and `xrp_op_invoke_<name>(args)`.
- The aggregator is `cross_repo_publish/core/main.hexa` (stem `main`
  per user task spec — see caveat C1; deviates from raw 270 stem-equals-feature).
- Default chain: `lint -> publish -> sync` (validate first, then publish, then
  reconcile).
- FACADE meta-only by default. Set `PAPERS_FACADE_SHELL=1` to actually shell
  out via `hexa.real`.
  only (anima / nexus / CANON / sedi / brainwire / tecs-l). Sister-
  repo self-publish FORBIDDEN.

## Architecture map

```
sister-repo paper artifact
       |- cross_repo_publish/core/router.hexa     (verb -> op)
            |- cross_repo_publish/core/registry.hexa
                 |- cross_repo_publish/module/validate.hexa  WRAPPED  cond.1
                 |- cross_repo_publish/module/publish.hexa   WRAPPED  cond.2
                 |    `- tool/zenodo_publish.hexa                    (619 LOC; secret token)
                 `- cross_repo_publish/module/sync.hexa      WRAPPED  cond.3
                      `- tool/zenodo_sync.hexa                       (207 LOC; bulk reconcile)

  BLOCKED Phase 2:
  papers/tool/osf_publish.hexa  --  cross_repo_publish.blk.1 (impl gap)
       |- cross_repo_publish/module/publish.hexa.is_dual_archive remains 0 until landed
```

## Public API contract

```hexa
struct XrpOpMeta {
    name:           str
    tool_path:      str   // delegation target (papers/tool/<name>.hexa)
    domain_cond:    str   // .roadmap.cross_repo_publish cond mapping
    bin_verb:       str   // canonical bin/papers verb
    is_readonly:    int   // 0/1
    requires_net:   int   // 0/1
    requires_secret: int  // 0/1
    is_dual_archive: int  // 1 = writes BOTH Zenodo + OSF (Phase 2)
    status:         str   // "WRAPPED" | "FACADE" | "STUB"
    tool_loc:       int
}

struct XrpOpResult {
    ok:        int
    exit_code: int
    stdout_:   str
    stderr_:   str
    message:   str
}

// Per-module: cross_repo_publish/module/<name>.hexa exports
fn xrp_op_meta_<name>() -> XrpOpMeta
fn xrp_op_invoke_<name>(args: [str]) -> XrpOpResult
```

## Operation table (canonical)

| Operation | Verb | tool/* SSOT | LOC | Read-only | Net | Secret | Dual-archive | Cond |
|-----------|------|-------------|----:|----------:|----:|-------:|-------------:|------|
| `validate` | lint | `tool/papers_cross_repo_lint.hexa` | 388 | yes | no | no | n/a | cond.1 |
| `publish` | publish | `tool/zenodo_publish.hexa` | 619 | no | yes | yes | 0 (Phase 2 stub) | cond.2 |
| `sync` | sync | `tool/zenodo_sync.hexa` | 207 | no | yes | yes | 0 (Phase 2 stub) | cond.3 |

## Invocation patterns

### Meta-only (default; CI-safe)

```hexa
let m = xrp_op_meta_publish()
let r = xrp_op_invoke_publish(["--dry-run"])
// r.ok == 1, r.message == "facade-meta-only"
```

### Opt-in shell-out

```bash
PAPERS_FACADE_SHELL=1 hexa.real /Users/ghost/core/papers/cross_repo_publish/module/validate.hexa
```

### Force-single-op for diagnostic

```bash
XRP_OP_FORCE=sync hexa.real /Users/ghost/core/papers/cross_repo_publish/core/router.hexa
```


> Paper artifacts (PDF / source / DOI metadata) for any sister repo MUST land
> in `papers/<sub>/<paper-id>/` only. Sister-repo self-publish (i.e. landing
> a Zenodo deposit from inside `anima/`, `nexus/`, etc.) is FORBIDDEN.

The `validate` op enforces this via `tool/papers_cross_repo_lint.hexa` v1.2:
- **BLOCK**: duplicate paper artifact found in sister repo (must be removed
  or relocated to `papers/<sub>/`).
  block).

## Adding a new cross-repo publish op (template)

1. Create `papers/tool/<new_op>.hexa` with the actual logic.
2. Create `cross_repo_publish/module/<new_op>.hexa` with the two
   exported fns and structs (mirror `publish.hexa`).
3. Register in `cross_repo_publish/core/registry.hexa`.
4. Add verb mapping in `cross_repo_publish/core/router.hexa` if a new
   bin/papers verb dispatches here.
5. Update `main.hexa` aggregator (`_meta_for` + `names` array).
6. Update this README's operation table.
7. Land marker: `papers/state/markers/xrp_op_<new_op>_landed.marker`.

## Phase 2 OSF dual-archive lift (cross_repo_publish.blk.1)

When `tool/osf_publish.hexa` lands:
1. Add `cross_repo_publish/module/osf_publish.hexa` (new FACADE).
2. Modify `cross_repo_publish/module/publish.hexa` to flip
   `is_dual_archive` to 1 AND add OSF leg in invoke (after Zenodo success).
3. Update aggregator selftest line 5 expectation: `dual_archive coverage:
   3/3` (was `0/3`).
4. Mark `cross_repo_publish.blk.1` resolved in `.roadmap.cross_repo_publish`.

## Invariants (lint-checkable, raw 270 conformance)

- `cross_repo_publish/core/<f>.hexa` MUST contain exactly 4 files:
  `source`, `registry`, `router`, `main` (deviation flagged C1).
- Every `cross_repo_publish/module/<name>.hexa` MUST export both
  `xrp_op_meta_<name>()` and `xrp_op_invoke_<name>(args)`.
- This `README.ai.md` MUST exist (raw 271 mandate).
- Import direction: T2 modules -> T1 core registry -> T0 source. Reverse FORBIDDEN.


1. **Aggregator stem deviation.** `main.hexa` (per user task spec) instead of
   `cross_repo_publish_main.hexa`. Raw 270 (mk2 arch.001 falsifier
   F-arch.001-1) would normally require stem-equals-feature. Tracked as
   handoff caveat C1; sibling `papers` domain follows raw 270 strictly with
   `papers_main.hexa`.
2. **OSF dual-archive Phase 2 stub.** `is_dual_archive` is 0 across all 3
   ops until `tool/osf_publish.hexa` lands.
   `cross_repo_publish.blk.1` tracks impl gap.
3. **`tool/zenodo_publish.hexa` + `tool/zenodo_sync.hexa` require
   `secret get zenodo.token`.** Calling without the token causes downstream
   API auth failure (caught by exit code).
4. **`sync` writes manifest.json.** Bi-directional reconcile may rewrite
   `manifest.json[papers[i].doi]` if Zenodo has a newer record. Always run
   `git diff manifest.json` after a real sync.
5. **`validate` exit-code semantics.** exit=0 means no BLOCK violations.
   WARN entries (grandfather-mark exempt) do NOT cause non-zero exit.
6. **No struct deduplication.** Each layer re-declares `XrpOpMeta` and
   `XrpOpResult` because hexa-lang stage0 has no `import` for cross-file
   struct sharing.
7. **`bin/papers` is the live entrypoint.** This layer is parallel cold-read
   surface; `bin/papers` continues to call `tool/<name>.hexa` directly.
8. **Hard-rollback on dual-archive failure NOT IMPLEMENTED.** Per
   `.roadmap.cross_repo_publish` excludes `hard_rollback_dual_archive`
   (Phase 3 candidate). Best-effort, manual cleanup on partial failure.

## Verified at land time (2026-05-02)

- Aggregator selftest: 6 categories all PASS (meta-only invocation).
- All 3 modules: SELFTEST PASS (FACADE meta path).
- No shell-out engaged during selftest.
- tool/* sha unchanged (additive policy verified).
- `is_dual_archive=0` across all 3 ops (matches blk.1 expected state).

## File index

| Path | LOC | role |
|------|----:|------|
| `cross_repo_publish/core/source.hexa` | ~145 | T0 interface |
| `cross_repo_publish/core/registry.hexa` | ~190 | T1 dispatch |
| `cross_repo_publish/core/router.hexa` | ~155 | T1 verb -> op |
| `cross_repo_publish/core/main.hexa` | ~205 | T1 aggregator |
| `cross_repo_publish/module/publish.hexa` | ~120 | T2 FACADE |
| `cross_repo_publish/module/sync.hexa` | ~110 | T2 FACADE |
| `cross_repo_publish/module/validate.hexa` | ~120 | T2 FACADE |
| `cross_repo_publish/module/README.ai.md` | this file | raw 271 mandate |

LOC approximate at land time. Re-pin via `wc -l` after edits.
