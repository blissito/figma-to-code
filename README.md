# Figma to Code

Pixel-perfect de Figma a codigo, con Claude.

[![Video demo](https://img.youtube.com/vi/x2XNarpSDrI/maxresdefault.jpg)](https://youtu.be/x2XNarpSDrI)

[English version](README_EN.md)

## Instalar

```bash
curl -fsSL https://raw.githubusercontent.com/blissito/figma-to-code/main/install.sh | bash
```

## Usar

```bash
claude --chrome --dangerously-skip-permissions
```

Luego escribe `/ftc`

## Frameworks soportados

| Framework | Output |
|-----------|--------|
| Next.js | `ComponentName.tsx` |
| React | `ComponentName.jsx` / `.tsx` |
| Vue | `ComponentName.vue` |
| Svelte | `ComponentName.svelte` |
| Angular | `component.ts` + `component.html` |
| Astro | `ComponentName.astro` |
| Sin framework | `output.html` |

El skill detecta automaticamente el framework de tu proyecto.

## Requisitos

- [Claude Code](https://claude.ai/code) Pro/Team/Enterprise
- [Claude in Chrome](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn) extension

---

Por [@blissito](https://github.com/blissito) - [fixtergeek.com](https://fixtergeek.com)
