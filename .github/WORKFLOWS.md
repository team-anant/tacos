# GitHub Actions Workflows Documentation

This document provides detailed information about the GitHub Actions workflows configured for the TACOS repository.

## Overview

The TACOS repository uses GitHub Actions to automate building, testing, and releasing the CubeSat operating system. All workflows are located in `.github/workflows/`.

## Workflows

### 1. Build Workflow (`build.yml`)

**Purpose:** Continuous integration for the master branch

**Triggers:**
- Push to `master` or `main` branch
- Pull requests to `master` or `main` branch
- Manual workflow dispatch

**What it does:**
1. Sets up Ubuntu build environment
2. Frees up disk space (removes unnecessary packages)
3. Installs kas build tool
4. Caches build downloads and sstate for faster subsequent builds
5. Runs `kas-container build` to build TACOS
6. Verifies build artifacts exist
7. Uploads build artifacts to GitHub Actions (30-day retention)
8. Uploads build logs for debugging (7-day retention)
9. **On master push:** Automatically creates a timestamped release with build images

**Build Time:** Up to 8 hours (Yocto builds are resource-intensive)

**Artifacts:**
- `tacos-images`: Contains .wic and .wic.bmap files
- `build-logs`: Contains build log files for debugging

### 2. Release Workflow (`release.yml`)

**Purpose:** Official release builds for version tags

**Triggers:**
- Push of version tags (e.g., `v1.0.0`, `v2.1.3`)
- Manual release creation

**What it does:**
1. Performs a complete build (same as build.yml)
2. Generates SHA256 checksums for all artifacts
3. Creates a GitHub release with:
   - Build artifacts (.wic, .wic.bmap)
   - SHA256SUMS.txt for verification
   - Comprehensive release notes with installation instructions

**Usage Example:**
```bash
# Tag a release
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# The workflow will automatically build and create a release
```

**Release Assets:**
- `taco.wic` - Bootable image file
- `taco.wic.bmap` - Block map for faster flashing
- `SHA256SUMS.txt` - Checksums for verification

### 3. Manual Build Workflow (`manual-build.yml`)

**Purpose:** On-demand builds with custom options

**Triggers:**
- Manual workflow dispatch via GitHub UI

**Input Parameters:**
- `build_target` (default: "taco"): Specify which target to build
- `clean_build` (boolean): Remove previous build artifacts before building
- `create_release` (boolean): Create a GitHub release with the build

**What it does:**
1. Optionally cleans previous build artifacts
2. Builds TACOS with specified parameters
3. Generates SHA256 checksums
4. Uploads artifacts to GitHub Actions
5. Optionally creates a prerelease with artifacts

**Usage:**
1. Go to the Actions tab in GitHub
2. Select "Manual Build" workflow
3. Click "Run workflow"
4. Choose your options
5. Click "Run workflow"

**Use Cases:**
- Test builds before creating an official release
- Build with clean state to troubleshoot issues
- Quick builds without creating version tags

### 4. PR Checks Workflow (`pr-checks.yml`)

**Purpose:** Fast validation for pull requests

**Triggers:**
- Pull requests to `master` or `main` branch

**What it does:**
1. Validates kas configuration syntax
2. Checks that required files exist
3. Runs in ~10 minutes (no full build)

**Checks Performed:**
- `.config.yaml` is valid YAML and kas can parse it
- Required files exist (README.md, .config.yaml, meta-tacos/)

**Purpose:** Catch configuration errors early without running a full build

## Caching Strategy

Workflows use GitHub Actions caching to speed up builds:

- **Cache Key:** Based on OS and `.config.yaml` hash
- **Cached Directories:**
  - `build/downloads` - Downloaded source tarballs
  - `build/sstate-cache` - Shared state cache for incremental builds

**Benefits:**
- Significantly faster subsequent builds
- Reduced network bandwidth
- Lower CI resource usage

## Disk Space Management

Yocto builds require significant disk space. Workflows automatically:

1. Remove unnecessary packages:
   - .NET SDK (~20GB)
   - Android SDK (~10GB)
   - GHC Haskell compiler (~5GB)
   - CodeQL tools (~5GB)

2. Clean apt cache

This frees up ~40GB for the build process.

## Build Artifacts

### Image Files

After a successful build, the following files are available:

- **taco.wic**: Bootable disk image for BeagleBone Black
- **taco.wic.bmap**: Block map file for efficient flashing with bmaptool

### Installation

Download artifacts and flash to SD card:

```bash
# Using bmaptool (recommended - faster and safer)
sudo bmaptool copy taco.wic /dev/sdX

# Using dd (slower)
sudo dd if=taco.wic of=/dev/sdX bs=4M status=progress conv=fsync
```

Replace `/dev/sdX` with your SD card device node.

### Verification

Verify downloaded artifacts using SHA256 checksums:

```bash
sha256sum -c SHA256SUMS.txt
```

## Troubleshooting

### Build Failures

1. **Out of disk space:**
   - Builds may fail if disk cleanup isn't sufficient
   - Consider using clean builds for problematic cases

2. **Build logs:**
   - Check the uploaded `build-logs` artifact
   - Look for error messages in the workflow output

3. **Cache issues:**
   - Manually trigger a clean build
   - Delete the cache from repository settings

### Workflow Failures

1. **Permission errors:**
   - Ensure `GITHUB_TOKEN` has proper permissions
   - Check repository settings > Actions > General > Workflow permissions

2. **Rate limiting:**
   - GitHub has API rate limits
   - Wait and retry if you hit limits

## Best Practices

1. **For quick changes:** Use PR checks to validate before full build
2. **For releases:** Use version tags (v*) to trigger release workflow
3. **For testing:** Use manual build workflow with appropriate options
4. **Monitor disk space:** Check build logs if builds fail unexpectedly

## Resource Requirements

- **GitHub Actions Minutes:** Builds consume significant minutes (up to 8 hours)
- **Storage:** Artifacts are stored for 30 days (can be adjusted)
- **Concurrent Builds:** Limit concurrent builds to avoid resource exhaustion

## Future Enhancements

Potential improvements for the workflows:

1. Matrix builds for different configurations
2. Build artifact signing
3. Integration with external artifact storage
4. Automated testing of built images
5. Notification system for build failures
6. Build time optimization
