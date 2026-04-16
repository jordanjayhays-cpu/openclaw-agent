# AI Tools Guide for Jordan's Business

> Research date: April 2026 | Focus: LLM, Research, Content, Automation, Sales, Productivity, Analytics, Communication

---

## MUST-HAVE TOOLS (Top 5)

### 1. OpenClaw + Claude (Pro) — Priority 10/10
**What it does:** Your AI chief of staff — handles research, drafting, scheduling, automation orchestration, and daily operations.

**Cost:**
- OpenClaw: Already configured in your stack
- Claude Pro: $20/mo (monthly) or $17/mo (annual, billed $200 upfront)

**Why essential:** This is your operating system layer. Everything else feeds into it.

**Best use cases:**
- Research synthesis (replaces Perplexity for most queries)
- Drafting emails, messages, proposals
- Task automation planning
- Deep reasoning on complex decisions

**Integration:** Native. This is the system everything else connects to.

---

### 2. Notion — Priority 9/10
**What it does:** All-in-one workspace for notes, docs, databases, project management, calendar, and now email + AI agents.

**Cost:**
- Free: Individual use, 10 guests max
- Plus: $12/mo per person — custom forms, unlimited charts, unlimited file uploads, basic integrations
- Business: $18/mo per person — Notion Agent, AI Meeting Notes, Enterprise Search, SAML SSO, granular permissions
- Enterprise: Custom — zero data retention, SCIM, advanced security

**Why essential:** Jordan's workspace for COMARE, PISCO, Dealsmap. Single source of truth.

**Best use cases:**
- Project management across all three ventures
- Contact/client tracking
- Meeting notes (with AI Meeting Notes beta)
- Knowledge base for each business
- Notion Agent can handle repetitive tasks autonomously ($10 per 1,000 AI credits)

**Integration:** Already has Google Calendar integration. Webhooks + API for custom automations. Zapier/n8n connectivity.

---

### 3. Suno — Priority 8/10 (PK MUSIC specific)
**What it does:** AI music generation. Create full songs with vocals, instrumentation, and production from text prompts.

**Cost:**
- Free: 50 credits/day (10 songs), no commercial use
- Pro: $8/mo — 2,500 credits/mo (~500 songs), commercial use rights, v5.5 model, priority queue
- Premier: $24/mo — 10,000 credits/mo (~2,000 songs), everything in Pro

**Why essential for PK MUSIC:** Core creative tool. Generates background music, vocal tracks, and production elements for Filipino music content and branding.

**Best use cases:**
- Background music for content
- Song creation and prototyping
- Custom audio branding for PK MUSIC
- Split songs into stems for remixing

**Integration:** API access (Enterprise tier). Export stems for further editing in Descript or DAWs.

---

### 4. n8n — Priority 8/10
**What it does:** Workflow automation platform (open-source). Connects apps, automates repetitive tasks, and can run AI agents.

**Cost:**
- Free: Limited, self-hosted only
- Cloud Starter: ~€29/mo (hosted by n8n)
- Cloud Pro: ~€79/mo — more executions, multi-user
- Cloud Business: ~€199/mo — advanced features
- Self-hosted: Free (Community edition), paid for Business/Enterprise features

**Why essential:** The automation backbone. Connects Jordan's tools into coherent workflows without code.

**Best use cases:**
- Automating lead follow-ups for PISCO
- Connecting Notion to other apps
- Automated reporting across businesses
- AI agent orchestration (AutoGen-level workflows without the complexity)
- Appointment/scheduling automations

**Integration:** 400+ integrations (Google Calendar, Notion, Telegram, Slack, HubSpot, PostgreSQL, MySQL, Redis, and more). REST API support. Webhook support. Native AI nodes.

**vs Zapier:** n8n is cheaper at scale, open-source, more flexible. Zapier is easier for non-technical users. For Jordan's stack, n8n is the better long-term bet.

---

### 5. Apollo.io — Priority 7/10 (for PISCO BD)
**What it does:** Sales intelligence and engagement platform. B2B database of 275M+ contacts, email finding, sequencing, and pipeline management.

