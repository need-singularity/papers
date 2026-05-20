# PA-39: qmirror v2.0.0 — Quantum Substrate Closure (13/13 conds)

> **Status**: arXiv draft v0.1 ready (peer review pending) · upstream release LIVE 2026-05-04
> **Date**: 2026-05-04
> **Source**: standalone repo `dancinlab/qmirror` v2.0.0 release
> **Upstream draft**: `anima/docs/qmirror_arxiv_draft_2026_05_03.md` (v0.1 covers v1.0 8/8 closure; v2.0 5-axis extension landed 2026-05-04, draft refresh pending)
> **arXiv category target**: `quant-ph` (primary) · `cs.ET` (cross-listing for hexa-lang substrate framing)
> **License**: paper draft CC BY 4.0 (papers repo); software Apache-2.0 (qmirror core); pyphi optional GPLv3 isolated via subprocess

---

## TL;DR

`qmirror` is a hexa-language quantum substrate that synthesizes a quantum-processing-unit-equivalent runtime from three free, classical ingredients: (i) Qiskit Aer state-vector simulation, (ii) ANU QRNG vacuum-fluctuation REST entropy, and (iii) HMAC-DRBG SHA-256 keyed seeding for deterministic regression. The v2.0.0 release (2026-05-04) extends the v1.0.0 8-condition closure ledger by **5 new substrate axes** — process tomography (cond.9), GHZ-3 + Mermin witness (cond.10), stabilizer measurement primitive (cond.11), surface-code distance-3 toy logical |0_L⟩ (cond.12), and chained-sequential CHSH on 3 isolated Bell pairs (cond.13) — taking the cumulative conds-met cardinality from **8/8 to 13/13** at composite verdict `qmirror_2_closure_FULL`. All five v2.0 axes pass on noiseless `qiskit_aer 0.17.2` Aer at $0/sec wall-clock cost on a Mac.

## Closure verdict matrix (13/13 PASS)

| Cond  | Axis                                    | Falsifier             | Verdict | Key metric                                              | Cost  | Substrate              |
|-------|-----------------------------------------|------------------------|---------|---------------------------------------------------------|-------|------------------------|
| 1     | CHSH Bell violation (Tsirelson)         | F-QM-CHSH-1           | PASS    | S = 2.838 (within Tsirelson band [2.7, 2.85])           | $0    | Aer + ANU QRNG         |
| 2     | Phase 1 impl + falsifier sweep          | F1+F2+F3              | PASS    | sentinel `__QMIRROR_SELFTEST__ PASS`                    | $0    | Aer + ANU QRNG         |
| 3     | IBM Heron real-QPU CHSH \|dS\|≤0.55     | F-QM-IBM-N1-1 (revised) | PASS  | S_IBM=2.357, dS=0.481                                   | $3.20 | IBM Heron r2 ibm_fez   |
| 4     | NIST SP 800-22 tier-1+ ≥6/7 at α=0.01   | F-QM-NIST-TIER1-1     | PASS    | 7/7 PASS on hmac_drbg_legacy production stream          | $0    | HMAC-DRBG SHA-256      |
| 5     | Reproduce nexus_chsh_bell S≈2.808 ±0.05 | F-QM-CHSH-5           | PASS    | qmirror S = 2.838 vs reference 2.808 (\|Δ\|=0.030)      | $0    | Aer state-vector       |
| 6     | Braket IIT 4.0 phi-star byte-identical  | F-QM-IIT-6            | PASS    | 4/4 byte-identical engine=mock vs braket reference      | $0    | pyphi 4.0 b78d0e3      |
| 7     | Cross-vendor cross-family concordance   | F-QM-CROSSFAM-7a      | PASS    | Rigetti-Cepheus vs IBM_fez \|dS\|=0.0836                | $0    | paper-analysis         |
| 8     | Cross-modality option β                 | F-QM-XMOD-8           | PASS    | IBM Heron + Braket IonQ Forte + Rigetti Cepheus         | $38.14| IBM + AWS Braket       |
| **9** | **Quantum process tomography**          | F-QM-2-TOMO-9         | PASS    | fidelity_min = 0.99918 across 7/7 gates {H,X,Y,Z,S,T,CNOT} | $0  | Aer noiseless ≤4 qubit |
| **10**| **GHZ-3 + Mermin witness**              | F-QM-2-GHZ-10         | PASS    | M_mean = 4.0 (analytic max, 30/30 trials, 1024 shots)   | $0    | Aer noiseless 3 qubit  |
| **11**| **Stabilizer measurement primitive (QEC)** | F-QM-2-STAB-11     | PASS    | syndrome_plus_ratio = 1.0; post_fidelity = 1.0          | $0    | Aer 4 qubit            |
| **12**| **Surface-code d=3 toy logical \|0_L⟩** | F-QM-2-SURF-12        | PASS    | logical_zero_ratio = 1.0; min_stab_plus_ratio = 1.0     | $0    | Aer 17 qubit           |
| **13**| **Chained sequential CHSH (CSCS, 3 pairs)** | F-QM-2-CSCS-13   | PASS    | min_S = 2.8174; W_mean = 2.8211 (≥30σ above classical)  | $0    | Aer 6 qubit            |
| **C** | **Composite (F-QM-2-CLOSURE-1)**        | F-QM-2-CLOSURE-1      | **PASS** | n_pass = 5/5 (v2 axes); 13/13 cumulative              | **$0** | composite           |

