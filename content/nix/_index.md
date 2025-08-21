---
title: "Nix"
weight: 20
---

# Nix Documentation

Documentation for Nix, NixOS, and related configuration management used across Bashfulrobot MFG systems.

## Overview

This section covers NixOS system management, configuration, and deployment processes. All configurations are based on the [bashfulrobot/nixcfg](https://github.com/bashfulrobot/nixcfg) repository - a comprehensive NixOS configuration management system.

## NixOS Configuration Repository

The **nixcfg** repository serves as the central configuration hub for all NixOS systems, featuring:

### Key Features

- **Declarative System Management** - Complete system configurations in code
- **Modular Architecture** - Reusable modules for different system components
- **Multiple System Support** - Manages workstations and servers with different profiles
- **Automated Bootstrap** - Streamlined deployment to new hardware
- **Secrets Management** - git-crypt integration for sensitive configuration data
- **Development Tools** - justfile-based workflow automation

### Managed Systems

| System | Type | Profile | Description |
|--------|------|---------|-------------|
| **qbert** | Workstation | Primary | GNOME desktop environment, full development setup |
| **donkeykong** | Workstation | Secondary | GNOME desktop with encrypted storage |
| **srv** | Server | Production | Headless server configuration |

### Architecture Highlights

- **Flake-based Configuration** - Modern Nix flakes for dependency management
- **Auto-import System** - Automatic module discovery and loading
- **Hardware Detection** - Automatic hardware configuration generation
- **Desktop Environment Support** - GNOME and Hyprland configurations
- **Development Environment** - Comprehensive tooling for software development

## Repository Structure

```
nixcfg/
├── hosts/           # Host-specific configurations
├── modules/         # Reusable system modules
├── suites/          # Grouped module collections
├── bootstrap/       # Deployment automation
├── settings/        # JSON configuration files
└── justfile         # Build and management commands
```

## Getting Started

### For New Deployments
See the [NixOS Deployment](nixos-deployment/) guide for complete installation instructions.

### For Existing Systems
```bash
# Navigate to configuration directory
cd ~/dev/nix/nixcfg

# Quick syntax check
just check

# Test configuration
just test  

# Apply changes
just rebuild
```

## Configuration Philosophy

The nixcfg approach emphasizes:

- **Reproducibility** - Identical configurations across deployments
- **Modularity** - Reusable components for different use cases  
- **Maintainability** - Clear organization and documentation
- **Security** - Encrypted secrets and secure defaults
- **Automation** - Minimal manual intervention required

## Resources

- **Main Repository**: [bashfulrobot/nixcfg](https://github.com/bashfulrobot/nixcfg)
- **NixOS Manual**: [NixOS Documentation](https://nixos.org/manual/nixos/stable/)
- **Nix Language**: [Nix Expression Language](https://nixos.org/guides/nix-pills/)
- **Community**: [NixOS Discourse](https://discourse.nixos.org/)