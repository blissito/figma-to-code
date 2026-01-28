---
name: ftc
description: Build pixel-perfect components from images or Figma using HTML + TailwindCSS
allowed-tools: [Bash, Read, Write, Edit, Glob, Grep]
---

# /ftc: Figma to Code

Build pixel-perfect components from Figma designs. Supports multiple frameworks.

**Requirements:**
- Figma MCP must be configured and authenticated
- Chrome extension must be connected

## Phase 0: Setup & Verification

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

**If configured but needs auth (shows Warning):**
1. Tell user: "Figma MCP needs authentication."
2. Instruct: Run `/mcp` -> Select "figma" -> Select "Authenticate"
3. User clicks "Allow Access" in browser popup
4. Verify: Should show "Authentication successful. Connected to figma."

### 3. Verify Connection
Once authenticated, test with `whoami` to confirm Figma MCP works.

**MANDATORY: Figma MCP MUST be configured and authenticated before proceeding.**

---

## Phase 0.5: Project Discovery

### 1. Detect Project Framework

Scan the current directory for framework indicators:

| Framework | Detection |
|-----------|-----------|
| Next.js | `next.config.*` OR `package.json` has `"next"` |
| React | `package.json` has `"react"` (without Next) |
| Vue | `vite.config.*` + `vue` OR `package.json` has `"vue"` |
| Svelte | `svelte.config.js` OR `package.json` has `"svelte"` |
| Angular | `angular.json` OR `package.json` has `"@angular/core"` |
| Astro | `astro.config.*` OR `package.json` has `"astro"` |
| None | Fallback to static HTML |

### 2. Detect TypeScript
- `tsconfig.json` exists -> use `.tsx`/`.ts` extensions
- Otherwise -> use `.jsx`/`.js` extensions

### 3. Detect Styling
- **Tailwind**: `tailwind.config.*` or `tailwindcss` in package.json
- **CSS Modules**: files ending in `.module.css`
- **styled-components**: `styled-components` in package.json
- **Emotion**: `@emotion/*` in package.json

### 4. Detect Component Location
Look for existing component directories:
- `src/components/`
- `components/`
- `app/components/` (Next.js App Router)
- `src/app/` (Next.js)

### 5. Detect Dev Server Port
- **Vite**: 5173 (check `vite.config.*`)
- **Next.js**: 3000
- **Vue CLI**: 8080
- **Angular**: 4200
- **Astro**: 4321
- **Static HTML**: 8888 (python http.server)

**Store detected values:**
```
FRAMEWORK: [next|react|vue|svelte|angular|astro|html]
TYPESCRIPT: [true|false]
STYLING: [tailwind|css-modules|styled-components|emotion|css]
COMPONENTS_DIR: [path]
DEV_PORT: [number]
```

---

## Workflow "3 Ojos"

Este skill funciona mejor con 3 fuentes de informacion en paralelo:

| Ojo | Fuente | Uso |
|-----|--------|-----|
| MCP | Figma API | Datos precisos: colores hex, fonts, spacing en px |
| Chrome Tab 1 | Figma visual | Referencia visual, zoom, inspeccion manual |
| Chrome Tab 2 | Output | Ver resultado renderizado, comparar |

**Setup de tabs:**
1. Obtener contexto: `tabs_context_mcp`
2. Tab existente de Figma o crear uno para referencia visual
3. Crear tab para output: `tabs_create_mcp`

---

## Phase 1: Get Figma Reference & Component Info

### 1. Ask for Figma Link
**Ask the user**: "Paste the Figma link to the component you want to build."

### 2. Ask for Component Details
**Ask the user**:
- "What should I name this component? (e.g., `HeroSection`, `PricingCard`)"
- "Where should I create it? (e.g., `src/components/`, `./`)"

If user doesn't specify location, suggest based on `COMPONENTS_DIR` detected in Phase 0.5.

### 3. Extract Design Data from Figma MCP
Use Figma MCP to extract all design data:
- `get_metadata` -> estructura y node IDs del componente
- `get_design_context` -> codigo generado + URLs de assets
- `get_screenshot` -> captura visual del nodo
- `get_variable_defs` -> design tokens (colores, spacing)

**If MCP is not configured or needs auth:** STOP. Go back to Phase 0 and complete setup first.

### Usando Assets de Figma

`get_design_context` devuelve URLs de imagenes/iconos:
```javascript
// URLs temporales validas por 7 dias
const imgLogo = "https://www.figma.com/api/mcp/asset/uuid-here";
```
- Usar directo en `<img src="...">`
- Incluye: screenshots, iconos SVG exportados, imagenes
- No necesitas descargar los archivos

---

## Phase 2: Implement

### Framework-Specific Output

Based on `FRAMEWORK` detected in Phase 0.5:

#### Next.js / React

Create `{COMPONENTS_DIR}/{ComponentName}.{tsx|jsx}`:

```jsx
export default function ComponentName() {
  return (
    <div className="...">
      {/* Component content */}
    </div>
  )
}
```

#### Vue

Create `{COMPONENTS_DIR}/{ComponentName}.vue`:

```vue
<template>
  <div class="...">
    <!-- Component content -->
  </div>
</template>

<script setup>
// Component logic if needed
</script>
```

#### Svelte

Create `{COMPONENTS_DIR}/{ComponentName}.svelte`:

