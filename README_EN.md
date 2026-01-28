# Figma to Code

Pixel-perfect Figma to code, powered by Claude.

[Version en espanol](README.md)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/blissito/figma-to-code/main/install.sh | bash
```

## Use

```bash
claude --chrome --dangerously-skip-permissions
```

Then type `/ftc`

## Supported Frameworks

| Framework | Output |
|-----------|--------|
| Next.js | `ComponentName.tsx` |
| React | `ComponentName.jsx` / `.tsx` |
| Vue | `ComponentName.vue` |
| Svelte | `ComponentName.svelte` |
| Angular | `component.ts` + `component.html` |
| Astro | `ComponentName.astro` |
| No framework | `output.html` |

The skill auto-detects your project's framework.

## Requirements

- [Claude Code](https://claude.ai/code) Pro/Team/Enterprise
- [Claude in Chrome](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) extension

---

By [@blissito](https://github.com/blissito) - [fixtergeek.com](https://fixtergeek.com)
