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
- Figma MCP (optional, for Figma links)
- Plan Pro/Team/Enterprise

## Setup Figma MCP

```bash
claude mcp add --transport http figma https://mcp.figma.com/mcp
```

Authentication happens automatically on first use.

## Usage

```bash
claude --chrome
```

Then:

```
/ftc
```

## How it works

### Workflow "3 Ojos"

The skill uses 3 information sources in parallel:

| Eye | Source | Purpose |
|-----|--------|---------|
| MCP | Figma API | Precise data: hex colors, fonts, spacing in px |
| Chrome Tab 1 | Figma visual | Visual reference, zoom, manual inspection |
| Chrome Tab 2 | HTML output | Rendered result, comparison |

### Process

1. Provide a Figma link or local image
2. Claude extracts design data via Figma MCP
3. Generates HTML + TailwindCSS
4. Starts local server (`python3 -m http.server 8888`)
5. Opens in Chrome, compares with reference
6. Iterates until pixel-perfect

### Figma MCP Tools Used

| Tool | Purpose |
|------|---------|
| `get_metadata` | Component structure, node IDs |
| `get_design_context` | Generated code + asset URLs |
| `get_screenshot` | Visual capture of node |
| `get_variable_defs` | Design tokens (colors, spacing) |

### Asset URLs

`get_design_context` returns temporary image URLs (valid 7 days):
```javascript
const img = "https://www.figma.com/api/mcp/asset/uuid";
// Use directly in <img src="...">
```

## Limitations

- **Rate limits**: ~50 requests/min on Figma MCP
- **file:// URLs**: Don't work with Chrome extension, use localhost
- **Large designs**: Use specific node IDs, not full pages

## License

MIT
