#!/usr/bin/env node
/**
 * LAUNCHPAD 🚀
 * Generate a launch-ready landing page for any app in 30 seconds
 * Just run: node launchpad.js "App Name" "One-liner" "Problem" "Solution" "Price"
 */

import fs from 'fs';

const OUTPUT_DIR = '/data/workspace/neuromatch/launches';

if (!fs.existsSync(OUTPUT_DIR)) fs.mkdirSync(OUTPUT_DIR, { recursive: true });

const args = process.argv.slice(2);

if (args.length < 3) {
  console.log(`
🚀 LAUNCHPAD — Generate launch pages instantly

Usage:
  node launchpad.js "App Name" "One-liner" "Problem" ["Solution"] ["Price"] ["CTA"]

Examples:
  node launchpad.js "ReplyForge" "AI writes emails in your style" "I hate writing follow-up emails" "One-click personalized replies" "9/mo" "Get Early Access"
  node launchpad.js "FocusGuard" "Block distracting sites" "I lose 2 hours to Twitter every day" "One-click blocker" "4/mo" "Try Free"
  node launchpad.js "SubSink" "Never forget to cancel subs" "I keep getting charged for stuff I forgot about" "Auto-detection + reminders" "5/mo"

Output:
  Creates /data/workspace/neuromatch/launches/[app-name]/index.html
  Ready to deploy to Vercel, Netlify, or Cloudflare Pages
  `);
  process.exit(1);
}

