---
title: "Deploying NixOS to a New System"
weight: 15
---

This guide walks you through deploying NixOS to a new system using the [bashfulrobot/nixcfg](https://github.com/bashfulrobot/nixcfg) configuration repository. The deployment process is automated and supports multiple system configurations with optional disk encryption and hardware detection.

## Overview

The nixcfg repository provides:
- **Declarative system configurations** for workstations and servers
- **Automated bootstrap process** with interactive system selection
- **Full disk encryption support** with optional automatic partitioning
- **Git-crypt secrets management** for sensitive configuration data
- **Hardware detection** and automatic configuration generation

## Available System Configurations

| System | Type | Description |
|--------|------|-------------|
| `qbert` | Workstation | Primary workstation with GNOME desktop |
| `donkeykong` | Workstation | Secondary workstation with GNOME desktop and encrypted disk |
| `srv` | Server | Server configuration |

## Prerequisites

1. **NixOS Live ISO**: Boot your target system from a NixOS live ISO
2. **Internet connection**: Required for downloading configurations and packages
3. **SSH access** (optional): For automated secrets management
4. **Target hardware**: System where NixOS will be installed

## Quick Deployment (Recommended)

### Method 1: Using the Bootstrap Shell

```bash
# Download and enter the bootstrap environment
curl -L nixcfg.bashfulrobot.com/shell -o shell.nix
sudo nix-shell shell.nix
```

### Method 2: Alternative GitHub Method

```bash
# Alternative download method
curl -LO https://raw.githubusercontent.com/bashfulrobot/nixcfg/main/bootstrap/shell.nix
sudo nix-shell shell.nix
```

Once in the bootstrap shell, run the deployment script:

```bash
curl -L nixcfg.bashfulrobot.com/bootstrap/deploy-nixos.sh | sudo bash
```

## Bootstrap Environment

The bootstrap shell provides essential tools for deployment:

### Core Tools
- **Git & git-crypt**: Version control and secrets management
- **curl & wget**: Network downloads
- **just**: Command runner for the configuration

### System Tools
- **parted & util-linux**: Disk management utilities
- **NixOS installation tools**: Core installation utilities

### Additional Utilities
- **Helix**: Text editor for configuration editing
- **GnuPG**: Security and key management
- **tree & htop**: System inspection tools

## Deployment Process

### 1. System Selection

The deployment script will prompt you to:
- Choose your target system configuration (`qbert`, `donkeykong`, or `srv`)
- Decide whether to use automatic disk partitioning (via Disko)
- Configure disk encryption settings if applicable

### 2. Secrets Management

The script handles sensitive data through:
- **Git-crypt key retrieval**: Automatically fetches encryption keys via SSH
- **SSH key setup**: Optional retrieval of SSH keys for system access
- **GPG key management**: Configures GPG keys for secure operations

### 3. Hardware Configuration

Automatic hardware detection:
- Generates hardware-specific configuration
- Copies configuration to the repository
- Ensures proper hardware support for your system

### 4. Repository Preparation

The deployment process:
- Downloads the complete nixcfg repository
- Unlocks encrypted secrets using git-crypt
- Preserves security keys for the target system
- Prepares the configuration for installation

### 5. Installation Options

Choose from three installation modes:

#### Automatic Installation (Recommended)
- Fully automated NixOS installation
- Applies the selected system configuration
- Handles all setup steps automatically

#### Manual Installation
The script provides the exact command for manual installation:
```bash
sudo nixos-install --flake /mnt/etc/nixos/nixcfg#<system-name>
```

#### Configuration-Only Mode
- Prepares the system configuration without installing
- Useful for configuration testing or manual installation later

## Post-Installation Steps

After successful deployment, complete these essential steps:

### 1. Set User Password
```bash
sudo passwd <username>
```

### 2. Move Repository to Expected Location
```bash
mkdir -p ~/dev/nix
mv /etc/nixos/nixcfg ~/dev/nix/nixcfg
cd ~/dev/nix/nixcfg
```

### 3. Update Git Remote to SSH
```bash
git remote set-url origin git@github.com:bashfulrobot/nixcfg.git
```

### 4. Commit Updated Hardware Configuration
```bash
git add .
git commit -m "feat: add hardware config for new system"
git push
```

### 5. Apply System Updates
```bash
just rebuild
```

## Advanced Configuration

### Custom Disk Partitioning

If you choose manual disk setup:

1. **Partition your disks** according to your requirements
2. **Mount filesystems** at `/mnt`
3. **Generate hardware config**: `nixos-generate-config --root /mnt`
4. **Proceed with configuration** deployment

### Security Considerations

The deployment process includes several security features:

- **Git-crypt encryption**: Sensitive configuration data is encrypted
- **SSH key management**: Secure key distribution and access
- **Disk encryption**: Optional full-disk encryption support
- **Hardware security**: TPM and secure boot compatibility (where supported)

## Troubleshooting

### Common Issues

**Network connectivity problems:**
```bash
# Test internet connection
ping google.com

# Configure networking if needed
systemctl start NetworkManager
```

**Git-crypt key issues:**
- Ensure SSH access to the key source
- Verify SSH keys are properly configured
- Check network connectivity to the key server

**Hardware detection problems:**
- Verify all hardware is properly connected
- Check for unsupported hardware components
- Review generated hardware configuration

### Getting Help

- **Repository Issues**: Check the [nixcfg GitHub issues](https://github.com/bashfulrobot/nixcfg/issues)
- **NixOS Documentation**: Refer to the [official NixOS manual](https://nixos.org/manual/nixos/stable/)
- **Community Support**: Join the NixOS community forums and Discord

## Development Workflow

After deployment, use these commands for ongoing system management:

```bash
# Quick syntax validation
just check

# Test configuration without applying
just test

# Apply configuration changes
just build

# Production system rebuild
just rebuild

# System upgrade with flake updates
just upgrade

# Clean old generations
just clean
```

## Summary

The nixcfg deployment process provides a streamlined, automated approach to NixOS installation with:

- **Zero-touch deployment** for supported hardware
- **Encrypted secrets management** with git-crypt
- **Flexible system configurations** for different use cases
- **Hardware-specific optimization** through automatic detection
- **Post-installation tooling** for ongoing system management

This approach ensures consistent, reproducible system deployments while maintaining security and flexibility for different hardware configurations and use cases.