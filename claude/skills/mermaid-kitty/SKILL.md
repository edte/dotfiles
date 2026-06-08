---
name: mermaid-kitty
description: Render Mermaid graph/flowchart and sequenceDiagram as terminal text via ascii.sh. Use for flowcharts, sequence diagrams, Mermaid examples, or ASCII diagrams.
---

# Mermaid Terminal Text Renderer

## Hard rules

1. **Output is terminal text only.** No PNG, no Kitty overlay, no popup, no image protocol. Box-drawing Unicode is OK; images are not.
2. **Do NOT print the mermaid source code block in the reply.** The user has explicitly rejected source-code echoing. Only the rendered terminal text goes in the reply.
3. **Bash tool result must stay clean.** `ascii.sh` writes rendered text to a temp file and prints only the path on stdout (one line). Do NOT cat / echo the rendered text inside the Bash invocation; use the Read tool on the printed path instead.
4. **Always pipe Mermaid source via STDIN** (the Write tool is sandboxed to the working directory and will refuse `/tmp` paths).
5. **If `ascii.sh` exits non-zero**, write a one-line note in the reply explaining what couldn't be rendered. Do NOT fall back to PNG or print the mermaid source.

## How to invoke

Two-step flow:

```bash
# 1. Render to temp file. stdout is just the file path (one line).
bash ~/.claude/skills/mermaid-kitty/ascii.sh <<'EOF'
graph LR
    A[user] --> B[server]
EOF
```

Then use the Read tool on the printed path to pull the rendered text into context, and embed those lines in the reply inside a plain code fence.

**One diagram = one Bash call.** Don't bundle multiple diagrams into one Bash command with `echo "=== title ==="` separators — the echoed labels pollute the tool result. Multiple diagrams → multiple separate Bash invocations; the tool-result framing already groups them.

## What the renderer supports

| Element | Status |
|---|---|
| `graph` / `flowchart` (LR or TD) | ✅ |
| `sequenceDiagram` | ✅ |
| Rectangular nodes `A[label]` | ✅ only this shape |
| Non-rectangular shapes (`{}`, `(())`, `[()]`, `{{}}`, `>...]`, `[/...\]`) | ⚠️ renders but fragments the graph (each ID occurrence becomes a separate node) — prefer `[label]` |
| Edge labels `-->\|text\|` (English) | ✅ |
| `graph` / `flowchart` edge labels with CJK | ❌ still garbles — use English |
| `sequenceDiagram` messages with CJK | ✅ |
| Node / participant labels with CJK | ✅ patched local CLI handles display width |
| `classDef` / colors / styling | ignored (no color in terminal text) |
| `subgraph` nesting | works but coarse |
| Any other diagram type (class/state/ER/gantt/journey/mindmap/timeline/pie/quadrant/gitGraph) | ❌ not rendered; state unsupported in one line |

## Choosing the diagram type

Terminal text has only two dimensions and no depth — reverse edges and loops collapse onto forward lines and become unreadable. Pick the diagram type by topology:

| Topology | Use |
|---|---|
| Single-direction linear (A→B→C) | `flowchart LR` |
| Pure fan-out (one upstream, many downstream, no merge) | `flowchart TD` or `LR` |
| **Diamond (fan-out + fan-in)** | **`flowchart LR`** — TD's routing crams the vertical pipes of middle columns together and overlaps with the merge edges |
| Decision branches, **no** reverse edges | `flowchart LR` (edge labels `yes`/`no`) |
| Request → response (any back-and-forth between roles) | `sequenceDiagram` ✅ |
| State machine / loops / cycles | `sequenceDiagram`, or split into several small flowcharts |
| Anything with an arrow going "back" to an earlier node | `sequenceDiagram` ✅ |

**Rule of thumb**: if a flowchart would need a reverse edge (e.g. `response`, `result`, `retry`), switch to `sequenceDiagram` — its time-axis layout puts request and response on separate lines without overlap.

## Authoring rules to keep rendering stable

When writing Mermaid for this skill:

- Use only `A[label]` rectangles. Encode "this is a decision" / "this is a database" in the **label text**, not the shape (e.g. `C[鉴权?]`, `F[DB 数据库]`).
- Keep edge labels English: `-->|yes|`, `-->|fail|`, `-->|cache miss|`.
- Node labels can be Chinese.
- Don't use `classDef` or colors — they're stripped.

### sequenceDiagram column widths

The local patched CLI handles CJK and mixed CJK/English participant widths. Long message labels can still exceed the gap between two columns and overwrite lifelines (`│`). No CLI flag (`-x`, `-y`) fixes sequence message spacing.

Keep sequence diagrams readable:
- Keep message labels short (under the column gap).
- Or widen columns by using longer actor display names so the gap grows.
- Or accept the missing `│` — arrows still render correctly.

## Fallback when rendering fails

When `ascii.sh` exits non-zero, write a single line in the reply like:

> (图无法渲染为 ASCII：&lt;reason from stderr&gt;)

Do **not** dump the mermaid source as a fallback — the user has rejected source echoing. No image, no popup, no fancy workaround.

## Exit codes

| Code | Meaning | Fallback |
|---|---|---|
| 0 | Rendered text written | use it |
| 2 | Input missing / empty stdin | fix the call |
| 3 | `mermaid-ascii` binary missing | install + retry, or one-line note |
| 4 | Type not supported by mermaid-ascii | one-line note |
| 5 | mermaid-ascii failed (syntax/render error) | one-line note |

## Prerequisites

- `mermaid-ascii` on `PATH`, or fallback binary at `~/go/bin/mermaid-ascii`.
- Preferred local install uses the patched fork:
  - `gh repo clone edte/mermaid-ascii /tmp/mermaid-ascii-edte`
  - `cd /tmp/mermaid-ascii-edte && go install .`
