# GitHub Actions Workflows

This directory contains the CI/CD pipeline configurations for the SAT-WiSe-25-26 LaTeX document project.

## Workflows

### 1. Build Workflow (`makefile.yml`)

**Purpose:** Continuous Integration - Build and test the LaTeX document on every push and pull request.

**Triggers:**
- Push to `main` branch
- Pull requests to `main` branch
- Manual workflow dispatch

**Features:**
- Builds the document using Docker Compose
- Verifies PDF generation
- Uploads the PDF as an artifact (30-day retention)
- Uploads build logs on failure for debugging

**Artifacts:**
- `SAT-WiSe-25-26-PDF` - The compiled PDF document
- `build-logs` - LaTeX compilation logs (only on failure)

### 2. Release Workflow (`release.yml`)

**Purpose:** Automated release creation when version tags are pushed.

**Triggers:**
- Push of tags matching `v*.*.*` (e.g., `v1.0.0`)
- Push of tags matching `release-*` (e.g., `release-2024-10`)

**Features:**
- Builds the document with Docker
- Creates a GitHub release
- Attaches versioned PDF to the release
- Generates release notes automatically
- Archives artifacts for 90 days

**Artifacts:**
- `SAT-WiSe-25-26_[VERSION].pdf` - Versioned PDF in the release
- `Main.pdf` - Standard PDF name
- Release artifacts with 90-day retention

## Usage

### Triggering a Build

Builds are triggered automatically on:
- Every push to `main`
- Every pull request

To manually trigger a build:
1. Go to Actions tab
2. Select "Build LaTeX Document"
3. Click "Run workflow"

### Creating a Release

To create a new release:

```bash
# Create an annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push the tag to GitHub
git push origin v1.0.0
```

The release workflow will automatically:
1. Build the document
2. Create a GitHub release
3. Attach the PDF with version number
4. Generate release notes from commits

### Accessing Build Artifacts

#### From a Regular Build:
1. Navigate to the **Actions** tab
2. Click on a workflow run
3. Scroll to **Artifacts** section
4. Download `SAT-WiSe-25-26-PDF`

#### From a Release:
1. Navigate to **Releases** section
2. Find your release
3. Download the attached PDF files

## Configuration

### Environment Requirements

The workflows use Docker to ensure consistent builds:
- Base image: `texlive/texlive:latest`
- Additional packages: `inkscape` (for SVG support)
- Build command: `make docker-build`

### Permissions

The release workflow requires:
- `contents: write` - To create releases and upload assets

### Retention Policies

- **Regular builds:** 30 days
- **Release builds:** 90 days
- **Failed build logs:** 7 days

## Troubleshooting

### Build Failures

If a build fails:
1. Check the workflow run logs
2. Download the `build-logs` artifact
3. Review `Main.log` for LaTeX errors

Common issues:
- Missing LaTeX packages
- Bibliography compilation errors
- SVG conversion problems

### Release Creation Issues

If a release fails:
- Ensure the tag format is correct (`v*.*.*` or `release-*`)
- Check GitHub permissions for release creation
- Verify the PDF was built successfully

### Docker Build Issues

The workflows use Docker Compose which:
- Automatically detects `docker-compose` vs `docker compose`
- Builds a custom image with all dependencies
- Mounts the repository as `/data` in the container

## Maintenance

### Updating Dependencies

The project includes `dependabot.yml` for automatic updates:
- GitHub Actions: Weekly checks
- Docker base images: Monthly checks

### Modifying Workflows

When modifying workflows:
1. Test changes in a feature branch
2. Use `workflow_dispatch` for manual testing
3. Monitor the Actions tab for results

## Best Practices

1. **Versioning:** Use semantic versioning for tags (v1.0.0)
2. **Release Notes:** Write meaningful tag messages
3. **Artifacts:** Download important artifacts before retention expires
4. **Monitoring:** Check workflow runs regularly for failures

## Support

For workflow issues:
1. Check this documentation
2. Review workflow run logs
3. Open an issue in the repository
4. Contact the maintainer

---

*Last updated: October 2024*