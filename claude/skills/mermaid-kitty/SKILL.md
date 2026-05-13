---
name: mermaid-kitty
description: Render Mermaid flowcharts and sequence diagrams as plain ASCII art inline in Claude Code responses. Invoke whenever the answer would include a Mermaid diagram. Pipe source via STDIN. If the diagram cannot be rendered as ASCII (unsupported type, non-rectangular node shapes, or render failure), DO NOT pop any image window — just emit a plain ```mermaid code block in the reply and explain in prose. User explicitly does not want image/overlay/PNG rendering.
---

# Mermaid ASCII Renderer

## Hard rules

1. **Output is ASCII only.** No PNG, no Kitty overlay, no popup, no image protocol. The user has explicitly rejected image rendering — never reintroduce it.
2. **If `ascii.sh` exits non-zero, the fallback is a plain ` ```mermaid ` code block** with a one-line note explaining what couldn't be rendered. Do NOT try mmdc, kitten icat, browsers, or anything else.
3. **Always pipe via STDIN** (the Write tool is sandboxed to the working directory and will refuse `/tmp` paths).
4. **After rendering, copy the ASCII into the assistant message body** inside a fenced block — the user reads your reply, not collapsed Bash tool results.

## How to invoke

```bash
bash ~/.claude/skills/mermaid-kitty/ascii.sh <<'EOF'
graph LR
    A[user] --> B[server]
EOF
```

**One diagram = one Bash call.** Don't bundle multiple diagrams into one Bash command with `echo "=== title ==="` separators — the echoed labels pollute the tool result. Multiple diagrams → multiple separate Bash invocations; the tool-result framing already groups them.

## What ASCII supports

| Element | Status |
|---|---|
| `graph` / `flowchart` (LR or TD) | ✅ |
| `sequenceDiagram` | ✅ |
| Rectangular nodes `A[label]` | ✅ only this shape |
| Non-rectangular shapes (`{}`, `(())`, `[()]`, `{{}}`, `>...]`, `[/...\]`) | ⚠️ renders but fragments the graph (each ID occurrence becomes a separate node) — prefer `[label]` |
| Edge labels `-->\|text\|` (English) | ✅ |
| Edge labels with CJK | ❌ byte-width bug, garbles — use English |
| Node labels with CJK | ✅ rune-aware |
| `classDef` / colors / styling | ignored (no color in ASCII) |
| `subgraph` nesting | works but coarse |
| Any other diagram type (class/state/ER/gantt/journey/mindmap/timeline/pie/quadrant/gitGraph) | ❌ fall back to plain mermaid block |

## Choosing the diagram type (ASCII-friendly)

ASCII has only two dimensions and no depth — reverse edges and loops collapse onto forward lines and become unreadable. Pick the diagram type by topology:

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

## Authoring rules to keep ASCII working

When writing Mermaid for this skill:

- Use only `A[label]` rectangles. Encode "this is a decision" / "this is a database" in the **label text**, not the shape (e.g. `C[鉴权?]`, `F[DB 数据库]`).
- Keep edge labels English: `-->|yes|`, `-->|fail|`, `-->|cache miss|`.
- Node labels can be Chinese.
- Don't use `classDef` or colors — they're stripped.

### sequenceDiagram column widths

Column width is determined by the **actor name length** (`participant X as <name>`). Long message labels that exceed the gap between two columns will **overflow and eat the `│` of any column they cross** — a layout bug in mermaid-ascii. No CLI flag (`-x`, `-y`) fixes this for sequence diagrams.

Workarounds:
- Keep message labels short (under the column gap).
- Or widen columns by using longer actor display names so the gap grows.
- Or accept the missing `│` — arrows still render correctly.

## Fallback template

When `ascii.sh` exits non-zero, emit this in the reply:

````
（图无法渲染为 ASCII：<reason from stderr>，给出源码：）

```mermaid
<original mermaid source>
```
````

No image, no popup, no fancy workaround.

## Exit codes

| Code | Meaning | Fallback |
|---|---|---|
| 0 | ASCII printed | use it |
| 2 | Input missing / empty stdin | fix the call |
| 3 | `mermaid-ascii` binary missing | install + retry, or plain block |
| 4 | Type not supported by mermaid-ascii | plain ` ```mermaid ` block |
| 5 | mermaid-ascii failed (syntax) | plain ` ```mermaid ` block |

## Prerequisites

- `mermaid-ascii` binary at `~/go/bin/mermaid-ascii`
  - Install: `GOPROXY=https://proxy.golang.org,direct go install github.com/AlexanderGrooff/mermaid-ascii@latest`
