---
name: ftc
description: Build pixel-perfect components from images or Figma using HTML + TailwindCSS
allowed-tools: [Bash, Read, Write, Edit, Glob, Grep]
---

# /ftc: Figma/Image to Code

Build pixel-perfect HTML + TailwindCSS components from images or Figma designs.

## Phase 0: Setup & Configuration

### 1. Chrome Extension
Verify Chrome extension is connected using `tabs_context_mcp`.
- If not connected: "Run `claude --chrome` to enable Chrome integration."

### 2. Figma MCP Setup
Check if Figma MCP is available and authenticated:

**If not configured:**
1. Tell user: "Figma MCP is not configured. Let me help you set it up."
2. Instruct: Run `/mcp` in Claude Code
3. If figma not listed: Run `claude mcp add --transport http figma https://mcp.figma.com/mcp`
4. Run `/mcp` again to verify it appears

**If configured but needs auth (shows ⚠ Warning):**
1. Tell user: "Figma MCP needs authentication."
2. Instruct: Run `/mcp` → Select "figma" → Select "Authenticate"
3. User clicks "Allow Access" in browser popup
4. Verify: Should show "Authentication successful. Connected to figma."

**If authenticated:**
- Proceed to Phase 1

### 3. Verify Connection
Once authenticated, test with `whoami` to confirm Figma MCP works.

**Note**: Figma MCP is optional - the skill works with local images too. Skip Figma setup if user only has local images.

---

## Workflow "3 Ojos"

Este skill funciona mejor con 3 fuentes de información en paralelo:

| Ojo | Fuente | Uso |
|-----|--------|-----|
| 👁️ MCP | Figma API | Datos precisos: colores hex, fonts, spacing en px |
| 👁️ Chrome Tab 1 | Figma visual | Referencia visual, zoom, inspección manual |
| 👁️ Chrome Tab 2 | HTML output | Ver resultado renderizado, comparar |

**Setup de tabs:**
1. Obtener contexto: `tabs_context_mcp`
2. Tab existente de Figma o crear uno para referencia visual
3. Crear tab para output: `tabs_create_mcp`

---

## Phase 1: Get Reference

**Ask the user**: "Do you have a local image or a Figma link?"

### Option A: Local Image
- User provides path to PNG, JPG, or other image file
- Read the image using the Read tool (it supports images)
- Analyze: colors, layout, typography, spacing, shadows, borders

### Option B: Figma Link
- If Figma MCP is configured and authenticated, use it to extract design data:
  - `get_metadata` → estructura y node IDs del componente
  - `get_design_context` → código generado + URLs de assets
  - `get_screenshot` → captura visual del nodo
  - `get_variable_defs` → design tokens (colores, spacing)
- If not configured or needs auth: Go back to Phase 0 Step 2 to complete setup
- Alternative: User can take a screenshot of the Figma design and provide it as a local image

### Usando Assets de Figma

`get_design_context` devuelve URLs de imágenes/iconos:
```javascript
// URLs temporales válidas por 7 días
const imgLogo = "https://www.figma.com/api/mcp/asset/uuid-here";
```
- Usar directo en `<img src="...">`
- Incluye: screenshots, iconos SVG exportados, imágenes
- No necesitas descargar los archivos

---

## Phase 2: Implement

### 1. Create Output File
Create `output.html` in the current directory with TailwindCSS CDN:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Component Preview</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center p-8">
  <!-- Component goes here -->
</body>
</html>
```

### 2. Analyze the Reference Image
Extract from the image:
- **Colors**: Background, text, borders, shadows (use exact hex values)
- **Typography**: Font size, weight, line height
- **Layout**: Flexbox/grid structure, alignment, gaps
- **Spacing**: Padding, margin (estimate in Tailwind units: 1=4px, 2=8px, etc.)
- **Borders**: Radius, width, color
- **Shadows**: Size and color
- **Icons**: Describe or use placeholder SVG

### 3. Generate HTML + Tailwind
Write clean, semantic HTML with Tailwind classes. Prefer:
- Flexbox (`flex`, `items-center`, `justify-between`)
- Tailwind spacing (`p-4`, `m-2`, `gap-3`)
- Tailwind colors (`bg-blue-500`, `text-gray-700`)
- Custom colors when needed via inline style or Tailwind arbitrary values (`bg-[#1a1a2e]`)

---

## Phase 3: Compare and Refine

### 1. Start Local Server
`file://` URLs do NOT work with Chrome extension. Start a local server:

```bash
python3 -m http.server 8888
```

### 2. Open in Chrome
Navigate Chrome to `http://localhost:8888/output.html`

### 3. Screenshot the Result
Take a screenshot of the rendered component.

### 4. Compare with Reference
Visually compare the screenshot with the original image:
- Check spacing matches
- Check colors are accurate
- Check typography looks right
- Check shadows and borders

### 5. Refinement Loop
If there are differences:
1. Identify what's wrong (e.g., "padding is too large", "color is off")
2. Edit the HTML to fix it
3. Refresh and screenshot again
4. Repeat until pixel-perfect

---

## Phase 4: Deliver

**Show the user**:
- The final `output.html` path
- A screenshot of the result

**Ask**: "Here's the component. Does it need any adjustments?"

If user requests changes, go back to Phase 3.

---

## Limitaciones

### Figma MCP Rate Limits
- ~50 requests/minuto aproximadamente
- Si se alcanza el límite: usar Chrome visual como fallback
- El límite se resetea automáticamente

### Design Context Size
- Puede ser muy grande (>50KB) para páginas completas
- Para componentes específicos: usar node ID del componente, no de la página
- Extraer el node ID del URL de Figma: `?node-id=123-456` → `123:456`

---

## Guidelines

- **Be precise**: Match colors exactly, not approximately
- **Use Tailwind utilities**: Avoid custom CSS unless absolutely necessary
- **Keep it simple**: Don't over-engineer, just match the design
- **Iterate quickly**: Small changes, frequent screenshots
- **Ask when unsure**: If something in the design is ambiguous, ask the user

## Example Workflow

```
User: /ftc
Claude: Do you have a local image or a Figma link?
User: https://www.figma.com/design/abc123/MyFile?node-id=1-234
Claude: [Starts local server, opens Chrome tabs]
Claude: [Gets design context from Figma MCP]
Claude: I see a card with #1a1a2e background, 16px padding, Inter font. Let me create it.
Claude: [Creates output.html with asset URLs from Figma]
Claude: [Opens localhost:8888 in Chrome, takes screenshot]
Claude: [Compares, adjusts spacing]
Claude: Here's the final result. Does it match what you need?
```