**Cost:**
- Free: 50 credits, basic features, unlimited email campaigns (Gmail only)
- Starter: ~$39/mo — 500 credits/mo, basic sequences
- Professional: ~$64/mo — 3,000 credits/mo, full features
- Organization: ~$104/mo — 10,000 credits/mo, team features

*Credit usage: ~$0.025 per credit at scale. 10,000 credits/mo ≈ $250 worth at full retail.*

**Why essential for PISCO:** Core BD tool. Finding decision-makers at Filipino companies, enriching leads, automating outreach sequences.

**Best use cases:**
- Lead enrichment for PISCO placements
- Email finding (Hunter.io-level but with more data)
- Automated outreach sequences
- CRM sync (Salesforce, HubSpot, Pipedrive)
- Opportunity pipeline tracking

**Integration:** HubSpot, Salesforce, Outreach, SalesLoft, Marketo, LinkedIn. Zapier + webhook support.

---

## NICE-TO-HAVE TOOLS (Top 10)

### 6. ElevenLabs — Priority 7/10
**What it does:** AI voice generation. Text-to-speech, voice cloning, speech-to-text, sound effects, and voice agents.

**Cost:**
- Free: 10k credits/mo, 3 projects in Studio, no commercial use
- Starter: $6/mo — 30k credits/mo, commercial license, instant voice cloning
- Creator: $11/mo — 121k credits/mo, professional voice cloning
- Pro: $99/mo — 600k credits/mo, 44.1kHz PCM audio via API
- Scale: $299/mo — 1.8M credits/mo, 3 workspace seats, team collaboration

**Best for PK MUSIC:** Voice-over for content, custom voice clones for brand consistency, dubbing.

**Integration:** API access on all paid plans. Embeddable players. Dubbing Studio for video localization.

---

### 7. Descript — Priority 7/10
**What it does:** All-in-one video + podcast editor with AI features. Text-based editing, transcription, AI voice clones, screen recording, and AI-powered production.

**Cost:**
- Free: 60 min/mo, basic AI tools
- Hobbyist: $16/mo (monthly) or $24/mo annual — 10 hrs media/mo, 400 AI credits
- Creator: $24/mo or $35/mo annual — 30 hrs/mo, 800 AI credits, 4K export
- Business: $50/mo or $65/mo annual — 40 hrs/mo, 1500 AI credits, team features, Brand Studio
- Enterprise: Custom

**Best use cases:**
- Video editing for PK MUSIC content
- Podcast production
- AI-powered clip creation
- Transcription and captions
- AI speech with custom voice clones

**Integration:** Native export. Underlord AI co-editor. Adobe Premiere + DaVinci Resolve export.

---

### 8. Fireflies.ai — Priority 6/10
**What it does:** AI meeting notes. Auto-transcribes Zoom, Google Meet, Microsoft Teams, and 100+ other sources. AI summaries, action item extraction, and analytics.

**Cost:**
- Free: Unlimited transcription, 800 mins storage/seat, limited AI summaries
- Pro: $18/seat/mo (annual) or $10/seat/mo — unlimited AI summaries, 8,000 mins storage, AI credits (20/mo), integrations
- Business: $29/seat/mo (annual) — unlimited storage, video recording, conversation intelligence, 30 AI credits
- Enterprise: $39/seat/mo — SSO, SCIM, HIPAA, custom retention, 50 AI credits

**Best use cases:**
- PISCO BD calls — auto-transcribe client conversations
- IE classes — record and summarize lectures
- Meeting action item tracking
- Team knowledge capture

**Integration:** Notion, HubSpot, Salesforce, Slack, Zapier, API access. Chrome extension for live transcriptions.

---

### 9. Opus Clip — Priority 6/10
**What it does:** Turn long videos into viral short clips. AI reframes, captions, and optimizes content for TikTok, YouTube Shorts, and Instagram Reels.

