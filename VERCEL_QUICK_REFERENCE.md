# Vercel Deployment - Quick Reference Card

## 🚀 One-Liner Setup Check

```bash
./scripts/verify-vercel-setup.sh
```

If this passes ✅ - your code is ready for Vercel!

---

## ⚙️ Vercel Dashboard Settings (Copy-Paste Ready)

| Setting | Value |
|---------|-------|
| Install Command | `pnpm install --filter @codinit/web` |
| Build Command | `pnpm build` |
| Output Directory | `.next` |
| Root Directory | `./` |
| Node.js Version | `20.x` |

---

## 🔑 Required Environment Variables

### Must Have (Critical)
```bash
E2B_API_KEY=
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
```

### At Least One LLM Provider
```bash
OPENAI_API_KEY=          # Recommended
# OR
ANTHROPIC_API_KEY=
# OR
GOOGLE_GENERATIVE_AI_API_KEY=
```

### Optional but Recommended
```bash
KV_REST_API_URL=         # Auto-set if using Vercel KV
KV_REST_API_TOKEN=       # Auto-set if using Vercel KV
NEXT_PUBLIC_POSTHOG_KEY= # Analytics
```

---

## 🐛 Common Issues & Quick Fixes

### "Module not found"
**Fix:** Change install command to `pnpm install --filter @codinit/web`

### "Build succeeds but app doesn't work"
**Fix:** Add missing environment variables in Vercel Dashboard

### "Desktop app being included"
**Fix:** 
1. Set Root Directory to `./`
2. Check `.vercelignore` contains `apps/`
3. Clear Vercel cache and redeploy

### "Deployment times out"
**Fix:** Node version to 20.x, upgrade Vercel plan if on free tier

---

## 📝 Pre-Deployment Checklist

Quick checklist before deploying:

- [ ] `./scripts/verify-vercel-setup.sh` passes
- [ ] All required env vars set in Vercel
- [ ] Install command correct
- [ ] Latest code pushed to repo
- [ ] Vercel connected to correct branch

---

## 🔗 Quick Links

- **Full Guide:** See `VERCEL_DEPLOYMENT_GUIDE.md`
- **Troubleshooting:** See `WORKSPACE.md` § Troubleshooting
- **Verification Script:** `./scripts/verify-vercel-setup.sh`

---

## 💡 Quick Test

Test your setup matches Vercel's environment:

```bash
rm -rf node_modules .next
pnpm install --filter @codinit/web
pnpm build
```

**Success?** ✅ Your Vercel deployment will work!
**Failed?** ❌ Fix errors before deploying.

---

**Remember:** After adding/changing environment variables in Vercel, you must redeploy (it's not automatic).