```svelte
<div class="...">
  <!-- Component content -->
</div>

<style>
  /* Only if not using Tailwind */
</style>
```

#### Angular

Create `{COMPONENTS_DIR}/{component-name}/`:
- `{component-name}.component.ts`
- `{component-name}.component.html`

```typescript
// component-name.component.ts
import { Component } from '@angular/core';

@Component({
  selector: 'app-component-name',
  templateUrl: './component-name.component.html',
})
export class ComponentNameComponent {}
```

#### Astro

Create `{COMPONENTS_DIR}/{ComponentName}.astro`:

```astro
---
// Component logic
---

<div class="...">
  <!-- Component content -->
</div>
```

#### Static HTML (fallback)

Create `output.html` in current directory:

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

### Analyze the Reference Image
Extract from the image:
- **Colors**: Background, text, borders, shadows (use exact hex values)
- **Typography**: Font size, weight, line height
- **Layout**: Flexbox/grid structure, alignment, gaps
- **Spacing**: Padding, margin (estimate in Tailwind units: 1=4px, 2=8px, etc.)
- **Borders**: Radius, width, color
- **Shadows**: Size and color
- **Icons**: Describe or use placeholder SVG

### Generate Code
Write clean, semantic code with appropriate styling. Prefer:
- Flexbox (`flex`, `items-center`, `justify-between`)
- Tailwind spacing (`p-4`, `m-2`, `gap-3`)
- Tailwind colors (`bg-blue-500`, `text-gray-700`)
- Custom colors when needed via inline style or Tailwind arbitrary values (`bg-[#1a1a2e]`)

---

## Phase 3: Compare and Refine

### 1. Start/Verify Dev Server

**For frameworks (React, Next, Vue, Svelte, Angular, Astro):**
- Check if dev server is already running on `DEV_PORT`
- If not running, suggest user starts it: `npm run dev` / `yarn dev` / etc.

**For static HTML:**
- Start local server: `python3 -m http.server 8888`

### 2. Open in Chrome

**For frameworks:**
- Navigate to the component's route/page in the dev server
- Or create a simple test page that imports the component

**For static HTML:**
- Navigate Chrome to `http://localhost:8888/output.html`

### 3. Screenshot the Result
Take a screenshot of the rendered component.

### 4. Compare with Reference
Visually compare the screenshot with the original image:
- Check spacing matches
- Check colors are accurate
- Check typography looks right
- Check shadows and borders

### 5. Refinement Loop (MANDATORY - DO NOT SKIP)

**CRITICAL: NEVER abandon this loop until the result is IDENTICAL to the design.**

If there are ANY differences, no matter how small:
1. Identify what's wrong (e.g., "padding is too large", "color is off", "1px misalignment")
2. Edit the component file to fix it
3. Refresh and screenshot again
4. Compare again with extreme attention to detail
5. **REPEAT until pixel-perfect** - this is non-negotiable

**Exit criteria (ALL must be true):**
- [ ] Colors match exactly (check hex values)
- [ ] Spacing is identical (padding, margin, gaps)
- [ ] Typography matches (size, weight, line-height)
- [ ] Borders and shadows are correct
- [ ] Layout and alignment are perfect
- [ ] Icons/images are positioned correctly

**DO NOT proceed to Phase 4 until ALL criteria are met.**

If you've done 5+ iterations and still see differences:
- Take a closer look at the reference
- Use Figma MCP to get exact values
- Ask the user to zoom in on specific areas if needed

**The goal is ZERO visual difference between the output and the design.**

---

## Phase 4: Deliver

**Show the user**:
- The final component file path
- A screenshot of the result

**Ask**: "Here's the component. Does it need any adjustments?"

If user requests changes, go back to Phase 3.

---

## Limitations

### Figma MCP Rate Limits
- ~50 requests/minuto aproximadamente
- Si se alcanza el limite: usar Chrome visual como fallback
- El limite se resetea automaticamente

### Design Context Size
- Puede ser muy grande (>50KB) para paginas completas
- Para componentes especificos: usar node ID del componente, no de la pagina
- Extraer el node ID del URL de Figma: `?node-id=123-456` -> `123:456`

---

## Guidelines

- **Be precise**: Match colors exactly, not approximately
- **Use framework conventions**: Follow the project's existing patterns
- **Keep it simple**: Don't over-engineer, just match the design
- **Iterate quickly**: Small changes, frequent screenshots
- **Ask when unsure**: If something in the design is ambiguous, ask the user

## Example Workflow

```
User: /ftc
Claude: [Verifies Figma MCP is connected with whoami]
Claude: [Detects: Next.js + TypeScript + Tailwind in src/components/]
Claude: Paste the Figma link to the component you want to build.
User: https://www.figma.com/design/abc123/MyFile?node-id=1-234
Claude: What should I name this component?
User: HeroSection
Claude: I'll create it at src/components/HeroSection.tsx
Claude: [Gets design context from Figma MCP]
Claude: I see a hero section with #1a1a2e background, Inter font. Let me create it.
Claude: [Creates src/components/HeroSection.tsx]
Claude: [Opens localhost:3000 in Chrome, takes screenshot]
Claude: [Compares with Figma screenshot - finds 2px padding difference]
Claude: [Fixes padding, takes new screenshot]
Claude: [All criteria met - exits refinement loop]
Claude: Here's the final result at src/components/HeroSection.tsx. Does it match what you need?
```
