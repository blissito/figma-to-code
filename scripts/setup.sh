#!/bin/bash
# Setup script for figma-to-code plugin
# Automatically configures Figma MCP

echo "🔧 Configurando figma-to-code..."
echo ""

# Verificar si Figma MCP ya está instalado
if claude mcp list 2>/dev/null | grep -q "figma"; then
  echo "✓ Figma MCP ya configurado"
else
  echo "📦 Agregando Figma MCP..."
  claude mcp add --transport http figma https://mcp.figma.com/mcp
  if [ $? -eq 0 ]; then
    echo "✓ Figma MCP agregado correctamente"
  else
    echo "⚠️  No se pudo agregar Figma MCP automáticamente"
    echo "   Ejecuta manualmente: claude mcp add --transport http figma https://mcp.figma.com/mcp"
  fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  Chrome Extension debe instalarse manualmente:"
echo "   https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 Para usar el plugin:"
echo "   1. claude --chrome"
echo "   2. /ftc"
echo ""

exit 0
