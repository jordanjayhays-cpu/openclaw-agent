---
name: draft_reply
description: Draft concise reply options for messages, emails, and chat threads.
---

# Draft Reply

Use this skill when the user asks to:
- draft a reply
- answer a message
- respond to an email
- rewrite a response
- send a follow-up

## Output format
Give 3 options:
1. Short
2. Balanced
3. Firm

## Rules
- Match the user's preferred tone from USER.md
- Default to concise
- Preserve the user's intent
- Remove fluff
- Make each option meaningfully different
- If context is missing, make the safest reasonable assumption
- Do not send anything automatically
