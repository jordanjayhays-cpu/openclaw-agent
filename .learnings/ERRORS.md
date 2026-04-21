# Errors

Command failures and integration errors.

---

## [ERR-20260421-001] web_search

**Logged**: 2026-04-21T05:34:00Z
**Priority**: high
**Status**: pending
**Area**: infra

### Summary
DuckDuckGo web_search consistently returns bot detection challenge. Scraping approaches fail.

### Error
```
"error": "DuckDuckGo returned a bot-detection challenge."
```

### Context
- Web scraping blocked at platform level
- Reddit returns 403 on direct fetch
- Google Trends returns cookie challenge
- Web fetch works on some sites but not dynamic ones

### Suggested Fix
Use Felo API for searches (free tier available). For scraping: use Playwright with stealth mode or puppeteer with proxies. Or run scraping locally from Jordan's machine.

### Metadata
- Reproducible: yes
- Related Files: /data/workspace/idea-agent/pipeline.js

---
