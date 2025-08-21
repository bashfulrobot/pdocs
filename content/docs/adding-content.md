---
title: "Adding Content"
weight: 10
---

# Adding Content to the Documentation Site

This guide explains how to add and manage content on the Bashfulrobot MFG documentation site.

## Prerequisites

1. **Local Development Setup**
   - Hugo installed (v0.147.3 or later)
   - Git for version control
   - Text editor (VS Code, Helix, etc.)
   - Access to the [pdocs repository](https://github.com/bashfulrobot/pdocs)

2. **Repository Structure**
   ```
   pdocs/
   ├── content/
   │   ├── docs/          # Site management documentation
   │   ├── nix/           # Nix-related documentation
   │   └── _index.md      # Homepage content
   ├── static/
   │   ├── css/           # Custom styling
   │   └── images/        # Site assets
   ├── hugo.toml          # Site configuration
   └── justfile           # Build automation
   ```

## Quick Start

### Using the Justfile Commands

The site includes a `justfile` with helpful commands:

```bash
# Create a new documentation page
just new-page "page-name"

# Start development server
just serve

# Build the site
just doc-build

# Clean build artifacts
just clean
```

### Manual Content Creation

1. **Create a new section directory** (if needed):
   ```bash
   mkdir -p content/new-section
   ```

2. **Add section index page**:
   ```bash
   # content/new-section/_index.md
   ---
   title: "New Section"
   weight: 30
   ---
   
   # New Section
   
   Description of this section.
   ```

3. **Create content pages**:
   ```bash
   # content/new-section/example-page.md
   ---
   title: "Example Page"
   weight: 10
   ---
   
   # Example Page
   
   Your content here using markdown.
   ```

## Content Organization

### File Structure

The site uses Hugo's content organization with the Geekdoc theme:

- **Section directories** (e.g., `docs/`, `nix/`) contain related content
- **`_index.md` files** define section homepages and navigation
- **Individual `.md` files** create documentation pages
- **Weight values** control navigation order (lower = first)

### Front Matter

Each content file requires YAML front matter:

```yaml
---
title: "Page Title"           # Required: Page title in navigation
weight: 10                    # Required: Navigation order
---
```

Optional parameters:
```yaml
---
title: "Page Title"
weight: 10
geekdocAnchor: true          # Enable anchor links
geekdocToC: 3                # Table of contents depth
geekdocHidden: false         # Hide from navigation
---
```

## Content Writing

### Markdown Syntax

The site supports standard markdown plus Geekdoc extensions:

```markdown
# Heading 1
## Heading 2
### Heading 3

**Bold text**
*Italic text*
`inline code`

- Bulleted list
1. Numbered list

[Markdown Guide](https://www.markdownguide.org)

```bash
# Code blocks with syntax highlighting
echo "Hello World"
```
```

### Tables

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Row 1    | Data     | Data     |
| Row 2    | Data     | Data     |
```

### Callouts and Hints

```markdown
{{< hint type="info" >}}
**Info:** This is an informational callout.
{{< /hint >}}

{{< hint type="warning" >}}
**Warning:** This is a warning callout.
{{< /hint >}}

{{< hint type="danger" >}}
**Danger:** This is a danger callout.
{{< /hint >}}
```

### Diagrams with Mermaid

The site supports Mermaid diagrams:

```markdown
{{< mermaid >}}
graph TD
    A[Start] --> B{Decision}
    B -->|Yes| C[Action 1]
    B -->|No| D[Action 2]
    C --> E[End]
    D --> E
{{< /mermaid >}}
```

## Development Workflow

### Local Development

1. **Clone the repository**:
   ```bash
   git clone https://github.com/bashfulrobot/pdocs.git
   cd pdocs
   ```

2. **Start the development server**:
   ```bash
   just serve
   ```

3. **Edit content** - Changes are automatically reloaded

4. **Preview at** http://localhost:1313

### Content Creation Process

1. **Plan your content structure**
   - Decide which section it belongs to
   - Consider the navigation hierarchy
   - Choose appropriate weights for ordering

2. **Create the content file**
   ```bash
   just new-page "section/page-name"
   # or manually create the file
   ```

3. **Write your content**
   - Add proper front matter
   - Use markdown formatting
   - Include code examples and diagrams as needed

4. **Test locally**
   ```bash
   just serve
   # Check navigation, formatting, and links
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "📝 docs: add new content page"
   git push
   ```

## Deployment

The site automatically deploys via Netlify when changes are pushed to the main branch:

1. **Push to GitHub** - Triggers automatic build
2. **Netlify builds** - Uses Hugo to generate static site
3. **Live deployment** - Updates are live within minutes

### Build Configuration

The site uses `netlify.toml` for deployment configuration:
- Hugo version: 0.147.3
- Build command: `hugo`
- Publish directory: `public`

## Troubleshooting

### Common Issues

**Navigation not updating:**
- Check front matter syntax
- Ensure proper weight values
- Restart development server

**Styling issues:**
- Custom CSS is in `static/css/custom.css`
- Changes require server restart for full reload

**Build failures:**
- Check Hugo version compatibility
- Validate markdown syntax
- Review error logs in Netlify dashboard

### Getting Help

- **Repository Issues**: [GitHub Issues](https://github.com/bashfulrobot/pdocs/issues)
- **Hugo Documentation**: [Hugo Docs](https://gohugo.io/documentation/)
- **Geekdoc Theme**: [Theme Documentation](https://geekdocs.de/)

## Best Practices

1. **Content Quality**
   - Write clear, concise documentation
   - Include practical examples
   - Update content regularly

2. **Organization**
   - Use logical section hierarchies
   - Maintain consistent naming conventions
   - Set appropriate weight values

3. **Maintenance**
   - Regular content reviews
   - Link checking
   - Version control best practices

## Examples

### Creating a New Section

```bash
# 1. Create directory structure
mkdir -p content/tutorials

# 2. Create section index
cat > content/tutorials/_index.md << EOF
---
title: "Tutorials"
weight: 25
---

# Tutorials

Step-by-step guides and tutorials.
EOF

# 3. Add first tutorial
just new-page "tutorials/first-tutorial"
```

### Adding Images

```bash
# 1. Add image to static directory
cp image.png static/images/

# 2. Reference in markdown
![Alt text](/images/image.png)
```

This comprehensive guide should help anyone contribute to and manage the documentation site effectively.