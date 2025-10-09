#!/bin/bash

# Vercel Deployment Verification Script
# Run this script to verify your setup before deploying to Vercel

set -e

echo "╔══════════════════════════════════════════════════════╗"
echo "║   Vercel Deployment Verification for CodinIT        ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track if any errors occurred
ERRORS=0
WARNINGS=0

# Function to print success
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Function to print error
error() {
    echo -e "${RED}✗${NC} $1"
    ERRORS=$((ERRORS + 1))
}

# Function to print warning
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    WARNINGS=$((WARNINGS + 1))
}

echo "Step 1: Checking required configuration files..."
echo ""

# Check .vercelignore
if [ -f ".vercelignore" ]; then
    if grep -q "apps/" ".vercelignore"; then
        success ".vercelignore exists and excludes apps/"
    else
        error ".vercelignore exists but doesn't exclude apps/"
    fi
else
    error ".vercelignore not found"
fi

# Check vercel.json
if [ -f "vercel.json" ]; then
    if grep -q "pnpm install --filter @codinit/web" "vercel.json"; then
        success "vercel.json exists with correct install command"
    else
        warning "vercel.json exists but install command may be incorrect"
    fi
else
    error "vercel.json not found"
fi

# Check tsconfig.json
if [ -f "tsconfig.json" ]; then
    if grep -q '"apps"' "tsconfig.json"; then
        success "tsconfig.json exists and excludes apps directory"
    else
        warning "tsconfig.json exists but may not exclude apps directory"
    fi
else
    error "tsconfig.json not found"
fi

# Check package.json
if [ -f "package.json" ]; then
    if grep -q '"@codinit/web"' "package.json"; then
        success "package.json exists with correct name"
    else
        error "package.json name is not @codinit/web"
    fi
else
    error "package.json not found"
fi

echo ""
echo "Step 2: Testing pnpm installation..."
echo ""

if ! command -v pnpm &> /dev/null; then
    error "pnpm is not installed"
    echo "  Install with: npm install -g pnpm@10.17.1"
    exit 1
fi

PNPM_VERSION=$(pnpm --version)
success "pnpm is installed (version $PNPM_VERSION)"

echo ""
echo "Step 3: Testing dependency installation (this may take a minute)..."
echo ""

# Clean install test
if rm -rf node_modules .next 2>/dev/null; then
    success "Cleaned previous build artifacts"
fi

if pnpm install --filter @codinit/web > /tmp/pnpm-install.log 2>&1; then
    success "Dependencies install successfully with --filter @codinit/web"
else
    error "Dependency installation failed"
    echo "  Check /tmp/pnpm-install.log for details"
    cat /tmp/pnpm-install.log | tail -20
fi

echo ""
echo "Step 4: Testing build process..."
echo ""

if pnpm build > /tmp/pnpm-build.log 2>&1; then
    success "Build completes successfully"
    
    # Check build output
    if [ -d ".next" ]; then
        success "Build output directory (.next) created"
        
        # Check for desktop app references
        DESKTOP_REFS=$(grep -r "apps/desktop" .next --include="*.js" 2>/dev/null | wc -l)
        if [ "$DESKTOP_REFS" -gt 0 ]; then
            warning "Build output contains $DESKTOP_REFS desktop app reference(s)"
        else
            success "No desktop app references found in build output"
        fi
    else
        error "Build output directory (.next) not created"
    fi
else
    error "Build failed"
    echo "  Last 30 lines of build output:"
    cat /tmp/pnpm-build.log | tail -30
fi

echo ""
echo "Step 5: Checking TypeScript compilation..."
echo ""

if npx tsc --noEmit > /tmp/tsc-check.log 2>&1; then
    success "TypeScript compilation succeeds"
else
    warning "TypeScript has errors (may not prevent deployment)"
    echo "  Check /tmp/tsc-check.log for details"
fi

echo ""
echo "Step 6: Verifying workspace configuration..."
echo ""

if [ -f "pnpm-workspace.yaml" ]; then
    success "pnpm-workspace.yaml exists"
    if grep -q "'\\.'" "pnpm-workspace.yaml" && grep -q "'apps/\\*'" "pnpm-workspace.yaml"; then
        success "Workspace correctly includes root and apps"
    else
        warning "Workspace configuration may be incorrect"
    fi
else
    error "pnpm-workspace.yaml not found"
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo "                    Summary"
echo "═══════════════════════════════════════════════════════"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "Your repository is ready for Vercel deployment."
    echo ""
    echo "Next steps:"
    echo "1. Ensure environment variables are set in Vercel Dashboard:"
    echo "   - E2B_API_KEY"
    echo "   - NEXT_PUBLIC_SUPABASE_URL"
    echo "   - NEXT_PUBLIC_SUPABASE_ANON_KEY"
    echo "   - SUPABASE_SERVICE_ROLE_KEY"
    echo "   - At least one LLM provider API key"
    echo ""
    echo "2. Verify Vercel project settings:"
    echo "   - Install Command: pnpm install --filter @codinit/web"
    echo "   - Build Command: pnpm build"
    echo "   - Output Directory: .next"
    echo "   - Root Directory: ./"
    echo ""
    echo "3. Push to your repository to trigger deployment"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Found $ERRORS error(s)${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠ Found $WARNINGS warning(s)${NC}"
    fi
    echo ""
    echo "Please fix the errors above before deploying to Vercel."
    echo "See VERCEL_DEPLOYMENT_GUIDE.md for detailed troubleshooting."
    echo ""
    exit 1
fi