**Cost:**
- Free: Limited, watermark, 3-day storage
- Starter: $15/mo — AI clipping, auto-reframe, captions, 29-day storage
- Pro: $29/mo — AI copilot, B-Roll generator, AI voice-over, bulk export, social scheduler

**Best use cases:**
- Repurposing long-form content into short clips
- PK MUSIC content repurposing
- Auto-captioning for accessibility and engagement
- A/B testing clip formats

**Integration:** Zapier integration, API access, Adobe Premiere Pro export, DaVinci Resolve export.

---

### 10. Mixpanel — Priority 6/10 (for Dealsmap / Product Analytics)
**What it does:** Product analytics. Tracks user behavior, funnels, retention, and revenue attribution.

**Cost:**
- Free: Up to 1M monthly events, 5 saved reports, 10K session replays
- Growth: 1M events free, then $0.28 per 1K events, unlimited reports
- Enterprise: Unlimited events, advanced governance, custom support

**Best use cases:**
- Dealsmap product usage tracking
- User behavior analytics for any digital product
- A/B testing impact measurement
- Retention cohort analysis

**Integration:** SDKs for web, iOS, Android, Python, Ruby, Go, Java, Node.js. Data warehouse connectors. Segment integration.

---

### 11. Calendly — Priority 6/10
**What it does:** Scheduling automation. Eliminates back-and-forth by letting prospects book time directly.

**Cost:**
- Free: 1 event type, 1 calendar, basic features
- Standard: $10/seat/mo — unlimited event types, multiple calendars, integrations (Stripe, HubSpot, Mailchimp)
- Teams: $16/seat/mo — round-robin, lead routing, Salesforce sync
- Enterprise: $15k+/yr — SSO, SAML, SCIM, dedicated support

**Best use cases:**
- PISCO client discovery calls — embed Calendly link in outreach emails
- IE networking — easy scheduling with alumni/recruiters
- Demo booking for Dealsmap

**Integration:** Google Calendar, Outlook, Zoom, GoToMeeting, HubSpot, Salesforce, Stripe, Zapier, webhooks.

---

### 12. HubSpot CRM — Priority 6/10 (for PISCO)
**What it does:** Full CRM with marketing, sales, service, and operations hubs. Free CRM is genuinely useful; paid tiers unlock serious automation.

**Cost:**
- Free CRM: Contact management, deal tracking, live chat, email templates, forms, landing pages
- Starter Marketing: $15/mo — email marketing, automation, list segmentation
- Pro Marketing: $800/mo — advanced automation, A/B testing, custom reporting
- Sales Hub: $90/seat/mo (Starter) — sequences, Playbooks, calling
- Enterprise: Custom pricing

**Best use cases:**
- PISCO sales pipeline management
- Lead nurturing for COMARE maintenance clients
- Dealsmap customer tracking
- Email campaigns and automation

**Integration:** Native with 1,000+ apps including Notion, Slack, Zapier. Strong API.

---

### 13. Zapier — Priority 6/10 (backup to n8n)
**What it does:** No-code workflow automation. Connects 8,000+ apps with a visual editor.

**Cost:**
- Free: 100 tasks/mo, two-step Zaps only
- Professional: $19.99/mo — unlimited Zaps, multi-step, webhooks, AI fields
- Team: $69/mo — 5 users, shared Zaps, SAML SSO
- Enterprise: Custom — unlimited users, advanced admin

**Best use cases:** Simpler automations that n8n handles. Good as a bridge when n8n isn't set up. Canva and Descript have native Zapier integrations.

**Integration:** 8,000+ app integrations. MCP server. Tables + Forms now included on all plans.

---

### 14. Raycast Pro — Priority 5/10
**What it does:** macOS productivity launcher with AI. Fast app launching, clipboard history, window management, and built-in AI that accesses dozens of models.

**Cost:**
- Free: Basic features
- Pro: $8/mo — AI access (dozens of models including GPT-4o, Claude, Gemini, Mistral, Groq), Cloud Sync, unlimited clipboard history, custom themes, Notes
- Advanced AI add-on: +$5/mo — access to GPT-4.1, Claude 4.5 Sonnet, Opus, DeepSeek, Groq models

