# Figma to Code

Build pixel-perfect components from Figma designs or images using HTML + TailwindCSS.

## Install

```bash
# Add the marketplace (only once)
claude plugin marketplace add blissito/figma-to-code

# Install the plugin
claude plugin install figma-to-code@blissito
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
/ftc
```

## How it works

1. Provide a Figma link or local image
2. Claude analyzes colors, typography, spacing
3. Generates HTML + TailwindCSS
4. Opens in Chrome, compares with reference
5. Iterates until pixel-perfect

## License

MIT
