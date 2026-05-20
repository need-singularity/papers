---
schema: papers/ai-native/1
title: papers mk2 redesign landed (4 .roadmap.* peer perspective)
date: 2026-05-03
agent: BG-PR
preset: friendly
mk2_scope: in_scope (peer perspective, additive only)
markers:
  landed: papers/state/markers/papers_mk2_redesign_landed.marker
ssot:
  roadmaps:
    - papers/.roadmap.papers
    - papers/.roadmap.cross_repo_publish
    - papers/.roadmap.brainwire
    - papers/.roadmap.sedi
---

# papers mk2 redesign landed — 4-domain peer SSOT

## Icon

## Analogy
도서관 카탈로그 = `manifest.json` (433 책 단일 대장).
사서 도구 12종 = `bin/papers <verb>` (list/get/cite/...).
출판 창구 = Zenodo + OSF dual-archive (공식 DOI 발행).
mk2 회의록 = `.roadmap.*` (회칙 충족 조건 추적, peer perspective 4종 신규 land).

## 7-element snapshot

| element | value |
|---|---|
| repo | `/Users/ghost/core/papers/` (128MB, 408 files) |
| domain count | 4 (papers / cross_repo_publish / brainwire / sedi) |
| perspective | peer (mk2 active 4-repo 외, 자체 trajectory) |
| roadmap files added | 4 |
| total required_conditions | 11 (3 + 3 + 2 + 3) |
| total excludes | 8 (4 + 2 + 1 + 1) |
| total blockers | 1 (cross_repo_publish OSF Phase 2 stub) |

## ASCII map (mk2 .roadmap.* 산하 도메인 토폴로지)

```
papers repo (peer perspective, mk2 scope_out → in_scope on 2026-05-03)
+-- .roadmap.papers (self-domain)
|     cond.1: manifest.json single-SSOT
|     cond.2: bin/papers 12-verb dispatch all-green
|     excludes: 4 (manifest schema break / bin proliferation / credential / mk2 active 4-repo)
|
+-- .roadmap.cross_repo_publish (publish flow domain)
|     cond.2: Zenodo + OSF dual-archive both active
|     cond.3: DOI verify -> sync -> orphan -> continuous_scan automation
|     excludes: 2 (hard rollback deferred / non-papers publish forbidden)
|     blocker: 1 (OSF tool Phase 2 stub)
|
+-- .roadmap.brainwire (sub-archive)
|     cond.1: papers/brainwire/ orphan = 0
|
+-- .roadmap.sedi (sub-archive)
      cond.1: papers/sedi/ orphan = 0 (PS-* + factorial-universe)
      cond.3: keyword_index.json 수학물리 keyword 정합
```

## Sub-dir audit (도메인 분석 결과)

| sub-dir | role | item count | mk2 도메인 매핑 |
|---|---|---:|---|
| `anima/` | anima 측 PA-* paper + notes | 45 | (consumer 측 anima repo 산하 .roadmap.* 가 cross-link, 본 repo .roadmap 중복 X) |
| `brainwire/` | brainwire P-001~003 (cortical/epilepsy/depression) | 3 | `.roadmap.brainwire` neww |
| `CANON/` | n6 paper 그룹 (group-P / pandoc_templates / sigma_tau_8 / N6-auto-convergence) | 168 | (CANON sister repo 측 mk2 .roadmap.* 별도, 본 repo 중복 X) |
| `nexus/` | nexus paper 그룹 | 30 | (nexus 측 .roadmap.* 별도, cross-link) |
| `sedi/` | PS-01~14 + factorial-universe | 32 | `.roadmap.sedi` new |
| `tecs-l/` | tecs-l n6-* paper + figures + CERN proposal | 91 | (도메인 ambiguity — C3 caveat) |
| `tool/` | 19 .hexa 운영 도구 (lint/scan/publish/sync/verify) | 19 | `.roadmap.papers` cond.2/3 + `.roadmap.cross_repo_publish` cond.* |
| `bin/` | papers CLI 단일 진입 | 1 | `.roadmap.papers` cond.2 |
| `docs/` | 운영 문서 (auto-alien10 / meta_engine_brainstorm / 본 doc) | 4 | (handoff/design 문서) |
| `state/` | audit + marker (10 sub-dir) | 11 | (lint/publish/sync 의 evidence 수집) |
| `shared/` | shared/config | 1 | (cross-cut, 도메인 외) |
| `scratch/` | 임시 영역 (commit X) | 0 | (out of scope) |

## CLI verb-to-domain mapping (12-verb)