**Best use cases:**
- macOS-native AI assistant without tab-switching
- Quick calculations, code generation, text processing
- Window management automation
- Clipboard history across machines

**Integration:** macOS system-level. API keys for custom AI model configuration. 300+ native integrations.

---

### 15. Google Analytics — Priority 5/10
**What it does:** Web and app analytics. Traffic sources, user behavior, conversions, and audience insights.

**Cost:**
- Free: Web analytics, basic reporting, 10 million events/mo (GA4)
- GA4 + BigQuery: Free tier included
- GA4 360: $150k+/yr (enterprise — likely overkill for Jordan)

**Best use cases:**
- Dealsmap traffic tracking
- PK MUSIC content performance
- Marketing attribution for PISCO outreach
- Conversion funnel analysis

**Integration:** Native Google integrations. Measurement Protocol API. BigQuery export. Google Tag Manager. WordPress, Shopify, etc.

---

## FREE TOOLS (Top 10)

### 1. ChatGPT (Free)
GPT-4o access with rate limits. Great for daily tasks. Use before paying for Plus.

**Limitation:** Usage caps on advanced models during high traffic.

---

### 2. Claude (Free)
Full web/ desktop access. Strong writing, analysis, and coding. Memory across conversations.

**Limitation:** Usage limits apply.

---

### 3. Notion (Free)
Solid workspace for individuals. Unlimited pages, basic databases, limited guests (10).

**Limitation:** AI features are limited trial only on Free plan.

---

### 4. Obsidian (Free)
Local-first knowledge management. No cloud sync, no publishing — but your data stays yours.

**Cost:** Free (with Catalyst for early access and community badges — $96 one-time, or Sync $8/mo, Publish $4/mo)

**Limitation:** No built-in AI (add via plugins or API). Data stored locally.

---

### 5. Fireflies.ai (Free)
Unlimited transcription (with limits), limited AI summaries, 800 mins storage.

**Limitation:** Not full-featured AI summaries.

---

### 6. Mixpanel (Free)
1M events/mo free — genuinely useful for startups. Growth plan is pay-as-you-go after that.

**Limitation:** 5 saved reports only on Free.

---

### 7. Suno (Free)
50 credits/day (10 songs), no commercial use. Good for prototyping and testing.

**Limitation:** No commercial rights, watermarked, shared queue.

---

### 8. Descript (Free)
60 min transcription/mo. Basic AI tools. Good to test before committing.

**Limitation:** Very limited on free tier.

---

### 9. OpusClip (Free)
Basic clipping with watermark. Limited storage (3 days). Good for testing.

**Limitation:** Watermark, 3-day storage limit.

---

### 10. Zapier (Free)
100 tasks/mo, two-step Zaps only. Good for simple automations like email-to-Notion.

**Limitation:** Only 2-step Zaps, no multi-step on free.

---

## LLM MODEL DEEP-DIVE

### When to Use What

| Model | Best For | Cost (API) | Cost (App) | Context Window |
|-------|----------|------------|------------|----------------|
| **GPT-4o** | General purpose, speed, API integrations | $2.50-5/1M tokens | $20/mo (Plus) | 128k |
| **Claude 4 Sonnet** | Deep reasoning, long documents, writing | $3-15/1M tokens | $20/mo (Pro) | 200k |
| **Claude 4 Opus** | Complex research, highest quality | $15-75/1M tokens | $100+/mo (Max) | 200k |
| **Gemini 2.5 Pro** | Long context, multimodal, code | ~$1.25-5/1M tokens | Free (limited) | 1M |
| **Mistral Large** | Europe-based, cost-effective, reasoning | ~$2-8/1M tokens | Various | 128k |
| **o3/o4-mini** (OpenAI) | Specialized reasoning tasks | $1.10-110/1M tokens | Via API | 200k |
| **DeepSeek-R1** | Cost-sensitive reasoning, open weights | Very cheap (~$0.5/1M) | Free (some UIs) | 64k |