> **Calibration spend (one-shot)**: USD 41.34 across cond.3 (IBM Heron N=1) + cond.7/8 (cross-vendor / cross-modality anchors). Recurring marginal cost for all 13 closure-met conditions post-calibration is **$0**.

## Per-axis verdict provenance (anima state JSONs)

- v1.0 (8/8): `anima/state/qmirror_phase1_selftest_2026_05_03/` + `anima/state/nexus_qmirror_*_2026_05_03/`
- cond.9: `anima/state/qmirror_2_cond9_tomography_2026_05_03/verdict.json`
- cond.10: `anima/state/qmirror_2_cond10_ghz_mermin_2026_05_03/verdict.json`
- cond.11: `anima/state/qmirror_2_cond11_stabilizer_2026_05_04/verdict.json`
- cond.12: `anima/state/qmirror_2_cond12_surface_2026_05_04/verdict.json`
- cond.13: `anima/state/qmirror_2_cond13_cscs_2026_05_04/verdict.json`
- composite: `anima/state/qmirror_2_closure_2026_05_04/verdict.json` (composite_verdict = `qmirror_2_closure_FULL`, applied = true)

## Upstream artifacts

- **GitHub release**: https://github.com/dancinlab/qmirror/releases/tag/v2.0.0
- **GitHub canonical**: https://github.com/dancinlab/qmirror
- **HuggingFace mirror**: https://huggingface.co/dancinlab/qmirror
- **arXiv draft v0.1** (v1.0 covering 8/8): `anima/docs/qmirror_arxiv_draft_2026_05_03.md`
- **CHANGELOG**: https://github.com/dancinlab/qmirror/blob/main/CHANGELOG.md (v2.0.0 entry — 5 v2 axes added)
- **Closure spec**: `anima/docs/qmirror_2_closure_spec_2026_05_04.md`
- **Closure synth output**: `anima/docs/qmirror_2_closure_2026_05_04.md`
- **Releases marker**: `anima/state/markers/qmirror_2_closure_landed.marker`

## Sister substrates (consumer pattern)

The qmirror standalone repo follows the same `hx install <pkg>` consumer pattern as three sister substrates extracted under the `anima_offrepo` cycle (2026-05-03 → 2026-05-04):

