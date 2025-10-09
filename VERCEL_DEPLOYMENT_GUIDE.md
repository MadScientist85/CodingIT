# Vercel Deployment Guide for CodinIT

## 🎯 Quick Status Check

Run this command to verify your setup:

```bash
# Test build exactly as Vercel will
rm -rf node_modules .next
pnpm install --filter @codinit/web
pnpm build
```

**If this succeeds** ✅ - Your code is ready. Check Vercel dashboard settings.
**If this fails** ❌ - Fix the errors shown before deploying.

---

## 📋 Vercel Dashboard Configuration

### Project Settings

Go to your Vercel project → **Settings** → **General**

| Setting | Required Value |
|---------|---------------|
| **Framework Preset** | Next.js |
| **Root Directory** | `./` (or leave empty) |
| **Build Command** | `pnpm build` |
| **Install Command** | `pnpm install --filter @codinit/web` |
| **Output Directory** | `.next` |
| **Node.js Version** | 20.x (recommended) |

### Environment Variables

Go to **Settings** → **Environment Variables**

#### ✅ Required Variables (App Won't Work Without These)

```bash
# E2B API for code execution
E2B_API_KEY=your_e2b_api_key_here

# Supabase (Database & Auth)
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_key
```

#### 🤖 LLM Providers (At Least One Required)

```bash
# OpenAI
OPENAI_API_KEY=your_openai_key

# OR Anthropic
ANTHROPIC_API_KEY=your_anthropic_key

# OR Google AI
GOOGLE_GENERATIVE_AI_API_KEY=your_google_key

# OR Google Vertex AI
GOOGLE_VERTEX_CREDENTIALS=your_vertex_credentials_json
```

#### 📊 Optional but Recommended

```bash
# Rate Limiting (using Vercel KV)
KV_REST_API_URL=auto_populated_if_using_vercel_kv
KV_REST_API_TOKEN=auto_populated_if_using_vercel_kv

# Analytics
NEXT_PUBLIC_POSTHOG_KEY=your_posthog_key
NEXT_PUBLIC_ENABLE_POSTHOG=true

# GitHub Integration
GITHUB_TOKEN=your_github_token

# Email Validation
ZEROBOUNCE_API_KEY=your_zerobounce_key

# Feature Flags
NEXT_PUBLIC_HIDE_LOCAL_MODELS=false
NEXT_PUBLIC_NO_API_KEY_INPUT=false
NEXT_PUBLIC_NO_BASE_URL_INPUT=false
```

**Important Notes:**
- Set variables for **Production** environment at minimum
- Variables starting with `NEXT_PUBLIC_` are exposed to browser
- Redeploy after adding/changing variables

---

## 🔧 Repository Configuration Files

These files are already configured correctly in the repository:

### `.vercelignore`
```
apps/
apps/**
```
Excludes desktop app from Vercel deployment.

### `vercel.json`
```json
{
  "installCommand": "pnpm install --filter @codinit/web",
  "buildCommand": "pnpm build",
  "framework": "nextjs",
  "outputDirectory": ".next"
}
```

### `tsconfig.json`
```json
{
  "exclude": ["node_modules", "apps"]
}
```

---

## 🚀 Deployment Process

### First-Time Setup

1. **Connect Repository to Vercel**
   - Go to vercel.com → New Project
   - Import your GitHub repository
   - Select the repository: `MadScientist85/CodingIT`

2. **Configure Project Settings**
   - Framework: Next.js (auto-detected)
   - Root Directory: `./` or leave empty
   - Build settings: Use the values from table above

3. **Add Environment Variables**
   - Add all required variables from the list above
   - Set environment: Production (and Preview if needed)

4. **Deploy**
   - Click "Deploy"
   - Wait for build to complete (~2-3 minutes)

### Subsequent Deployments

**Automatic (Recommended):**
```bash
git add .
git commit -m "Your changes"
git push origin main
```
Vercel auto-deploys when you push to connected branch.

**Manual:**
```bash
# Using Vercel CLI
vercel --prod

# Or use Vercel Dashboard
# Go to Deployments → click "Deploy" button
```

