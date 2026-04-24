# AI Phone Calling — Restaurant Reservation System

**Goal: Axton can call any restaurant and book a reservation on Jordan's behalf**

---

## The Problem Stack

Making a restaurant reservation via AI phone call requires solving 4 layers:

| Layer | What it does | Options |
|-------|-------------|---------|
| **1. Restaurant Finding** | Locate the restaurant, get phone number, hours | Google Places API, Yelp API, OpenTable/Resy lookup |
| **2. Reservation Logic** | Determine: name, date, time, party size, occasion | Hardcoded prompts, LLM reasoning |
| **3. Voice Output** | Convert text to spoken words | ElevenLabs, OpenAI TTS, Google TTS |
| **4. Phone Call Execution** | Actually make the outbound phone call | Twilio, Retell AI, Bland AI, Air AI |

---

## Layer 1 — Restaurant Finding

### Google Places API (Jordan already has this key ✅)
```
AIzaSyDx4a7iq1lt4LItVg44_kDmzvlpK7Ftldo
```
Can use `Place Details` or `Text Search` to find any restaurant → get:
- 📍 Address, phone number, website
- ⏰ Opening hours (handles timezone logic)
- ⭐ Rating, price level
- 🕐 Whether it's open RIGHT NOW

**Cost:** ~$32/1000 calls (search) + $17/1000 (details) — very cheap

---

## Layer 2 — Reservation Logic (LLM Prompting)

This is the "brain" — what to say during the call:

```
System prompt for the AI caller:
"You are calling [Restaurant Name] to make a reservation.
Restaurant phone: [number]
Details to request:
- Name: Jordan Hays
- Date: [Jordan's requested date]
- Time: [Jordan's requested time]
- Party size: [X] people
- Occasion: [birthday/business/date night]
- Phone: [Jordan's number for confirmation]

Your persona: polite, human-like, natural. You:
- Greet naturally ("Hi, I'd like to make a reservation please")
- Confirm the details back
- Ask for confirmation number if given
- Thank them and say goodbye

If they ask for your name: "It's Jordan calling"
If they're closed: "No problem, have a great evening"
Keep it SHORT — 30-60 seconds max
```

---

## Layer 3 — Voice (ElevenLabs)

Jordan asked about ElevenLabs — good fit here. We need:
1. **API key** (Jordan needs to create account at elevenlabs.io)
2. **Voice selection** — choose a voice that sounds professional but warm
3. **TTS conversion** — text → audio file (MP3/WAV)

Sample code:
```javascript
const { ElevenLabsClient } = require('@elevenlabs/elevenlabs-js');
const fs = require('fs');

const client = new ElevenLabsClient({ apiKey: 'ELAB_KEY' });

// Convert reservation script to audio
const audio = await client.textToSpeech.convert('voice_id', {
  text: 'Hi, I would like to book a table for two people for Friday evening at seven thirty pm. The name is Jordan Hays.',
  modelId: 'eleven_v3',
});

// Save to MP3
fs.writeFileSync('reservation_call.mp3', audio);
```

---

## Layer 4 — Phone Call Infrastructure

This is the hardest part. Options:

### Option A: Twilio + ElevenLabs + LLM (DIY)
| Component | Service | Cost |
|-----------|---------|------|
| Phone numbers | Twilio | $1.00/month per number + $0.0085/min per call |
| Voice synthesis | ElevenLabs | Free tier: 10k chars/month |
| AI brain | OpenRouter (minimax-m2.7) | ~$0.001/1000 tokens |
| Call management | Custom code | Build time: 1-2 weeks |

**Flow:**
1. Jordan: "Book me a table at La Huella for 2 tonight at 8pm"
2. Axton searches Google Places → gets restaurant phone number
3. Axton generates reservation script via LLM
4. Axton converts script to MP3 via ElevenLabs
5. Axton initiates outbound call via Twilio API
6. Twilio plays MP3 to restaurant
7. Restaurant responds → speech-to-text → LLM processes response
8. Axton confirms outcome with Jordan

**Problem:** This is a complex build. Real-time back-and-forth requires speech-to-text + intent detection + response loop. Not a simple script.

---

