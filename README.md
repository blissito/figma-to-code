# Figma to Code

Construye componentes pixel-perfect desde diseños de Figma o imágenes usando HTML + TailwindCSS.

> Built by blissito inspired by CC_Skills

[English version](README_EN.md)

## Instalación

```bash
# Agregar marketplace (solo una vez)
claude plugin marketplace add blissito/figma-to-code

# Instalar el plugin
claude plugin install figma-to-code@blissito

# Ejecutar setup (agrega Figma MCP automáticamente)
claude --init
```

## Requisitos

- Claude Code v2.0.73+
- **Claude in Chrome extension v1.0.36+** (requerida)
- Figma MCP (opcional, para links de Figma)
- Plan Pro/Team/Enterprise

## Setup: Chrome Extension

La extensión de Chrome es **obligatoria** para este plugin.

### 1. Instalar la extensión

- Ir a [Chrome Web Store](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn)
- Click en "Añadir a Chrome"
- Reiniciar Chrome

### 2. Verificar versión de Claude Code

```bash
claude --version
# Debe ser 2.0.73 o superior
```

### 3. Iniciar con Chrome habilitado

```bash
claude --chrome
```

### 4. (Opcional) Habilitar Chrome por defecto

Para no tener que usar `--chrome` cada vez:

```
/chrome
→ Seleccionar "Enabled by default"
```

> **Nota**: Esto aumenta el uso de contexto porque las herramientas de Chrome siempre están cargadas.

## Setup: Figma MCP (Automático)

Figma MCP se configura automáticamente al ejecutar `claude --init` después de instalar el plugin.

Si necesitas configurarlo manualmente:

```bash
claude mcp add --transport http figma https://mcp.figma.com/mcp
```

La autenticación OAuth ocurre automáticamente la primera vez que uses una herramienta de Figma.

## Uso

```bash
claude --chrome
```

Luego:

```
/ftc
```

## Cómo Funciona

### Workflow "3 Ojos"

El skill usa 3 fuentes de información en paralelo:

| Ojo             | Fuente       | Propósito                                         |
| --------------- | ------------ | ------------------------------------------------- |
| 👁️ MCP          | Figma API    | Datos precisos: colores hex, fonts, spacing en px |
| 👁️ Chrome Tab 1 | Figma visual | Referencia visual, zoom, inspección               |
| 👁️ Chrome Tab 2 | HTML output  | Resultado renderizado, comparación                |

### Proceso

1. Proporciona un link de Figma o imagen local
2. Claude extrae datos de diseño via Figma MCP
3. Genera HTML + TailwindCSS
4. Inicia servidor local (`python3 -m http.server 8888`)
5. Abre en Chrome, compara con referencia
6. Itera hasta pixel-perfect

### Herramientas de Figma MCP

| Herramienta          | Propósito                           |
| -------------------- | ----------------------------------- |
| `get_metadata`       | Estructura del componente, node IDs |
| `get_design_context` | Código generado + URLs de assets    |
| `get_screenshot`     | Captura visual del nodo             |
| `get_variable_defs`  | Design tokens (colores, spacing)    |

### URLs de Assets

`get_design_context` devuelve URLs de imágenes temporales (válidas 7 días):

```javascript
const img = "https://www.figma.com/api/mcp/asset/uuid";
// Usar directo en <img src="...">
```

## Limitaciones

- **Rate limits**: ~50 requests/min en Figma MCP
- **URLs file://**: No funcionan con Chrome extension, usar localhost
- **Diseños grandes**: Usar node IDs específicos, no páginas completas

## Licencia

MIT