---

## 🐛 Troubleshooting

### Build Succeeds Locally but Fails on Vercel

**Possible Causes:**

1. **Wrong Install Command**
   - Symptom: "Cannot find module" or "Module not found"
   - Fix: Verify install command is `pnpm install --filter @codinit/web`

2. **Missing Environment Variables**
   - Symptom: Build succeeds but app crashes at runtime
   - Fix: Add all required env vars in Vercel dashboard

3. **Node.js Version Mismatch**
   - Symptom: Different build behavior
   - Fix: Set Node version to 20.x in Vercel settings

4. **Cache Issues**
   - Symptom: Old code being deployed
   - Fix: Clear cache in Vercel dashboard settings

### Desktop App Being Included

**Symptoms:**
- Build errors mentioning `apps/desktop/`
- Electron or Vite errors during build
- Deployment size much larger than expected

**Solutions:**
1. Verify Root Directory is set to `./` (not a subdirectory)
2. Check `.vercelignore` contains `apps/`
3. Confirm install command includes `--filter @codinit/web`
4. Clear Vercel cache and redeploy

### Environment Variables Not Working

**Symptoms:**
- App deploys but features don't work
- API calls fail
- Database connection errors

**Solutions:**
1. Check variable names match exactly (case-sensitive)
2. Ensure variables are set for correct environment
3. Remember: Only `NEXT_PUBLIC_*` vars available in browser code
4. Redeploy after adding variables (not automatic)

### Out of Memory Errors

**Symptoms:**
- Build times out
- "Out of memory" error in logs

**Solutions:**
1. Upgrade Vercel plan (Hobby has memory limits)
2. Check for memory leaks in build process
3. Optimize dependencies

---

## ✅ Verification Checklist

Before deploying, ensure:

- [ ] Local build succeeds with filtered install:
  ```bash
  rm -rf node_modules .next
  pnpm install --filter @codinit/web
  pnpm build
  ```
- [ ] All required environment variables listed in Vercel dashboard
- [ ] Install command is `pnpm install --filter @codinit/web`
- [ ] Build command is `pnpm build`
- [ ] Root directory is `./` or empty
- [ ] `.vercelignore` file is committed to repository
- [ ] `vercel.json` file is committed to repository
- [ ] Latest code pushed to connected branch
- [ ] Node.js version set to 18.x or 20.x

---

## 📊 Expected Build Output

When build succeeds, you should see:

```
✓ Creating optimized production build
✓ Compiled successfully
✓ Checking validity of types
✓ Collecting page data
✓ Generating static pages (14/14)
✓ Finalizing page optimization
✓ Collecting build traces

Route (app)                              Size     First Load JS
┌ ○ /                                    133 kB          384 kB
├ ○ /_not-found                          875 B            89 kB
├ ƒ /[taskId]                            9.8 kB          106 kB
└ ... (11 more routes)

○ = Static, ƒ = Dynamic (SSR)
```

**Build time:** ~2-3 minutes
**Total routes:** 14
**Framework:** Next.js 14.2.33

---

## 🆘 Getting Help

If you still experience issues:

1. **Check Deployment Logs**
   - Go to Vercel Dashboard → Deployments
   - Click on failed deployment
   - Copy error message

2. **Verify Configuration**
   - Screenshot your Vercel project settings
   - List environment variable names (not values)

3. **Test Locally**
   - Run the verification commands above
   - Share any error output

4. **Provide Context**
   - What changed since last successful deployment?
   - Is this a new project or existing one?
   - Which branch are you deploying?

---

## 📚 Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Next.js Deployment](https://nextjs.org/docs/deployment)
- [pnpm Workspaces](https://pnpm.io/workspaces)
- [E2B Documentation](https://e2b.dev/docs)
- [Supabase Setup Guide](https://supabase.com/docs)

---

**Last Updated:** October 2024
**Build Status:** ✅ Verified Working
**Recommended Node Version:** 20.x
**Recommended pnpm Version:** 10.17.1
