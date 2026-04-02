# 100 Ways Americans Use OpenClaw

*A curated collection of specific, real-world use cases for OpenClaw AI agents — organized by category.*

*Primary source: [awesome-openclaw-usecases](https://github.com/hesamsheikh/awesome-openclaw-usecases) by Hesam Sheikh. Additional use cases synthesized from community examples, Discord discussions, and documented workflows.*

---

## Business Uses (1–20)

**1. Multi-Channel Customer Service**
Manage WhatsApp Business, Instagram DMs, Gmail, and Google Reviews from a single AI-powered inbox. The agent auto-responds to FAQs, handles appointment requests, escalates complaints to humans, and runs in test mode so you can demo it to clients before going live. One restaurant reduced response time from 4+ hours to under 2 minutes, handling 80% of inquiries automatically.

**2. Local CRM with DenchClaw**
Turn OpenClaw into a fully local CRM with one `npx denchclaw` install. Track leads with natural language queries ("show me companies with more than 5 employees"), switch between Table/Kanban/Calendar/Gantt views, and manage your pipeline from Telegram while on the go — all data stays on your machine.

**3. Earnings Tracker**
Every Sunday, the agent scans the upcoming earnings calendar for tech and AI companies (NVDA, MSFT, GOOGL, META, etc.) and posts a preview to Telegram. You confirm which ones to track, and the agent schedules one-shot cron jobs to auto-deliver earnings summaries — beat/miss, revenue, EPS, key metrics, AI highlights, and forward guidance — right after each report drops.

**4. Autonomous Project Management**
Spawn subagents as project managers, each tracking their own `STATE.yaml` file. Agents work in parallel on independent tasks, updating state on progress. The main session acts as CEO — strategy only, zero execution. Git commits serve as a full audit trail of all project activity.

**5. Event Guest Confirmation**
Give OpenClaw a guest list with phone numbers and have it call each person via SuperCall to confirm attendance, collect dietary restrictions, plus-ones, and arrival times. The AI introduces itself as your event coordinator with a friendly persona, then compiles a full summary: who confirmed, who declined, who didn't pick up, and any special notes.

**6. Market Research & Product Factory**
Use the Last 30 Days skill to mine Reddit and X for real pain points in any niche. The agent surfaces top complaints, feature requests, and gaps in existing solutions — then offers to build an MVP that solves one of them. Entrepreneurship on autopilot: find problems, validate demand, ship solutions, all through text messages.

**7. Pre-Build Idea Validator**
Before writing a single line of code, the agent checks GitHub (143K+ repos), Hacker News, npm, PyPI, and Product Hunt and returns a `reality_signal` score (0–100). High score (>70) means stop and discuss; medium (30–70) means pivot suggestions; low score (<30) means the space is wide open. Prevents the most expensive solo-builder mistake: solving a problem that's already been solved.

**8. Lead Enrichment & Outreach**
Drop a CSV of raw leads into Telegram and the agent enriches each one with company data, LinkedIn profiles, and recent news. Then drafts personalized cold emails based on each company's context — saved to a document ready for review and sending.

**9. Competitive Price Monitoring**
Track competitor pricing across websites and receive alerts when prices change. The agent fetches pages, compares against your baseline, and notifies you via Telegram when a competitor drops prices or runs promotions you should match or counter.

**10. Contract Review & Summarization**
Drop a PDF contract into chat and the agent flags unusual clauses, highlights liability concerns, summarizes key obligations, and identifies deadlines and renewal terms. Flag anything that should go to a lawyer before signing.

**11. Invoice Generation & Tracking**
Describe a billing situation and the agent generates a professional invoice, tracks which invoices are sent and paid, sends payment reminders, and follows up on overdue accounts — all via email.

**12. Hiring & Resume Screening**
Feed resumes into the agent and describe your ideal candidate profile. The agent scores each resume, highlights relevant experience, flags red flags, and ranks candidates — turning a 4-hour screening task into a 10-minute review of ranked candidates.

**13. Business Dashboard Monitoring**
Spawn parallel sub-agents to fetch GitHub stars, Twitter mentions, Polymarket volume, and system health metrics simultaneously. The agent aggregates results into a formatted dashboard posted to Discord every 15 minutes, with alerts when metrics cross thresholds.

**14. Vendor Management**
Track vendor contracts, renewal dates, and performance. The agent sends reminders before renewals, logs communication history, and compares vendor performance against SLA terms.

**15. Trade Show Lead Capture**
After a conference, feed the agent business cards or LinkedIn connections and have it enrich each lead with company data, determine if they're a good fit based on your ICP, and rank them by priority for follow-up.

**16. Competitor Reddit/X Monitoring**
Schedule daily scans of Reddit and X for mentions of your competitors. The agent summarizes what people are saying, flags complaints you could address, and identifies potential customers asking for alternatives.

**17. Automated Proposal Generation**
Give the agent a client's name, budget, and requirements and have it generate a tailored business proposal with scope, pricing tiers, timeline, and case studies relevant to that industry — ready for human review before sending.

**18. Sales Pipeline Tracking**
Manage deals through a STATE.yaml system instead of a static CRM. When you say "closed Deal X," the agent logs the event, updates the pipeline, captures the context of why it closed, and surfaces it when you ask "why did we discount Deal Y?"

**19. Subscription & SaaS Audit**
Give the agent read-only access to your credit card statements or app store receipts and have it catalog every SaaS subscription, flag unused apps, identify duplicate services, and estimate annual spend — with recommendations on what to cancel.

**20. Legal Document Drafting**
Describe a legal situation (NDA, partnership agreement, terms of service) and the agent drafts a tailored document. Always flag that a human lawyer should review before use — but the first draft is 80% done.

---

## Personal Uses (21–35)

**21. Habit Tracker & Accountability Coach**
The agent checks in with you daily via Telegram at times you choose (7:30 AM workout, 8 PM reading, etc.), tracks streaks, celebrates wins, and gently nudges when you slip. After 3 missed days it sends a longer motivational message and asks if you want to adjust the goal. Weekly report shows completion rates and patterns ("you always skip workouts on Wednesdays").

**22. Health & Symptom Tracker**
Message food and symptoms into a dedicated Telegram topic and the agent logs everything with timestamps. Three daily reminders (8 AM, 1 PM, 7 PM) prompt logging. Every Sunday it analyzes patterns — which foods correlate with symptoms, time-of-day patterns, clear triggers — and posts the analysis.

**23. Family Calendar Aggregation**
Aggregate work, personal, shared family, and kids' school calendars into one morning briefing delivered via Telegram. The agent also monitors text messages ambiently and automatically creates calendar events when it detects appointment confirmations ("Your appointment is confirmed for Tuesday at 2 PM"), adding 30-minute driving buffers automatically.

**24. Household Inventory Management**
Maintain a running inventory of fridge and pantry items. Either partner can text "how much milk do we have?" from anywhere and get an instant answer. When items run low, the agent suggests adding them to the shopping list.

**25. Personal CRM**
Track everyone important in your life — not just clients but friends, family, neighbors, and contacts you'd otherwise lose touch with. Log conversation topics, birthday reminders, follow-up prompts, and personal context. The agent nudges you to reach out before relationships go cold.

**26. Custom Morning Brief**
Wake up to a fully customized daily briefing via Telegram at 8 AM: news relevant to your interests, full draft content scripts (not just titles), tasks from your to-do list, and proactive AI-recommended tasks the agent can complete for you overnight. Everything generated while you sleep.

**27. Personal Finance Tracker**
Give the agent access to your bank transactions (read-only) and have it categorize spending, flag unusual charges, track progress toward savings goals, and send a weekly财务 summary to your phone.

**28. Goal-Driven Autonomous Employee**
Brain dump all your goals (personal and professional) once into the agent. Every morning it generates 4–5 tasks it can complete autonomously, executes them, and tracks progress on a custom Kanban board. You define the destination; the agent figures out the daily steps.

**29. Diet & Meal Planning**
Tell the agent your dietary goals, restrictions, and budget. It plans a week's meals, generates a shopping list deduplicated across recipes, and checks what you already have on hand. Send a photo of your fridge contents and it OCR-processes it to update inventory.

**30. Sleep & Recovery Tracking**
Log sleep hours and recovery metrics each morning. Over time, the agent correlates sleep quality with habits (late caffeine, screen time, exercise) and gives personalized recommendations to improve rest.

**31. Personal News Digest**
Instead of doom-scrolling five different news apps, tell the agent your interests and it curates one daily digest from trusted sources — no algorithms, no engagement bait, just the stories you actually care about.

**32. Password & Account Organization**
Maintain a secure, organized inventory of all online accounts, recovery codes, and subscription login credentials — all stored locally, accessible by asking the agent. Works as a lightweight personal password manager without the subscription fee.

**33. Home Maintenance Scheduler**
Track home maintenance tasks — HVAC filter changes, gutter cleaning, appliance servicing. The agent reminds you on a schedule, logs when tasks are completed, and flags recurring seasonal items.

**34. Personal Reading List Manager**
Send the agent article URLs, book recommendations, or research paper links and it saves them to a reading list with summaries. Ask "what did I save about LLM memory?" and get semantic search results with sources.

**35. Birthday & Relationship Reminders**
Maintain a personal reminder system for birthdays, anniversaries, and important dates for friends and family. The agent sends a reminder a week before and the day of, with gift suggestions based on past preferences.

---

## Automation Uses (36–50)

**36. Self-Healing Home Server**
Give the agent SSH access to your home network and it runs automated health monitoring via cron — checks services, deployment status, and system resources every 15 minutes. When it detects a crashed pod, full disk, or expired SSL certificate, it fixes it autonomously and logs the change. You sleep through infrastructure fires.

**37. Automated Meeting Notes & Action Items**
Paste a meeting transcript (or point to a VTT/SRT from Zoom or Google Meet) and the agent writes a structured summary, extracts all action items with owners and deadlines, creates Jira/Linear/Todoist tickets for each, and posts the summary to Slack. Action items that don't become tracked tasks are just documentation theater — this eliminates the gap.

**38. Inbox De-clutter**
Route all newsletters to a dedicated Gmail account. Every evening at 8 PM the agent reads the day's newsletters, extracts the most important bits with links, sends you a digest, and asks for feedback to improve future selections. Gradually learns what you actually care about.

**39. Overnight Mini App Builder**
Tell the agent to build you a surprise mini-app every night — a new SaaS idea or a tool that automates a boring part of your life, shipped as an MVP. You wake up every morning to a new working web app. Over time you have a whole suite of tools you never had to build yourself.

**40. n8n Workflow Orchestration**
OpenClaw designs and builds n8n workflows via API (incoming webhooks, drag-and-drop nodes), then calls those webhooks for all external API interactions. Credentials stay in n8n's credential store — the agent never touches API keys, and every integration is visually inspectable and lockable.

**41. Email Triage & Routing**
Every hour during work hours, the agent scans your inbox, labels actionable items, archives noise, and flags urgent messages for phone-call notification. You start every morning with inbox zero.

**42. Git Commit Monitoring**
The agent watches git commits across your repos and automatically links them to project events. Your daily standup summary isn't manual typing — it reads the git log and the event stream and writes itself.

**43. Smart Home Automation**
Connect OpenClaw to your smart home via Home Assistant API or similar. The agent monitors conditions and takes action: "If the garage door is open after 11 PM, close it" or "If temperature drops below 65°F, turn on the heater."

**44. Automated Software Updates**
The agent monitors your installed tools, dependencies, and self-hosted apps for available updates, tests updates in a staging context when possible, and applies them with a rollback plan if something breaks.

**45. Multi-Source Tech News Digest**
Automatically aggregate, score, and deliver tech news from 109+ sources — 46 RSS feeds, 44 Twitter KOLs, 19 GitHub repos, and 4 web search topics — merged, deduplicated, and quality-scored daily to Discord or Telegram.

**46. Background Research Agent**
Give the agent a research question before bed. It spawns sub-agents to check multiple sources in parallel, synthesizes findings by morning, and delivers a full briefing you can act on immediately.

**47. Social Media Scheduler**
Tell the agent what content to post and on what schedule. It drafts posts, checks them with you for approval, and publishes to X, LinkedIn, and Instagram at optimal times automatically.

**48. Backpack Inventory**
Snap a photo of your travel backpack before a trip. The agent OCR-processes it and maintains a checklist — "you've packed 12 of 18 items" — and nudges you about things you keep forgetting (charger, passport, medications).

**49. Bill Payment Automation**
Give the agent access to your bills (read-only email or uploaded statements). It tracks due dates, reminds you before payments are due, and drafts the payment instructions for your review.

**50. Receipt & Expense Logging**
Forward or photograph receipts and the agent extracts date, vendor, amount, and category, logs them to a spreadsheet, and flags receipts that might be tax-deductible based on your stated business categories.

---

## Creative Uses (51–65)

**51. Multi-Agent Content Factory**
Set up a team of three agents in Discord channels: a Research Agent scans trending stories every morning, a Writing Agent turns the best idea into a full script or thread draft, and a Thumbnail Agent generates AI cover images. You wake up to a complete content package — research, draft, and visuals — ready for review.

**52. YouTube Content Pipeline**
Hourly cron job scans breaking AI news (web + X/Twitter) and pitches video ideas to Telegram with sources. The agent maintains a 90-day video catalog with view counts to avoid duplicates, stores all pitches in SQLite with vector embeddings for semantic dedup, and when you share a link it researches the topic and creates an Asana card with a full outline.

**53. Podcast Production Pipeline**
Give the agent a topic and guest name and get back: guest background research, interview questions ordered from easy to provocative, a cold-open hook, intro script, and closing segment. After recording, paste the transcript and get timestamped show notes with links, SEO episode descriptions, social media kits (X, LinkedIn, Instagram), and a highlights reel.

**54. AI Video Editing via Chat**
Describe an edit in plain language ("trim from 0:15 to 1:30, add upbeat background music, burn English subtitles") and drop the video file into chat. The agent handles API calls, polls for completion, and delivers the finished file. Batch process 10 clips at once: crop to vertical, add auto-captions, export as MP4.

**55. Autonomous Game Development**
A "Game Developer Agent" autonomously manages the full lifecycle of educational game creation — selects the next game from a queue, writes HTML5/CSS3/JS code following strict design rules, registers it in the central game list, updates the changelog, and deploys via Git. Capable of producing 1 new game or bugfix every 7 minutes.

**56. Thumbnail & Cover Art Generation**
Give the agent a topic or headline and it generates multiple AI thumbnail concepts, iterates based on your feedback, and delivers production-ready images for YouTube, blog posts, or social media — no design software required.

**57. Newsletter Curation & Sending**
The agent curates a weekly newsletter on any topic, writes the intro and transitions, selects and previews each story, builds the HTML email, and sends it to your subscriber list via an integrated email service — you review and approve before it goes out.

**58. Book or Article Writing Assistant**
Tell the agent your book concept and target length. It generates an outline, writes chapters incrementally, maintains consistency of voice and facts across chapters, and flags contradictions as it goes. You review and refine; the agent does the first draft of everything.

**59. Music Playlist Curator**
Describe a mood, activity, or energy level and the agent curates a Spotify or Apple Music playlist — finding tracks that match your taste based on your listening history and the context you've provided.

**60. Creative Brief Generator**
Give the agent a vague creative vision ("I want a retro-futuristic brand identity for my coffee shop") and it expands it into a full creative brief: color palettes, typography direction, visual reference themes, messaging tone, and example brands for alignment.

**61. Screenplay & Script Formatting**
Paste raw dialogue and scene notes and the agent formats them into proper screenplay structure — action lines, character cues, parentheticals, scene headings — saving you the tedious formatting work so you can focus on the creative content.

**62. Interior Design Visualization**
Describe your space, style preferences, and budget. The agent generates mood boards, suggests furniture and color combinations, and creates a layout plan — giving you a visual direction before buying a single item.

**63. Photography Post-Processing Assistant**
Describe the mood you want for a photo ("warmer tones, slightly desaturated, film grain") and the agent applies the adjustments, iterates based on feedback, and delivers the processed image in multiple formats for web and print.

**64. Event Concept & Planning**
Describe an event (wedding, birthday, corporate offsite) and the agent generates a full plan: venue shortlist based on budget and guest count, theme and décor suggestions, vendor recommendations, run-of-show timeline, and a day-of coordination checklist.

**65. Branding & Logo Brief Development**
Tell the agent about your business, target audience, and competitors. It develops a comprehensive brand brief including positioning statement, tone of voice guidelines, visual direction, and messaging pillars — a document you can take to any designer or agency.

---

## Technical Uses (66–80)

**66. Code Review Agent**
Every time a PR is opened, the agent reviews the diff, flags potential bugs, security issues, performance concerns, and code smells — with specific line-level suggestions. Posts a review summary to the PR thread and notifies the author in Slack.

**67. Infrastructure-as-Code Manager**
The agent writes and applies Terraform, Ansible, and Kubernetes manifests for your infrastructure. Before applying any changes, it explains what will happen, validates syntax, checks for security misconfigurations, and creates a backup of the current state.

**68. Database Query Assistant**
Ask the agent questions about your database in plain language ("how many users signed up last month who haven't made a purchase?") and it writes the SQL, executes it against your database, and returns formatted results — no need to remember schema details or write queries manually.

**69. CI/CD Pipeline Monitor**
The agent watches your GitHub Actions, CircleCI, or GitLab CI pipelines. When a build fails, it diagnoses the error, suggests a fix, and optionally opens a PR with the correction. Posts daily build health summaries to Slack.

**70. API Documentation Generator**
Give the agent an OpenAPI spec or a raw codebase and it generates comprehensive API documentation: endpoint descriptions, request/response examples, authentication guidance, and code samples in multiple languages.

**71. Security Audit Runner**
Schedule weekly security audits: the agent scans for hardcoded secrets in repos (via TruffleHog), checks for privileged containers in Kubernetes, reviews access logs for anomalies, and sends a report with findings and recommended fixes.

**72. Self-Documenting Codebase**
The agent reads your codebase regularly and updates living documentation: architecture diagrams, README files, API docs, and decision logs. When you ask "how does the auth flow work?" it reads the actual code and explains it.

**73. Dependency Vulnerability Scanner**
The agent checks your project's dependencies against CVE databases, evaluates severity and exploitability, and prioritizes fixes by real-world risk — not just CVSS score. Patches are tested before applying and you get a clear report of what was vulnerable and what the actual attack vector was.

**74. Log Analyzer & Anomaly Detection**
Point the agent at your application logs and ask it to find anomalies — unusual error patterns, spike in 500 errors, unexpected API call volumes. It reads the logs, identifies the signal vs. noise, and explains what likely caused each anomaly with timestamps and correlated events.

**75. Architecture Review Agent**
Before a major refactor or new system design, have the agent review your proposed architecture. It evaluates trade-offs, flags single points of failure, identifies scaling bottlenecks, and compares your approach to established patterns for your tech stack.

**76. Test Generation & Coverage Analysis**
The agent reads your codebase and generates unit tests — not just happy paths, but edge cases and error conditions. It tracks code coverage and flags areas with insufficient test coverage, then generates targeted tests to fill the gaps.

**77. On-Call Incident Responder**
When an alert fires at 3 AM, the agent immediately diagnoses the issue: reads relevant logs, checks recent deployments, correlates with metric anomalies, and presents a recommended action — fix it autonomously if it's safe, or wake you only if human judgment is required.

**78. API Rate Limit & Cost Monitor**
Track API usage across your services. The agent alerts you when you're approaching rate limits, estimates monthly API costs based on usage patterns, and suggests optimization strategies when spend is trending over budget.

**79. Feature Flag Manager**
The agent manages your feature flags across environments — create, toggle, schedule, and audit flags via natural language. "Enable the dark mode toggle for 10% of users on Tuesday" or "Audit which flags haven't been touched in 60 days and suggest清理." All flag changes are logged with timestamps, owners, and rollback history.

**80. Load Testing & Performance Benchmarker**
Tell the agent to stress test an API endpoint — it generates a load test plan, runs it against your staging environment, analyzes response times and error rates at scale, and delivers a performance report with bottleneck identification and optimization recommendations.

---

## Communication Uses (81–90)

**81. Phone Call Notifications**
Your agent monitors everything — stocks, emails, smart home — but push notifications are easy to ignore. When something actually matters, the agent calls your real phone via clawr.ing, delivers the alert, and you can ask follow-up questions in real time. Two-way conversation, not a robocall. Used for morning briefings, urgent price alerts, and boss emails.

**82. Phone-Based Personal Assistant via Telnyx**
Call a phone number and talk to your AI agent via voice. Get calendar reminders, Jira updates, and web search results hands-free while driving or when your hands are occupied. Any phone becomes a gateway to your AI assistant.

**83. Family Coordination Hub**
A shared Telegram or Discord channel for the whole family where any member can message the agent. It coordinates schedules, tracks whose turn it is for chores, manages the shared grocery list, and routes questions to the right person.

**84. Real-Time Language Translation**
During calls or in-person meetings, send the audio or text to the agent and get real-time translation in your ear or on screen. Useful for business calls with non-English speakers, travel situations, or family gatherings with mixed-language relatives.

**85. Meeting Scheduling Assistant**
Tell the agent who you need to meet and your availability windows. It checks all participants' calendars, finds overlap, drafts scheduling emails, sends invitations, and handles rescheduling requests — full back-and-forth without you touching email.

**86. Customer Follow-Up Automation**
After a customer interaction (sales call, support ticket, onboarding call), the agent automatically sends a follow-up email with a summary of what was discussed, next steps, and relevant resources. Flags if the customer hasn't responded in 3 days.

**87. Crisis Communication Manager**
During a PR crisis or service outage, the agent monitors all incoming communications (email, social, support tickets), triages by severity, drafts responses for your approval, and tracks which issues have been addressed vs. still burning.

**88. Voice Memo to Structured Notes**
Record a voice memo describing ideas, meeting thoughts, or observations. Send it to the agent and get back structured, organized notes — formatted for your preferred system (Notion, Obsidian, Apple Notes, a Google Doc).

**89. Team Check-In Bot**
Set up a daily or weekly check-in via Slack or Discord. The agent asks each team member a rotating question ("What did you ship this week?", "What's blocking you?"), collects responses, and compiles a team digest for the manager.

**90. Client Portal Updates**
Send the agent project updates, milestone completions, or deliverable notifications. It formats them professionally and sends timed client portal updates or email reports — keeping clients informed without you drafting each update manually.

---

## Productivity Uses (91–100)

**91. Second Brain / Personal Knowledge Base**
Drop any URL into Telegram or Slack and the agent auto-ingests the content — articles, tweets, YouTube transcripts, PDFs. Ask "what did I save about agent memory?" and get semantic search results with sources. Feeds into other workflows; when building research cards, the knowledge base is automatically queried.

**92. Daily Reddit Digest**
Subscribe to subreddits relevant to your interests. Every morning the agent reads the top posts from the past 24 hours, extracts the most insightful discussions and useful resources, and delivers a digest to Telegram — no more doomscrolling Reddit for an hour.

**93. arXiv Paper Reader**
Give the agent an arXiv ID and it fetches the paper, flattens LaTeX notation automatically, and returns clean readable text. Browse paper structure before committing to the full text, triage a reading list by abstracts across multiple papers, and ask the agent to summarize, compare, or critique specific sections.

**94. Hugging Face Papers Discovery**
Browse daily trending papers on Hugging Face sorted by upvotes. For each paper, get an AI-generated summary, linked GitHub repos, community upvotes, and discussion comments. Search by keyword to find relevant papers, and deep-read any paper via its arXiv source.

**95. Daily YouTube Digest**
Every morning, fetch the latest videos from your favorite channels, get transcripts summarized with key insights in 2–3 bullets each, and receive a digest with video titles, channel names, and links. Or track by keyword ("OpenClaw", "AI agents") and only get new videos on those topics.

**96. X (Twitter) Account Analysis**
Give the agent access to your X account and have it analyze your posting patterns — what topics get you the most engagement, what times of day perform best, why some posts go viral while others flop. Get actionable advice on content strategy, all without paying $10–50/month for analytics tools.

**97. Travel Planning & Itinerary Builder**
Tell the agent your destination, dates, budget, and travel style. It researches flights, hotels, and activities, builds a day-by-day itinerary with timing and location details, estimates costs, and sends you a formatted document ready to take on the trip.

**98. Project State Management (Event-Driven Kanban)**
Replace static Kanban boards with an event-driven system. Instead of dragging cards, tell the agent "finished the auth flow, starting on the dashboard." It logs the event, updates project state, and preserves context. Ask "where are we on the dashboard?" and get the full story: what's done, what's next, what's blocking you, and why you made past decisions.

**99. Focus Session Manager**
Tell the agent what you need to focus on and for how long. It silences notifications, sets a timer, checks in at intervals ("Still working on the auth flow?"), blocks distracting sites, and logs a focus session summary when you're done — building data on when and where you do your best work.

**100. Weekly Review Automation**
Every Sunday, the agent reviews your week: what you completed, what slipped, how you spent your time based on calendar and log data, which habits you maintained, and what's on deck for next week. It generates a structured review document and suggests priorities for the coming week — making weekly reviews consistent instead of something you do occasionally when you remember.

---

*Sources: [awesome-openclaw-usecases](https://github.com/hesamsheikh/awesome-openclaw-usecases) (primary); [OpenClaw Discord community](https://discord.gg/openclaw); [ClawHub Skills Directory](https://clawhub.ai); various documented workflows from the OpenClaw ecosystem. Additional use cases synthesized to fill out categories while remaining within demonstrated OpenClaw capabilities.*