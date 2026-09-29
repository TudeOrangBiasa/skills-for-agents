# Skills Flow

Peta skill repo ini: daftar + alur idea to ship.

## Daftar skill (28)

**User-invoked (15)**, diketik manual: guide, discuss, discuss-with-docs, implement, improve-codebase-architecture, loop-me, retro, setup-meta, setup-ts-deep-modules, teach, to-spec, to-tickets, triage, wait-what, wayfinder.

**Model-invoked (13)**, agent bisa panggil sendiri: codebase-design, code-review, diagnosing-bugs, domain-modeling, interview, pr, prototype, research, resolving-merge-conflicts, setup-pre-commit, tdd, wizard, writing-for-agents.

## Main flow: idea to ship

```mermaid
flowchart TD
    SETUP["/setup-meta<br/>sekali per repo: tracker + label + domain + DESIGN + standards + husky"]

    SETUP -. prasyarat .-> GRILL
    GRILL["1. /discuss-with-docs<br/>interview + bangun GLOSSARY + ADR"]
    GRILL --> QPROTO{"Butuh jawaban<br/>runnable?"}
    QPROTO -- Ya --> PROTO["/prototype<br/>throwaway, jawab 1 pertanyaan desain"]
    PROTO --> QSIZE
    QPROTO -- Tidak --> QSIZE{"Multi-session?"}
    QSIZE -- Ya --> SPEC["/to-spec<br/>sintesis thread jadi spec"]
    SPEC --> TICKETS["/to-tickets<br/>tracer-bullet + blocking edges"]
    TICKETS --> IMPL["/implement per ticket<br/>fresh context tiap ticket"]
    QSIZE -- Tidak --> IMPL

    IMPL --> TDD["/tdd di dalam<br/>red-green per slice, before/after wajib"]
    TDD --> REVIEW["/code-review<br/>Standards + Spec paralel"]
    REVIEW --> PRB["PR body format /pr<br/>Summary + Evidence + Merge Danger"]
    PRB --> COMMIT["commit"]

    subgraph ONRAMP["On-ramp"]
        TRIAGE["/triage<br/>laporan mentah jadi agent-ready"]
        DIAG["/diagnosing-bugs<br/>red loop dulu baru hipotesis"]
        WAY["/wayfinder<br/>peta decision tickets"]
    end
    TRIAGE -.-> IMPL
    DIAG -.-> IMPL
    WAY -.-> SPEC

    subgraph UPKEEP["Rawat"]
        IMPROVE["/improve-codebase-architecture<br/>survey deepening"]
        RETRO["/retro<br/>meta docs anti-stale + pattern"]
    end
    IMPROVE -. "ide baru" .-> GRILL
    RETRO -. "refresh" .-> SETUP

    subgraph VOCAB["Di bawah semua"]
        INT["/interview<br/>primitif"]
        DM["/domain-modeling<br/>bahasa domain"]
        CD["/codebase-design<br/>deep module"]
    end

    subgraph STAND["Berdiri sendiri"]
        D["/discuss"]
        T["/teach"]
        W["/wait-what<br/>repitch visual"]
        WZ["/wizard"]
        RMC["/resolving-merge-conflicts"]
    end
```

## Catatan

- `/handoff` dan `/to-questionnaire` sudah dihapus. Jembatan antar session pakai portable note tulisan tangan.
- `implement` satu pintu: pick spec/tiket, TDD before/after wajib, review wajib, PR format `pr`, commit.
- `setup-meta` gerbang gemuk: tracker + DESIGN + standards + husky.
- Context hygiene: grill sampai `to-tickets` satu window utuh; tiap `implement` mulai fresh.
