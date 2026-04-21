# Learnings

Corrections, insights, and knowledge gaps captured during development.

**Categories**: correction | insight | knowledge_gap | best_practice

---
## [LRN-20260421-002] correction

**Logged**: 2026-04-21T07:10:00Z
**Priority**: high
**Status**: closed
**Area**: config

### Summary
ScrapeCreators uses header `x-api-key`, NOT `Authorization: Bearer`. Also used `query` parameter, not `q`.

### Details
Wrong: `curl -H "Authorization: Bearer $KEY"`
Right: `curl -H "x-api-key: $KEY" -G -d "query=searchterm"`

### Correct API call format
```bash
curl -s "https://api.scrapecreators.com/v1/reddit/search?query=NeuroMatch&limit=3" \
  -H "x-api-key: YOUR_KEY"
```

### Key lessons
- mj3cNeOw5AYitD8OUF5vhPPtidF2 = ScrapeCreators key (NOT Perplexity)
- iBax9goSYPF7FaoUPFhuDalYMdbV = Perplexity key (NOT ScrapeCreators)
- Perplexity uses OPENAI-compatible API format
- ScrapeCreators uses x-api-key header + query param

### Metadata
- Source: manual API testing
- Tags: scrapecreators, api, headers, authentication

---
## [LRN-20260421-001] insight

**Logged**: 2026-04-21T06:40:00Z
**Priority**: medium
**Status**: closed
**Area**: config

### Summary
Perplexity API key `mj3cNeOw5AYitD8OUF5vhPPtidF2` works but must be set via `PERPLEXITY_API_KEY` env var — not automatically available

### Details
Perplexity web search works when API key is provided as env var. Key was already set up from prior conversation. No special initialization needed beyond env var.

### Metadata
- Source: conversation
- Tags: perplexity, api, research

---

**Logged**: 2026-04-21T06:40:00Z
**Priority**: medium
**Status**: pending
**Area**: config

### Summary
Perplexity API key `mj3cNeOw5AYitD8OUF5vhPPtidF2` works but must be set via `PERPLEXITY_API_KEY` env var — not automatically available

### Details
Perplexity web search works when API key is provided as env var. Key was already set up from prior conversation. No additional config file needed.

### Suggested Action
When asked to research, assume Perplexity is available if key is set. No special initialization needed beyond env var.

### Metadata
- Source: conversation
- Tags: perplexity, api, research

---
