#!/bin/bash
# Setup script for figma-to-code plugin
# Automatically configures Figma MCP

echo ""
echo "🔧 Configurando figma-to-code..."
echo ""

# Verificar si Figma MCP ya está instalado
if claude mcp list 2>/dev/null | grep -q "figma"; then
  echo "✅ Figma MCP ya configurado"
else
  echo "📦 Agregando Figma MCP..."
  claude mcp add --transport http figma https://mcp.figma.com/mcp
  if [ $? -eq 0 ]; then
    echo "✅ Figma MCP agregado correctamente"
  else
    echo "⚠️  No se pudo agregar Figma MCP automáticamente"
    echo "   Ejecuta manualmente: claude mcp add --transport http figma https://mcp.figma.com/mcp"
  fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 PASOS RESTANTES:"
echo ""
echo "   1. Instalar Chrome Extension (obligatorio):"
echo "      https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn"
echo ""
echo "   2. Primera ejecución:"
echo "      $ claude --chrome"
echo ""
echo "   3. (Opcional) Habilitar Chrome por defecto:"
echo "      Dentro de Claude, ejecutar:  /chrome"
echo "      Seleccionar: \"Enabled by default\""
echo "      Después ya no necesitarás el flag --chrome"
echo ""
echo "   4. Usar el plugin:"
echo "      /ftc"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit 0
