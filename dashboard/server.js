'use strict';

/**
 * OpenClaw Web Interface Server
 *
 * Serves the OpenClaw chat UI and proxies requests to OpenRouter so the
 * API key is never exposed to the browser.
 *
 * Environment variables:
 *   PORT               — HTTP port (default: 8080)
 *   OPENROUTER_API_KEY — API key from openrouter.ai
 *   OPENROUTER_MODEL   — Model to use (default: openai/gpt-4o-mini)
 */

const express = require('express');
const https = require('https');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const OPENROUTER_MODEL = process.env.OPENROUTER_MODEL || 'openai/gpt-4o-mini';

app.use(express.json());

// ── Static UI ────────────────────────────────────────────────────────────────

app.get('/', (_req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  res.sendFile(path.join(__dirname, 'index.html'));
});

// ── Health check ─────────────────────────────────────────────────────────────

app.get('/healthz', (_req, res) => {
  res.status(200).json({ status: 'ok', service: 'openclaw-web' });
});

// ── OpenRouter proxy ─────────────────────────────────────────────────────────

app.post('/api/chat', (req, res) => {
  if (!OPENROUTER_API_KEY) {
    return res.status(500).json({ error: 'OPENROUTER_API_KEY is not configured on the server.' });
  }

  const { messages } = req.body;
  if (!Array.isArray(messages) || messages.length === 0) {
    return res.status(400).json({ error: 'messages array is required.' });
  }

  const systemMessage = {
    role: 'system',
    content: 'You are OpenClaw, a helpful and sharp AI assistant. Answer clearly and concisely.',
  };

  const payload = JSON.stringify({
    model: OPENROUTER_MODEL,
    messages: [systemMessage, ...messages],
  });

  const options = {
    hostname: 'openrouter.ai',
    path: '/api/v1/chat/completions',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(payload),
      Authorization: `Bearer ${OPENROUTER_API_KEY}`,
      'HTTP-Referer': 'https://openclaw.ai',
      'X-Title': 'OpenClaw AI Assistant',
    },
  };

  const proxyReq = https.request(options, (proxyRes) => {
    let data = '';
    proxyRes.on('data', (chunk) => (data += chunk));
    proxyRes.on('end', () => {
      try {
        const json = JSON.parse(data);
        if (json.error) {
          return res.status(502).json({ error: json.error.message || 'OpenRouter error' });
        }
        const text =
          json.choices &&
          json.choices[0] &&
          json.choices[0].message &&
          json.choices[0].message.content;
        if (!text) {
          return res.status(502).json({ error: 'Unexpected response from OpenRouter.' });
        }
        res.json({ reply: text.trim() });
      } catch (err) {
        res.status(502).json({ error: 'Failed to parse OpenRouter response.' });
      }
    });
  });

  proxyReq.on('error', (err) => {
    res.status(502).json({ error: 'OpenRouter request failed: ' + err.message });
  });

  proxyReq.write(payload);
  proxyReq.end();
});

// ── Start ────────────────────────────────────────────────────────────────────

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🤖 OpenClaw web interface running on http://0.0.0.0:${PORT}`);
  console.log(`   Model: ${OPENROUTER_MODEL}`);
  if (!OPENROUTER_API_KEY) {
    console.warn('[WARN] OPENROUTER_API_KEY is not set — chat will not work.');
  }
});