### Option B: Retell AI (Easiest Path)
Retell is a voice agent platform — they handle everything:
- Phone number provisioning (inbound + outbound)
- Speech-to-text (real-time)
- LLM integration
- Text-to-speech
- Call orchestration

**Cost:** Their demo exists but pricing isn't public — enterprise-tier

**Flow with Retell:**
1. Jordan: "Book me at La Huella tonight 8pm for 2"
2. Axton searches Google Places → gets phone
3. Axton sends reservation details to Retell API webhook
4. Retell agent calls restaurant, handles conversation
5. Retell sends Axton the outcome via webhook
6. Axton tells Jordan: "Confirmed! Reservation #48291"

**Advantage:** No need to build the real-time voice pipeline yourself.

---

### Option C: Bland AI (Middle Path)
- "Norm" — their voice AI builder
- You describe what you want in plain English
- They build the agent and provide API access

**Cost:** Not public — has free trial

---

## Realistic First Step (What I Can Build Now)

### Minimum Viable Product:

```
Jordan sends: "Book La Huella for 2 tonight 8pm"

↓ Axton (me)

1. Google Places API → find restaurant, get phone + hours
2. Check if open at requested time
3. Generate reservation script (LLM)
4. Convert to audio (ElevenLabs)
5. Place outbound call (Twilio API)
6. Play audio to restaurant
7. Await DTMF/confirmation from restaurant
8. Report back to Jordan
```

**Problem:** Without real-time speech-to-text, this is a one-way message. The restaurant can't talk back.

---

## Better MVP (What Jordan Needs):

**Add a confirmation step in the middle:**
1. Axton calls restaurant
2. Restaurant answers → Axton speaks the reservation request
3. **Axton waits for Jordan to approve the next step**
4. If restaurant says "we're full at 8, how about 9?" → Axton texts Jordan: "They're full at 8, can you do 9pm?"
5. Jordan texts back: "yes"
6. Axton confirms at 9pm

This is like the PISCO outreach workflow — I draft, Jordan approves, I execute.

---

## Immediate Action Items

### Jordan needs to do (5 min):
- [ ] Create **ElevenLabs account** → get API key
- [ ] OR create **Twilio account** → get Account SID + Auth Token
- [ ] OR sign up for **Retell AI** free trial → get API access

### I can build now (once keys arrive):
- [ ] Google Places → restaurant lookup skill
- [ ] Reservation script generator (LLM prompt)
- [ ] ElevenLabs TTS integration (text → audio)
- [ ] Twilio outbound call trigger
- [ ] Confirmation handler (deals with "how about 9pm?")

---

## Most Promising Stack for Jordan

| Component | Service | Status |
|-----------|---------|--------|
| Voice synthesis | ElevenLabs | Jordan needs account |
| Phone calls | Twilio | Jordan needs account |
| Restaurant data | Google Places | Jordan HAS the key ✅ |
| AI brain | Me (Axton) | Already here ✅ |
| Orchestration | n8n + OpenClaw | Already here ✅ |

**Total monthly cost estimate:** $1-3/month (Twilio phone + call minutes)
**Build time:** 1-2 weeks for full two-way conversations
**First step:** Jordan creates ElevenLabs account

---

## Competitor Analysis

| Platform | What it does | Best for |
|---------|-------------|---------|
| **Google Duplex** | Full AI calling solution | Not available to public |
| **Retell AI** | Voice agent platform | Enterprises, ready to use |
| **Bland AI** | Voice agent builder | Developers, self-hosted |
| **Air AI** | Phone call automation | High volume calling |
| **Twilio + ElevenLabs** | DIY phone+voice | Full control, custom flows |
| **OpenAI Realtime API** | Two-way voice conversations | Real-time, complex logic |

---

## Recommendation for Jordan

**Start with ElevenLabs + Twilio:**
1. ElevenLabs for voice (Jordan creates account)
2. Twilio for phone calls (Jordan creates account)
3. I handle the orchestration (Google Places → script → call)

**Later upgrade:** If real-time back-and-forth is needed, add Retell AI or OpenAI Realtime API.

**The MVP I can build today:** A "one-way announcement" system — Axton calls restaurant, leaves a voicemail with the reservation request if nobody answers. This requires no real-time processing.

---

*Research completed: 2026-04-24*