### Jordan's Stack Recommendation

**Daily Driver:** OpenClaw with current model (minimax-m2.7) for operations

**Research & Deep Analysis:** Claude Pro ($20/mo) — projects, strategy, complex synthesis

**Quick Tasks:** ChatGPT Free — simple queries, brainstorms

**Cost-Sensitive Tasks:** DeepSeek-R1 via API (very cheap) — simple automation scripts, summaries

**macOS System-Level:** Raycast Pro with model switching

---

## RESEARCH AI DEEP-DIVE

### Perplexity — Real-Time Web Research
**What it does:** Answers questions with live web citations. Threaded research with source tracking.

**Cost:**
- Free: Limited queries, basic features
- Pro: $20/mo or $15/mo (annual) — unlimited Pro searches, Claude 3.5 Sonnet + GPT-4o, Copilot, 500 Pro+ searches/mo

**Best for:** Fast fact-checking, news queries, product comparisons

**vs Claude Deep Research:** Perplexity is faster, live. Claude is deeper. Use Perplexity for quick answers, Claude for comprehensive reports.

---

### Claude (Anthropic) — Deep Research
**What it does:** Autonomous deep research on any topic. Generates comprehensive reports with citations.

**Cost:** Included in Claude Pro ($20/mo) and Max ($100+/mo)

**Best for:** Market research, competitive analysis, due diligence

**Note:** OpenClaw already provides research capabilities. Claude's deep research mode is for when you need formal 10-20 page reports.

---

### NotebookLM — Document Research
**What it does:** Upload PDFs, articles, videos (YouTube), and query them conversationally. Generates audio summaries (Audio Overview).

**Cost:** Free (Google)

**Best for:** Researching large documents for IE classes. Uploading contracts, papers, and asking questions.

**Limitation:** Requires uploading documents to Google's servers (privacy consideration).

---

### Consensus — Academic Research
**What it does:** Search academic papers, get AI-generated summaries of findings, see consensus on scientific questions.

**Cost:**
- Free: Limited searches
- Academic: $9.99/mo — unlimited searches, PDF download, citation export

**Best for:** Evidence-based claims for PISCO proposals or COMARE maintenance contracts.

---

### Scite — Research Paper Analysis
**What it does:** Shows how papers cite each other (supporting, contrasting, or mentioning). Smart Citations for deeper analysis.

**Cost:**
- Free: Basic search
- Pro: $29/mo — unlimited searches, Smart Citations, statement verification
- Institutional: Custom

**Best for:** Due diligence on claims, academic integrity checks.

---

## CONTENT AI DEEP-DIVE

### Suno — Music Generation (PK MUSIC core)
**Priority: 8/10**

Already covered in Must-Have. Core creative tool.

**Pro Tip:** Use custom audio upload feature to incorporate Filipino musical elements. Suno v5.5 is the best model — use Pro tier for priority access.

---

### ElevenLabs — Voice/TTS
**Priority: 7/10**

Already covered in Nice-to-Have.

**Key feature:** Professional voice cloning from 30+ minutes of audio. Can create a consistent brand voice for PK MUSIC.

---

### Canva AI — Thumbnails & Graphics
**What it does:** Design platform with AI-assisted design, Magic Write (text generation), Magic Eraser, image generation.

**Cost:**
- Free: Basic features
- Pro: $12.99/mo — 1 seat, Brand Kit, 5M storage, Magic Write
- Teams: $14.99/seat/mo — collaborative features, shared brand templates
- Enterprise: Custom

