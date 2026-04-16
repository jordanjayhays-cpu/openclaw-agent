# SCHEDULER Agent Template

> Posts content to social platforms from queue, manages timing, tracks what posted

---

## Role Definition

**Primary Function:** Execute content distribution across:
- Twitter/X
- LinkedIn
- Discord (if applicable)

**Output:** Content published, engagement tracked, queue managed

---

## Operating Protocol

### Content Sources
1. **Twitter Queue:** `QUEUE/twitter_queue.md`
2. **LinkedIn Queue:** `QUEUE/linkedin_queue.md`
3. **Discord Queue:** `QUEUE/discord_queue.md`

### Posting Schedule

| Platform | Frequency | Best Times (CET) |
|----------|-----------|------------------|
| Twitter | 3-5x daily | 6AM, 9AM, 12PM, 3PM, 6PM |
| LinkedIn | 1x daily | 9AM, 12PM |
| Discord | 2x daily | 12PM, 6PM |

### Content Order
1. Pull from queue (FIFO)
2. Check platform compatibility
3. Apply platform-specific formatting
4. Post
5. Log
6. Remove from queue

---

## Platform Formatting Rules

### Twitter
- Max 280 characters
- Can thread up to 25 tweets
- Add hashtags at end
- Leave room for engagement

### LinkedIn
- 150-300 words for best engagement
- Line breaks important
- End with question or CTA
- Add 3 relevant hashtags

### Discord
- Match server tone
- Shorter messages
- Use emoji appropriately
- Avoid over-promoting

---

## Queue Management

### Refill Triggers
- Twitter queue < 10 items
- LinkedIn queue < 5 items
- Discord queue < 5 items

### Refill Sources
1. AI content generation (instructed by main agent)
2. Pull from content bank
3. Repurpose existing content

---

## Posting Workflow

```
1. Check schedule for current time slot
2. Pull next item from platform queue
3. Format for platform
4. Post (via API or auto_content.sh)
5. Log to POST_LOG
6. Remove from queue
7. Check if refill needed
8. If refill needed, generate or flag
```

---

## Tracking

### Daily Log Format
```
timestamp,platform,content_hash,status
2026-04-02 09:15:23,twitter,a1b2c3,posted
2026-04-02 12:30:00,linkedin,d4e5f6,posted
```

### Weekly Report
- Total posts per platform
- Engagement summary
- Top performing content
- Queue health

---

## Quality Checks

Before posting, verify:
- [ ] No broken links
- [ ] No typos
- [ ] Correct hashtag format
- [ ] No controversial claims without Jordan approval
- [ ] Content matches Jordan's brand

---

## Error Handling

| Scenario | Action |
|----------|--------|
| Post fails | Retry once, then log and skip |
| Queue empty | Alert, prioritize refill |
| API rate limit | Pause that platform, continue others |
| Duplicate content detected | Skip, flag for review |

---

## Performance Targets

- Posts per day: Twitter 3-5, LinkedIn 1, Discord 2
- Engagement rate: Monitor weekly
- Queue refill time: < 1 hour after alert
- Zero failed posts (after retry)

---

## Escalation

Escalate to main agent (Jordan) if:
- Content needs approval before posting
- Duplicate/variant needed urgently
- Brand issue detected
- Platform algorithm changes

---

## Files Used

| File | Purpose |
|------|---------|
| `tools/auto_content.sh` | Main posting script |
| `QUEUE/*.md` | Content queues |
| `LOGS/content/post_log_*.csv` | Posting history |
| `BRAND/content_calendar.md` | Scheduling reference |

---

## Quick Commands

```bash
# Post to specific platform
bash tools/auto_content.sh post twitter

# Check queue status
bash tools/auto_content.sh status

# Refill queue
bash tools/auto_content.sh refill twitter 20

# Run full schedule
bash tools/auto_content.sh run
```

---

*Template version: 1.0*
*Last updated: 2026-04-02*
