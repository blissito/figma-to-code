---
name: ftc
description: Build pixel-perfect components from images or Figma using HTML + TailwindCSS
allowed-tools: [Bash, Read, Write, Edit, Glob, Grep]
---

# /ftc: Figma/Image to Code

Build pixel-perfect HTML + TailwindCSS components from images or Figma designs.

## Phase 0: Setup Verification

### 1. Chrome Extension
Verify Chrome extension is connected using `tabs_context_mcp`. If not connected, inform the user to run `claude --chrome`.

### 2. Figma MCP (Optional)
Check if Figma MCP is available. This is optional - the skill works with local images too.

## Phase 1: Get Reference

**Ask the user**: "Do you have a local image or a Figma link?"

### Option A: Local Image
- User provides path to PNG, JPG, or other image file
- Read the image using the Read tool (it supports images)
- Analyze: colors, layout, typography, spacing, shadows, borders

### Option B: Figma Link
- If Figma MCP is configured, use it to extract design data
- If not configured, inform user: "Figma MCP is not configured. Please provide a local image or screenshot instead."

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

## Phase 3: Compare and Refine

### 1. Open in Chrome
Navigate Chrome to `file:///path/to/output.html`

### 2. Screenshot the Result
Take a screenshot of the rendered component.

### 3. Compare with Reference
Visually compare the screenshot with the original image:
- Check spacing matches
- Check colors are accurate
- Check typography looks right
- Check shadows and borders

### 4. Refinement Loop
If there are differences:
1. Identify what's wrong (e.g., "padding is too large", "color is off")
2. Edit the HTML to fix it
3. Refresh and screenshot again
4. Repeat until pixel-perfect

## Phase 4: Deliver

**Show the user**:
- The final `output.html` path
- A screenshot of the result

**Ask**: "Here's the component. Does it need any adjustments?"

If user requests changes, go back to Phase 3.

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
User: /path/to/button-design.png
Claude: [Reads image, analyzes it]
Claude: I see a blue button with white text, rounded corners, and a subtle shadow. Let me create it.
Claude: [Creates output.html]
Claude: [Opens in Chrome, takes screenshot]
Claude: [Compares, adjusts spacing]
Claude: Here's the final result. Does it match what you need?
```