const [name, oneLiner, problem, solution = oneLiner, price = 'Free', cta = 'Get Early Access'] = args;
const slug = name.toLowerCase().replace(/[^a-z0-9]/g, '-').replace(/-+/g, '-');
const dir = `${OUTPUT_DIR}/${slug}`;
if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${name} — ${oneLiner}</title>
  <meta name="description" content="${oneLiner}">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
    body { font-family: 'Inter', sans-serif; }
    .gradient-text { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
    .gradient-bg { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
    .glow { box-shadow: 0 0 60px rgba(102, 126, 234, 0.4); }
  </style>
</head>
<body class="bg-gray-950 text-white min-h-screen">

  <!-- Nav -->
  <nav class="flex items-center justify-between px-8 py-6 max-w-6xl mx-auto">
    <div class="text-2xl font-bold">${name}</div>
    <a href="#waitlist" class="gradient-bg px-5 py-2 rounded-full font-semibold hover:opacity-90 transition">${cta}</a>
  </nav>

  <!-- Hero -->
  <section class="text-center px-4 py-24 max-w-4xl mx-auto">
    <div class="inline-block px-4 py-1 rounded-full border border-gray-700 text-sm text-gray-400 mb-8">
      Coming soon
    </div>
    <h1 class="text-5xl md:text-7xl font-extrabold mb-6 leading-tight">
      <span class="gradient-text">${oneLiner}</span>
    </h1>
    <p class="text-xl text-gray-400 mb-10 max-w-2xl mx-auto">
      ${problem}
    </p>
    <div class="flex flex-col sm:flex-row gap-4 justify-center">
      <a href="#waitlist" class="gradient-bg glow px-8 py-4 rounded-full font-bold text-lg hover:opacity-90 transition">
        ${cta} →
      </a>
      <a href="#how" class="px-8 py-4 rounded-full font-semibold text-lg border border-gray-700 hover:border-gray-500 transition">
        Learn more
      </a>
    </div>
  </section>

  <!-- Problem/Solution -->
  <section id="how" class="px-4 py-24 bg-gray-900">
    <div class="max-w-4xl mx-auto">
      <h2 class="text-3xl font-bold text-center mb-16">How it works</h2>
      <div class="grid md:grid-cols-3 gap-8">
        <div class="text-center p-6">
          <div class="text-4xl mb-4">1️⃣</div>
          <h3 class="text-xl font-bold mb-2">Sign up</h3>
          <p class="text-gray-400">Join the waitlist. First 100 get lifetime discount.</p>
        </div>
        <div class="text-center p-6">
          <div class="text-4xl mb-4">2️⃣</div>
          <h3 class="text-xl font-bold mb-2">We build it</h3>
          <p class="text-gray-400">Your feedback shapes the product. You tell us what matters.</p>
        </div>
        <div class="text-center p-6">
          <div class="text-4xl mb-4">3️⃣</div>
          <h3 class="text-xl font-bold mb-2">Get early access</h3>
          <p class="text-gray-400">Be first to use ${name}. For ${price}. Lock in this price forever.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- Solution Preview -->
  <section class="px-4 py-24">
    <div class="max-w-4xl mx-auto text-center">
      <h2 class="text-3xl font-bold mb-8">What you get</h2>
      <div class="bg-gray-900 rounded-2xl p-8 border border-gray-800">
        <p class="text-xl text-gray-300 mb-6">${solution}</p>
        <div class="flex flex-wrap justify-center gap-3">
          <span class="px-4 py-2 bg-gray-800 rounded-full text-sm">✨ One-click setup</span>
          <span class="px-4 py-2 bg-gray-800 rounded-full text-sm">🔒 No credit card required</span>
          <span class="px-4 py-2 bg-gray-800 rounded-full text-sm">⚡ Launch in minutes</span>
        </div>
      </div>
    </div>
  </section>

  <!-- Waitlist -->
  <section id="waitlist" class="px-4 py-24 gradient-bg">
    <div class="max-w-2xl mx-auto text-center">
      <h2 class="text-4xl font-bold mb-4">Join the waitlist</h2>
      <p class="text-xl mb-8 opacity-90">Be first to know when we launch. No spam.</p>
      <form class="flex flex-col sm:flex-row gap-4 max-w-md mx-auto" onsubmit="handleSubmit(event)">
        <input type="email" id="email" placeholder="your@email.com" required
          class="flex-1 px-6 py-4 rounded-full text-gray-900 font-semibold outline-none focus:ring-4 ring-white/30">
        <button type="submit" class="px-8 py-4 bg-gray-900 text-white rounded-full font-bold hover:bg-gray-800 transition">
          Join →
        </button>
      </form>
      <p id="success" class="hidden mt-4 text-lg font-semibold">🎉 You're in! We'll email you when we launch.</p>
      <p class="mt-4 text-sm opacity-75">No spam. Unsubscribe anytime.</p>
    </div>
  </section>

  <!-- Footer -->
  <footer class="px-4 py-8 text-center text-gray-500 text-sm">
    <p>© ${new Date().getFullYear()} ${name}. Built by humans, not robots.</p>
  </footer>

  <script>
    function handleSubmit(e) {
      e.preventDefault();
      const email = document.getElementById('email').value;
      const leadsFile = '${dir}/leads.json';
      // In production, send to your backend or use Formspree
      console.log('Lead:', email);
      document.getElementById('email').value = '';
      document.getElementById('success').classList.remove('hidden');
      // Save to localStorage for demo
      const leads = JSON.parse(localStorage.getItem('${slug}_leads') || '[]');
      leads.push({ email, date: new Date().toISOString() });
      localStorage.setItem('${slug}_leads', JSON.stringify(leads));
    }
  </script>

</body>
</html>`;

fs.writeFileSync(`${dir}/index.html`, html);

// Create a README for deployment
const readme = `# 🚀 ${name} Launch Page

Generated: ${new Date().toISOString()}

## Files
- \`index.html\` — Your launch page (this folder)
- \`leads.json\` — Created when people sign up

## Deploy in 60 seconds

### Vercel (recommended)
\`\`\`bash
npx vercel --prod
\`\`\`

### Netlify  
\`\`\`bash
npx netlify deploy --prod
\`\`\`

### Cloudflare Pages
1. Push to GitHub
2. Connect at dash.cloudflare.com
3. Deploy

## What to do next
1. Deploy this page
2. Share the link on Twitter, Reddit, LinkedIn
3. Collect emails with the waitlist form
4. When you have 100+ emails, build the product

## Stats to track
- Email signups (localStorage + Formspree/ConvertKit for real emails)
- Traffic sources
- Conversion rate

Good luck! 🚀
`;

fs.writeFileSync(`${dir}/README.md`, readme);

console.log(`
✅ LAUNCH PAGE READY!

📁 Location: ${dir}/index.html

🎯 What to do:
1. Open the HTML file to preview
2. Deploy to Vercel: npx vercel --prod
3. Share the link
4. Collect emails

💡 You'll see leads in localStorage. For real email collection,
   add ConvertKit, Mailchimp, or Formspree.

Ready to launch? Let's go 🚀
`);