| verb | tool delegation | mk2 도메인 cond |
|---|---|---|
| list | tool/manifest_query.hexa list | papers.cond.1 (SSOT read) |
| get | tool/manifest_query.hexa get | papers.cond.1 |
| cite | tool/manifest_query.hexa cite | papers.cond.1 |
| validate | tool/manifest_query.hexa validate | papers.cond.1 |
| verify | tool/doi_verify.hexa | cross_repo_publish.cond.3 |
| publish | tool/zenodo_publish.hexa + osf_publish.hexa | cross_repo_publish.cond.2 |
| pull | (Phase 2 stub) | cross_repo_publish (deferred) |
| search | tool/keyword_search.hexa | papers.cond.2 |
| sync | tool/zenodo_sync.hexa | cross_repo_publish.cond.3 |
| lint | tool/papers_lint.hexa (8-rule own) | papers.cond.1 |
| scan | tool/{meta_scanner,continuous_scan,missing_doi_scan,orphan_paper_scan}.hexa | cross_repo_publish.cond.3 |
| secret | passthrough -> ~/core/secret/bin/secret | (cross-cut, 도메인 외) |

## Recommendation: hive apex `per_repo_override` patch

`hive/spec/mk2_apex.spec.yaml` 의 `per_repo_override` 측에 papers entry 추가 권장.
본 BG scope 는 papers/ 측 additive only — hive apex in-place 변경 X. 사용자 manual update 권장.

권장 patch:

```yaml
    papers:
      raw_format: mk2_inline
      roadmap_format: roadmap_v2_per_domain
      perspective: peer            # peer (content repo, mk2 active 4-repo 외)
      mk: 2
      status: active
      excludes:
        - manifest_schema_breaking_change   # permanent
        - credential_in_repo                # permanent (secret CLI passthrough only)
        - papers_repo_in_mk2_active_4_repo  # permanent (peer trajectory 별도)
      domains:
        - papers
        - cross_repo_publish
        - brainwire
        - sedi
      notes: "4 .roadmap.* peer perspective — additive only, file 구조 마이그레이션 X (manifest.json + bin/papers + project.hexa 기존 SSOT 보존). 2026-05-03 BG-PR land."
```


- **C1** — 기존 single-file SSOT (`manifest.json` 183KB / 433 paper entry) 가 작동 중. raw 270/271/272/273 triplet (core/<도메인>/{source,registry,router,main} + modules/<도메인>/) 으로 재정합 시 대규모 file 구조 변경 필수 — 본 BG 는 additive only 정책으로 마이그레이션 보류. `.roadmap.*` 4개만 신규 land.
- **C2** — `papers_cross_repo_lint v1.2` (commit 2f776b7) 의 grandfather marker SKIP + per-repo exempt mechanism 이 mk2 peer perspective 와 상호작용 미검증. lint 가 `.roadmap.*` 의 excludes entry 를 인식하지 못함 — Phase 2 lint v1.3 에서 mk2 spec 통합 필요.
- **C3** — `tecs-l/` (91 file, n6-* paper + CERN proposal + figures) 의 도메인 정의 ambiguous. `.roadmap.tecs_l` 신규 add 후보 vs `CANON` 와 중복 우려 — 본 BG 는 보류, 다음 cycle 사용자 directive 후 결정.
- **C4** — `papers/anima/`, `papers/canon/`, `papers/nexus/` 가 sister repo 와 이름 중복. mk2 ecosystem 측 `.roadmap.*` (anima 21 / nexus 3 / hexa-lang 1) 는 sister repo 측에 거주 — papers/ 산하 동일 이름 sub-dir 는 paper sub-archive 만 가리키므로 `.roadmap.anima` / `.roadmap.CANON` / `.roadmap.nexus` 신규 add 시 cross-repo name collision 우려. 본 BG 는 brainwire/sedi 만 add (sister repo 측 .roadmap 부재 → 충돌 가능성 0).
- **C5** — `bin/papers` 12-verb 와 raw 270/271/272/273 triplet 의 정합 deferred. 현재 single bash entry + tool/* delegation 구조 유지 — raw 270 router pattern 도입 시 bin/papers refactor 필요 (Phase 3 candidate).
- **C6** — `cross_repo_publish.blk.1` (OSF Phase 2 stub) 가 active blocker. `tool/osf_publish.hexa` 미존재 → `bin/papers publish --target osf` 는 WARN+skip path. dual-archive 완성 시까지 cond.2 unmet 유지.
- **C7** — handoff doc (`docs/papers_mk2_redesign_landed_2026_05_03.ai.md`) 본 land 는 papers/docs/ 에 위치. mk2 ecosystem catalog 측 (hive/spec/mk2_ecosystem_catalog.spec.yaml) 의 `papers` entry 갱신 필요 — 본 BG scope 외, hive 측 BG (BG-CL/BG-PL) 와 file scope 분리 위해 보류.

## Cross-link

- `papers/README.ai.md` (cold-read briefing, 2026-05-02 land)
- `papers/manifest.json` (433-paper SSOT)
- `papers/bin/papers` (12-verb dispatch)
- `hive/spec/mk2_apex.spec.yaml` (per_repo_override → papers entry 권장)
- sister repo `.roadmap.*`: anima 21 / nexus 3 / hexa-lang 1 (cross-repo, 본 repo 외부)
