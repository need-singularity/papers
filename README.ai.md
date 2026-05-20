---
schema: papers/ai-native/1
last_updated: 2026-05-02
ssot:
  manifest:    papers/manifest.json
  project:     papers/project.hexa
  human_doc:   papers/README.md
  cli_entry:   papers/bin/papers
  keyword_idx: papers/keyword_index.json
markers:
  ai_native_doc_landed: hive/state/markers/papers_ai_native_doc_landed.marker
roadmap_entry: (n/a — papers is content repo, not in mk2 active 4-repo)
mk2_scope: scope_out (cold-start 룰 — 본 doc 은 사용자 명시 directive 2026-05-02 에 따른 예외)
status: 92 papers archive · 12-verb CLI · Zenodo + OSF dual-archive
---

# papers (AI-native cold-read briefing)

`/Users/ghost/core/papers/` — dancinlab 4 active project (nexus / anima / CANON / hexa-lang) + sub (hive / void / airgenome) 의 paper 통합 archive. mk2 active 4-repo 의 외부 content repo.

## TL;DR for an agent reading this cold

- **목적**: 92+ paper 의 manifest / DOI / Zenodo+OSF dual-archive / bin/papers 12-verb CLI 운영.
- **SSOT 단일**: `manifest.json` (183KB) — 모든 paper meta 의 단일 source. 코드 / lint / publish / cite 모두 이 파일을 read.
- **CLI 진입**: `papers <verb>` — `list / get / cite / validate / verify / publish / pull / search / sync / lint / scan / secret / help`.
- **마이그레이션 금지**: cold-start 룰 #2 — 기존 manifest.json format / paper id schema 변경 금지.
- **사용자 manual scope**: papers / secret / contact 는 mk2 ecosystem 외, 사용자 수작업 영역. 자동화 도구 신규 작성 시 사용자 명시 confirm 필수.

## File index (top-level)

| Path | Purpose | Items |
|------|---------|------:|
| `anima/` | anima paper 그룹 (PA-* 제출본 / notes) | 45 |
| `brainwire/` | brainwire paper 그룹 | 3 |
| `CANON/` | n6 paper 그룹 (group-P / pandoc_templates / sigma_tau_8_submission 외) | 168 |
| `nexus/` | nexus paper 그룹 | 30 |
| `sedi/` | sedi paper 그룹 (factorial-universe 외) | 32 |
| `tecs-l/` | tecs-l paper 그룹 (results / figures) | 91 |
| `tool/` | papers 운영 도구 (.hexa) — doi_verify / zenodo_publish / osf_publish / zenodo_sync / papers_cross_repo_lint / meta_scanner / *_scan | 18 |
| `docs/` | 운영 문서 (auto-alien10 외) | 3 |
| `shared/` | shared/config | 1 |
| `state/` | audit / marker (keyword_search / osf_publish / zenodo_publish / manifest_update / pp2_gate / papers_cross_repo / papers_lint / proposals / doi_pull / markers) | 11 |
| `scratch/` | 임시 작업 영역 (commit X) | 0 |

## Public surface (CLI contract)

```
papers list [--status published|draft|...] [--project nexus|anima|...] [--tier N] [--json]
papers get <id> [--field F] [--json]
papers cite <id> --format bibtex|apa|ieee|cff|ris [--copy]
papers validate <id>
papers verify [--limit N]                # DOI / Zenodo / OSF link health
papers publish <id> [--target zenodo|osf|all] [--sandbox]
papers pull <doi>                        # phase 2 stub
papers search <query>                    # phase 2 stub
papers sync                              # Zenodo → manifest
papers lint                              # .own 8-rule check
papers scan {meta|continuous|missing-doi|orphan}
papers secret <args>                     # passthrough → ~/core/secret/bin/secret
papers help
```


1. **manifest.json 단일 SSOT** — 어떤 도구도 paper meta 를 별도 file 에 duplicate 하면 안됨. `papers/lint.hexa` 가 .own 8-rule 로 검증.
2. **Zenodo + OSF dual-archive** — `publish --target all` 은 두 archive 모두 push. 한쪽 실패 시 다른 쪽도 rollback 정책 (현재: best-effort, hard-rollback 미구현).
3. **DOI 발행 = 비가역** — 한번 publish 된 paper 의 manifest entry 는 immutable 영역 (title/authors/abstract/year). lint 가 mutation 차단.
5. **secret passthrough** — `papers secret <args>` 는 `~/core/secret/bin/secret` 으로 그대로 forward. credential 은 papers/ 안에 절대 저장 금지.
6. **scope_out 예외** — cold-start 프롬프트의 scope_out 에 명시되어 있으나, 사용자 directive 2026-05-02 에 의해 ai-native doc 추가만 허용. 코드 / manifest / bin 변경은 별도 directive 필요.

## Per-group README.ai.md (TODO — phase 2)

각 top-level dir (anima / brainwire / CANON / nexus / sedi / tecs-l / tool / docs / state) 는 자체 `README.ai.md` 가 추후 추가 예정. 본 root doc 는 cold-read agent 의 진입 anchor 역할만.