**Best use cases:**
- PK MUSIC thumbnails and social graphics
- PISCO proposal decks (with Canva's AI presentation builder)
- Quick marketing visuals without designer

**Integration:** Native with Instagram, Facebook, LinkedIn, Slack. Zapier + PowerPoint integration.

---

### Descript — Video Editing
**Priority: 7/10**

Already covered in Nice-to-Have.

---

### Opus Clip — YouTube Shorts
**Priority: 6/10**

Already covered in Nice-to-Have.

---

## AUTOMATION AI DEEP-DIVE

### n8n — Priority 8/10 (Primary)
### Zapier — Priority 6/10 (Backup)
### Make.com — Priority 5/10

**What it does (Make):** Visual automation like Zapier but with more complex workflow capabilities.

**Cost:**
- Free: 1,000 ops/mo
- Core: $9/seat/mo — 10,000 ops/mo
- Pro: $29/seat/mo — 50,000 ops/mo
- Teams: $49/seat/mo — 300,000 ops/mo, collaboration
- Enterprise: Custom

**vs n8n:** Make is more visual, slightly easier. n8n is more powerful at scale and cheaper self-hosted.

---

### AutoGen — Multi-Agent Orchestration
**What it does:** Microsoft's open-source framework for building multi-agent AI applications.

**Cost:** Free (open-source, self-hosted)

**Best for:** Jordan's future when building agentic workflows for PISCO. Requires technical setup.

**Integration:** LangChain integration, OpenAI API, Azure AI.

---

### LangChain — Agent Frameworks
**What it does:** Framework for building AI agents and chains. Powers RAG systems and agentic workflows.

**Cost:** Free (open-source), LangSmith ($100+/mo for observability)

**Best for:** When Jordan needs to build custom agentic experiences into his products.

---

## SALES/BD AI DEEP-DIVE

### Apollo — Priority 7/10 (Primary for PISCO)

Already covered in Must-Have. Core BD tool.

---

### Hunter — Email Finding
**What it does:** Find and verify email addresses by domain or name.

**Cost:**
- Free: 25 searches/mo
- Starter: $49/mo — 500 searches/mo, 100 verifications/mo
- Growth: $149/mo — 2,500 searches/mo, 1,000 verifications/mo
- Business: $399/mo — 10,000 searches/mo, 5,000 verifications/mo

**Best for:** PISCO outreach — find HR/operations contacts at Filipino companies.

**vs Apollo:** Apollo has more data (275M+ contacts) and broader BD features. Hunter is more focused on email finding. Apollo is better value at PISCO scale.

---

### Clearbit — Data Enrichment
**What it does:** B2B data enrichment for leads and companies. Real-time data enrichment via API.

**Cost:**
- Free: Limited (enriches 5-50 records)
- Starter: ~$500/mo (billed annually) — 5,000 enrichments/mo
- Growth: ~$1,500/mo — 20,000 enrichments/mo
- Company Data API: ~$0.10-$1.50 per lookup depending on data type

**Best for:** Enriching PISCO leads with company technographics and funding data.

**Integration:** HubSpot CRM native integration, Salesforce, Marketo, Slack, Zapier.

---

### LinkedIn Sales Navigator — Outreach
**What it does:** Advanced LinkedIn search, lead recommendations, InMail messaging, and profile insights.

**Cost:**
- Free: Basic LinkedIn search
- Starter: $99/mo — 50 InMails, unlimited searches
- Professional: $199/mo — 150 InMails, 15 InMail messages/mo, full features
- Enterprise: Custom with TeamLink

**Best for:** PISCO outreach to HR decision-makers at Filipino companies. Finding warm connections.

**vs Apollo:** Apollo is better for bulk data and sequences. Sales Navigator is better for relationship-based outreach.

---

### Crunchbase — Funding/Company Data
**What it does:** Company funding data, investment rounds, acquisition data, and investor tracking.

**Cost:**
- Free: Basic company info, limited funding data
- Pro: $39/mo — full funding data, advanced filters, alerts
- Enterprise: Custom — API access, bulk data, full integrations

**Best for:** PISCO due diligence — check if Filipino companies have funding, understand their financial position before outreach.

**Integration:** API access on Pro+. Salesforce integration.

---

## PRODUCTIVITY AI DEEP-DIVE

### Notion AI — Priority 9/10 (Must-Have)
Already covered. AI features now deeply integrated.

---

### Obsidian — Knowledge Management
**What it does:** Local-first, markdown-based knowledge base. PKM (Personal Knowledge Management) tool with graph view.

**Cost:** Free (self-hosted/local), Catalyst $96 one-time, Sync $8/mo, Publish $4/mo

**Best for:** Long-term knowledge building. Works offline. Great for IE research, project notes.

**vs Notion:** Notion is collaborative, cloud-first. Obsidian is private, local-first. Notion is better for active projects; Obsidian is better for long-term knowledge.

**Integration:** Dataview plugin, 70+ community plugins, Templater, full mobile apps. Can connect to OpenClaw via API.

---

### Raycast — macOS AI — Priority 5/10

Already covered in Nice-to-Have.

---

### Rewind — Memory for Meetings
**What it does:** Records everything on your Mac (with consent). Transcribes, summarizes, and lets you search your meeting history.

**Cost:**
- Free: Basic (limited)
- Pro: $15/mo — unlimited transcriptions, summaries, search, clipboard history
- Team: $30/seat/mo — shared recordings, shared meetings

**Best for:** Can't remember what was said in a call last week. Searchable meeting history.

**Integration:** Notion, Confluence, Slack, Linear. macOS only.

**Privacy Note:** Records your screen/audio — check company policies before using with client data.

---

## COMMUNICATION AI

### Telegram Bots — Already Integrated
OpenClaw already has Telegram integration. Telegram bots can be built via BotFather API or n8n.

**Best uses:**
- Automated client notifications for PISCO
- COMARE maintenance alerts
- Dealsmap updates
- Meeting reminders

**Cost:** Free (Telegram API). n8n or custom code for automation logic.

---

### Slack/Discord Bots
**Slack Bot (via OpenClaw skill):** Already available as a skill.

**Discord:** Custom bot via Discord API or third-party tools (Canary, MEE6, Dyno).

**Best for:** Team communication for Jordan's businesses. Discord may be more relevant for PK MUSIC community.

---

### Email AI
**Superhuman:** AI-powered email client (iOS + macOS). Keyboard-first, AI assistance.

**Cost:**
- $30/mo (or $270/yr) — iOS, macOS, web
- Includes AI (Superhuman AI)

**Best for:** High-volume email users. Keyboard shortcuts make it fast. AI features include draft generation, summarization.

**vs Notion Mail + Google Workspace:** Jordan already has Google Calendar. Notion Mail (beta) syncs with Gmail — could replace Superhuman at lower cost once stable.

---

### Calendly Scheduling AI — Priority 6/10

Already covered.

---

## INTEGRATION PLAN FOR OPENCLAW

### Phase 1: Foundation (Month 1)
Priority 10/10: **OpenClaw + Claude Pro** — Ensure this is working perfectly

Priority 9/10: **Notion** — Set up workspace for PISCO, COMARE, Dealsmap. Migrate current data.

Priority 8/10: **n8n** — Self-hosted on Jordan's machine or small VPS. Start with 3 key workflows:
1. Email → Notion task (PISCO leads)
2. Calendly → Telegram reminder
3. Notion database → weekly summary

---

### Phase 2: Growth (Month 2-3)
Priority 8/10: **Suno** — Set up PK MUSIC audio pipeline

Priority 7/10: **Apollo** — Import PISCO contacts, build first sequence

Priority 7/10: **ElevenLabs** — Create brand voice for PK MUSIC (if budget allows)

Priority 7/10: **Descript** — Set up video editing workflow for PK MUSIC content

Priority 6/10: **Fireflies** — Connect to IE calls + PISCO client calls. Auto-log to Notion.

Priority 6/10: **Opus Clip** — Start repurposing long-form content into shorts

---

### Phase 3: Scale (Month 4+)
Priority 6/10: **Mixpanel** — Instrument Dealsmap for product analytics

Priority 6/10: **Calendly** — Embed in PISCO outreach emails for easy booking

Priority 6/10: **HubSpot CRM** — If PISCO pipeline grows beyond Notion's capabilities

Priority 6/10: **Raycast Pro** — If Jordan wants system-level AI on Mac without tab-switching

Priority 5/10: **LinkedIn Sales Navigator** — Supplement Apollo for relationship-based PISCO outreach

Priority 5/10: **Make.com** — If n8n setup becomes too technical for certain team members

---

## QUICK-REFERENCE PRICING TABLE

| Tool | Free | Entry Paid | Mid Tier | Notes |
|------|------|------------|----------|-------|
| **Claude (App)** | $0 | $17/mo (Pro, annual) | $100+/mo (Max) | Annual saves ~$36 |
| **ChatGPT (App)** | $0 | $17/mo (Plus, annual) | $20/mo (monthly) | Free has GPT-4o |
| **Notion** | ✓ | $12/mo | $18/mo | Custom Agents $10/1K credits |
| **Suno** | ✓ (50/day) | $8/mo (Pro) | $24/mo (Premier) | Commercial rights = Pro+ |
| **n8n** | ✓ (self-hosted) | ~€29/mo (cloud) | ~€79-199/mo | Self-hosted = free |
| **Apollo** | ✓ (50 credits) | ~$39/mo | ~$64/mo | Credits roll over |
| **ElevenLabs** | ✓ (10K credits) | $11/mo (Creator) | $99/mo (Pro) | Credits/mo listed |
| **Descript** | ✓ (60 min) | $16/mo (Hobbyist) | $24/mo (Creator) | Annual = 35% off |
| **Fireflies** | ✓ (800 mins) | $10/seat/mo | $19/seat/mo | Annual = 44% off |
| **OpusClip** | ✓ (watermarked) | $15/mo (Starter) | $29/mo (Pro) | 3-day free storage |
| **Mixpanel** | ✓ (1M events) | ~$0 (Growth) | Custom | 1M free is generous |
| **Calendly** | ✓ (1 event type) | $10/seat/mo | $16/seat/mo | Annual = 16-20% off |
| **HubSpot CRM** | ✓ | $15/mo (Starter) | $90/seat/mo (Sales) | Free CRM is solid |
| **Zapier** | ✓ (100 tasks) | $19.99/mo | $69/mo (Team) | Annual = 33% off |
| **Raycast Pro** | ✓ | $8/mo | +$5/mo (Advanced AI) | macOS only |
| **Canva** | ✓ | $12.99/mo (Pro) | $14.99/seat/mo (Teams) | Has Magic Write |
| **NotebookLM** | ✓ | — | — | Entirely free |
| **Obsidian** | ✓ | $8/mo (Sync) | $96 one-time (Catalyst) | Local-first |
| **Apollo (PISCO BD)** | ✓ | ~$39/mo | ~$64/mo | 275M+ contacts |
| **Hunter (Email)** | ✓ (25/mo) | $49/mo | $149/mo | Email finding |
| **Crunchbase** | ✓ (basic) | $39/mo | Custom | Funding data |
| **LinkedIn SN** | ✓ | $99/mo (Starter) | $199/mo (Pro) | Outreach tool |

---

## FINAL RECOMMENDATIONS

**Start here (this week):**
1. Already using OpenClaw + Claude — good
2. Ensure Notion is set up for PISCO, COMARE, Dealsmap
3. Explore Notion Agent for any repetitive task

**This month:**
4. Set up n8n with Calendly → Telegram workflow
5. Get Suno Pro for PK MUSIC (commercial rights matter)
6. Sign up for Apollo Free, test with 50 credits

**Next 3 months:**
7. Apollo Professional for PISCO BD
8. Fireflies for meeting notes
9. Descript for PK MUSIC video content

**Nice to add when budget allows:**
10. ElevenLabs Creator for voice cloning
11. OpusClip for content repurposing
12. Mixpanel for Dealsmap analytics

---

*Document compiled: April 2026 | Data sourced from tool pricing pages (April 2026). Prices may change. Check tool websites for current pricing before committing.*
