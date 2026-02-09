# TACOS: Team Anant's CubeSat Operating System
TACOS is the operating system that will be used on team Anant's CubeSat mission.

# Features
- Support for Linux 6.12
- Read-only root filesystem
- Automated CI/CD with GitHub Actions

# GitHub Actions Workflows

This repository includes automated workflows for building and releasing TACOS:

## Available Workflows

### 1. Build Workflow (build.yml)
**Triggers:** Push to master/main, Pull Requests, Manual dispatch

Automatically builds TACOS on every push to master and creates releases with the build artifacts.

**Features:**
- Full Yocto build with kas-container
- Automatic disk space management
- Build artifact caching for faster builds
- Publishes releases with .wic images on successful master builds

### 2. Release Workflow (release.yml)
**Triggers:** Version tags (v*), Release creation

Creates official releases when you push a version tag.

**Usage:**
```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### 3. Manual Build Workflow (manual-build.yml)
**Triggers:** Manual workflow dispatch

Allows manual builds with custom options via GitHub Actions UI.

**Options:**
- Build target selection
- Clean build option
- Optional release creation

### 4. PR Checks Workflow (pr-checks.yml)
**Triggers:** Pull Requests

Validates configuration and checks for required files.

## Downloading Build Artifacts

Pre-built images are available in two ways:

1. **GitHub Releases**: Visit the [Releases page](https://github.com/team-anant/tacos/releases) to download the latest stable builds
2. **Workflow Artifacts**: Check the [Actions tab](https://github.com/team-anant/tacos/actions) for recent build artifacts

# Steps to build image locally

### Install kas (One time)
```bash
pip install kas
```
### Set up the sources
First, clone this repository
```bash
git clone https://github.com/team-anant/tacos
```
Next, edit the local-env.sh file to match your build environment and then source it
```bash
cd tacos
source ./local-env.sh
```
Now you can start the build process with:
```bash
kas-container build
```
Alternatively, use `kas-container checkout` to checkout all the sources and make any required modifications

You can find the build artifacts in `tacos/build/tmp/deploy/images/bleedingbone/`

# Installation

In order to transfer the image to a beaglebone black via an uSD card:
```bash
sudo bmaptool copy tmp/deploy/images/bleedingbone/taco.wic /dev/XYZ
#XYZ is the device node for your uSD card
```
Alternatively, you can just close your eyes and use any other image flasher to flash the .wic image onto the SD card.
