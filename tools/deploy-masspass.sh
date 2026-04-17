#!/bin/bash
# Deploy MASSAGE-PASS landing page to Vercel

PROJECT_DIR="/data/workspace/PROJECTS/MASSAGE-PASS"

echo "🚀 Deploying MASSAGE-PASS to Vercel..."

cd "$PROJECT_DIR" || exit 1

# Check if vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "Installing Vercel CLI..."
    npm install -g vercel
fi

# Deploy to Vercel (production)
echo "Running vercel deploy..."
vercel --prod --yes

echo "✅ Deployment complete!"
echo "🌐 Check your Vercel dashboard for the live URL"