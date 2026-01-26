# Figma to Code

Build pixel-perfect components from Figma designs or images using HTML + TailwindCSS.

## Install

```bash
claude plugin install github:blissito/figma-to-code
```

## Requirements

- Claude Code v2.0.73+
- Claude in Chrome extension v1.0.36+
- Figma MCP (optional)

## Usage

```bash
claude --chrome
```

Then:

```
/figma-to-code:ftc
```

## How it works

1. Provide a Figma link or local image
2. Claude analyzes colors, typography, spacing
3. Generates HTML + TailwindCSS
4. Opens in Chrome, compares with reference
5. Iterates until pixel-perfect

## License

MIT
