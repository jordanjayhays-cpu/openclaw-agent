# Learnings

Corrections, insights, and knowledge gaps captured during development.

**Categories**: correction | insight | knowledge_gap | best_practice

---
## [LRN-20260421-001] insight

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
