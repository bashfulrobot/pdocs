# Hugo Documentation Site Management
# https://github.com/casey/just

# === Settings ===
set dotenv-load := true
set ignore-comments := true
set fallback := true
set shell := ["bash", "-euo", "pipefail", "-c"]

# === Variables ===
theme_version := "v0.44.1"
theme := "hugo-geekdoc"
basedir := "."
themedir := basedir + "/themes"
timestamp := `date +%Y-%m-%d_%H-%M-%S`

# === Help ===
# Show available recipes
default:
    @just --list --unsorted

# === Development Commands ===
# Install theme assets
[group('dev')]
doc-assets:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "📦 Installing theme assets..."
    mkdir -p {{themedir}}/{{theme}}/
    curl -sSL "https://github.com/thegeeklab/{{theme}}/releases/download/{{theme_version}}/{{theme}}.tar.gz" | tar -xz -C {{themedir}}/{{theme}}/ --strip-components=1

# Build the documentation site
[group('dev')]
doc-build:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🔨 Building documentation..."
    hugo --minify

# Serve development server with drafts
[group('dev')]
serve:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🚀 Starting development server..."
    hugo server --buildDrafts --watch --bind 0.0.0.0 --port 1313

# Serve development server on specific port
[group('dev')]
serve-port port="1313":
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🚀 Starting development server on port {{port}}..."
    hugo server --buildDrafts --watch --bind 0.0.0.0 --port {{port}}

# Full documentation build (assets + build)
[group('dev')]
doc: doc-assets doc-build

# === Content Commands ===
# Create new documentation page
[group('content')]
new-page path:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "📄 Creating new page: {{path}}"
    hugo new content docs/{{path}}.md

# Create new post
[group('content')]
new-post title:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "📝 Creating new post: {{title}}"
    slug=$(echo "{{title}}" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
    hugo new content posts/${slug}.md

# === Maintenance Commands ===
# Clean build artifacts and theme
[group('maintenance')]
clean:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🧹 Cleaning build artifacts..."
    rm -rf {{themedir}}
    rm -rf public/
    rm -rf resources/

# Clean only public directory
[group('maintenance')]
clean-public:
    @echo "🧹 Cleaning public directory..."
    @rm -rf public/

# Update theme to latest version
[group('maintenance')]
update-theme:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "⬆️  Updating theme to latest version..."
    rm -rf {{themedir}}/{{theme}}
    just doc-assets

# === Production Commands ===
# Production build with optimization
[group('prod')]
build-prod:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🏗️  Production build..."
    hugo --minify --gc --cleanDestinationDir

# Build and prepare for deployment
[group('prod')]
deploy-prep: clean doc-assets build-prod

# === Git Commands ===
# Show recent commits (default: 7 days)
[group('git')]
log days="7":
    #!/usr/bin/env bash
    set -euo pipefail
    echo "📜 Commits from last {{days}} days:"
    echo "Total: $(git rev-list --count --since='{{days}} days ago' HEAD)"
    echo "===================="
    git log --since="{{days}} days ago" --pretty=format:"%h - %an: %s (%cr)" --graph

# Commit and push changes
[group('git')]
commit message:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "💾 Committing changes..."
    git add -A
    git commit -m "{{message}}"
    git push

# === Workflow Aliases ===
alias s := serve
alias b := doc-build
alias d := doc
alias c := clean
alias up := update-theme
alias l := log