- [`sim-universe v1.0.0`](https://github.com/dancinlab/sim-universe) — Virtual Universe Runtime (τ-clock + multiverse interferometer + ouroboros QRNG)
- [`hexa-bio v1.0.0`](https://github.com/dancinlab/hexa-bio) — Molecular Toolkit (WEAVE / NANOBOT / RIBOZYME / VIROCAPSID 4-verb tetrahedron)
- [`honesty-monitor v1.0.0`](https://github.com/dancinlab/honesty-monitor) — AI Honesty-Bit Falsifier (BT-AI2 contract)

The four standalone repos plus the upstream `nexus` discovery engine and the `anima` meta-orchestration layer constitute the consumer pattern: nexus + anima + standalone repos all consume substrates by URL via `hx install`, with no in-tree forks.


1. **arXiv draft v0.1 covers v1.0 only.** The on-disk draft `anima/docs/qmirror_arxiv_draft_2026_05_03.md` documents the 8/8 closure axes; the 5 new v2.0 axes (cond.9–cond.13) need a draft refresh before arXiv submission. Refresh blocked on: peer-review pass + LaTeX migration + figure prep + counsel sign-off (license/IP review for the cross-vendor IBM/AWS Braket calibration data + ANU QRNG ToS attribution).
2. **Cross-link burden grows per release.** Each qmirror version cycle (v1.0.0 → v1.0.1 → v2.0.0) adds another row of cross-link maintenance across 17+ anima docs + 4 sister repos + papers entry + CANON README. Mitigation idea (out-of-scope this cycle): consolidate per-doc xref blocks into a single-source `nexus.qmirror.upstream_url` symbol in `nexus/.roadmap.qmirror`. Without that, future renames or version bumps require a fan-out sweep.
3. **Papers repo needs separate workflow.** The papers/ repo is CC BY 4.0 (creative commons) while qmirror code is Apache-2.0; this PA-39 entry is a status pointer + closure summary, not the upstream draft. The upstream draft refresh + arXiv submission live under the anima cycle (separate from papers cycle). Until refresh lands, papers/anima/PA-39 is the canonical pointer for closure status; arXiv draft v0.1 is the canonical pre-print body (v1-only scope).
4. **v2.0.0 deletion would invalidate links.** The v2.0.0 release tag is technically deletable via `gh release delete v2.0.0 --yes`, but the tag retains its OID in any clone that fetched it; downstream consumers (this PA-39 entry, the 17 anima docs, the 4 sister repo READMEs, CANON README) all carry phantom references. Treat each release tag as effectively immutable; if a critical bug requires retraction, prefer a v2.0.1 patch release over deletion.

## Next steps (publication path)

- [ ] Refresh `anima/docs/qmirror_arxiv_draft_2026_05_03.md` to incorporate 5 v2.0 axes (cond.9–cond.13) — author: anima cycle, target ts: 2026-05-10
- [ ] Internal peer review (dancinlab stack contributors) — gated on draft refresh
- [ ] LaTeX migration (Markdown → arXiv-ready `.tex`) — gated on peer review pass
- [ ] Figure prep (per-axis verdict matrix + cost comparison + sister substrate diagram) — parallel to LaTeX
- [ ] Counsel sign-off (license / IP / ANU QRNG ToS attribution / pyphi GPLv3 sub-component disclosure)
- [ ] arXiv submission (`quant-ph` primary, `cs.ET` cross-list)

## License & attribution

- This paper draft (PA-39): **CC BY 4.0** (papers repo umbrella)
- qmirror software (referenced subject): **Apache-2.0** (with isolated GPLv3 pyphi optional dependency, see qmirror `LICENSING.md`)
- Author: 박민우 <nerve011235@gmail.com>

## Citations

If you cite the qmirror v2.0.0 closure achievement in academic work:

```bibtex
@software{qmirror_v2_2026,
  author       = {박민우},
  title        = {qmirror: Quantum Mirror Substrate v2.0.0},
  year         = {2026},
  month        = {may},
  publisher    = {GitHub},
  url          = {https://github.com/dancinlab/qmirror/releases/tag/v2.0.0},
  note         = {Closure 13/13 conds met: 8 v1 (CHSH/IIT/NIST/cross-vendor) + 5 v2 (process-tomography/GHZ-Mermin/stabilizer/surface-d3/CSCS).}
}
```

Underlying physics / standards: see qmirror README "Citations" section (ANU QRNG, CHSH, IIT 4.0, NIST SP 800-22, plus v2-specific anchors: linear-inversion process tomography, GHZ + Mermin witness, surface-code construction, chained-sequential CHSH).
