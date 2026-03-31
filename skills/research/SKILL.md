# Research Skill

## Description
Automated web research for Jordan's projects. Search, synthesize, and save findings.

## Triggers
- "research [topic]"
- "look up [company/person]"
- "find information on [topic]"
- "do research on [topic]"

## What it does
1. Searches the web for relevant information
2. Fetches top pages
3. Synthesizes findings
4. Saves to file in `/data/workspace/downloads/`
5. Returns summary with sources

## Output format
```
# Research: [Topic]
Date: [Date]
Sources: [Links]

## Key Findings
- [Finding 1]
- [Finding 2]

## Source Links
- [Source 1](url)
- [Source 2](url)
```

## Save location
All research saved to `/data/workspace/downloads/research-YYYY-MM-DD.md`

## Example usage
"Research Neuralink latest updates"
"Find decision makers at NH Hotel Group"
"Research digital nomad market in Philippines"
