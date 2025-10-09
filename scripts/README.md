# Scripts Directory

This directory contains helper scripts for the CodinIT project.

## verify-vercel-setup.sh

**Purpose:** Verifies that your repository is correctly configured for Vercel deployment.

**Usage:**
```bash
./scripts/verify-vercel-setup.sh
```

**What it checks:**
1. Configuration files exist and are correct (.vercelignore, vercel.json, tsconfig.json)
2. pnpm is installed
3. Dependencies install correctly with --filter flag
4. Build completes successfully
5. TypeScript compilation works
6. Workspace configuration is correct
7. No desktop app code leaked into web build

**When to run:**
- Before deploying to Vercel for the first time
- After making changes to build configuration
- When troubleshooting deployment issues
- As part of CI/CD pipeline

**Exit codes:**
- `0` - All checks passed
- `1` - One or more checks failed

**Example output:**
```
✓ All checks passed!

Your repository is ready for Vercel deployment.

Next steps:
1. Ensure environment variables are set in Vercel Dashboard
2. Verify Vercel project settings
3. Push to your repository to trigger deployment
```
