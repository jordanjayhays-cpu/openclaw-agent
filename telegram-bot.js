'use strict';

/**
 * OpenClaw AI Assistant — Telegram Bot
 *
 * Listens for Telegram messages via webhook and replies using the
 * OpenRouter API. Requires two environment variables:
 *   TELEGRAM_BOT_TOKEN  — bot token from @BotFather
 *   OPENROUTER_API_KEY  — API key from openrouter.ai
 *
 * Optional:
 *   PORT                — HTTP port for the webhook server (default: 3001)
 *   WEBHOOK_URL         — Public HTTPS URL Railway assigns to this service.
 *                         When set, the bot registers the webhook automatically
 *                         on startup. If omitted, register the webhook manually.
 *   OPENROUTER_MODEL    — Model to use (default: openai/gpt-4o-mini)
 */

const TelegramBot = require('node-telegram-bot-api');
const https = require('https');
const http = require('http');
const express = require('express');

// ── Configuration ────────────────────────────────────────────────────────────

const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN;
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const PORT = parseInt(process.env.PORT || '3001', 10);
const WEBHOOK_URL = process.env.WEBHOOK_URL; // e.g. https://your-service.up.railway.app
const OPENROUTER_MODEL = process.env.OPENROUTER_MODEL || 'openai/gpt-4o-mini';

// ── Startup validation ───────────────────────────────────────────────────────

if (!TELEGRAM_BOT_TOKEN) {
    console.error('[FATAL] TELEGRAM_BOT_TOKEN environment variable is not set.');
    process.exit(1);
}

if (!OPENROUTER_API_KEY) {
    console.error('[FATAL] OPENROUTER_API_KEY environment variable is not set.');
    process.exit(1);
}

console.log(`[STARTUP] OPENROUTER_API_KEY is set (length=${OPENROUTER_API_KEY.length})`);
console.log(`[STARTUP] Using model: ${OPENROUTER_MODEL}`);

// ── OpenRouter API ───────────────────────────────────────────────────────────

/**
 * Sends a user message to OpenRouter and returns the assistant's reply text.
 * @param {string} userMessage
 * @returns {Promise<string>}
 */
async function askOpenRouter(userMessage) {
    const payload = JSON.stringify({
        model: OPENROUTER_MODEL,
        messages: [
            {
                role: 'system',
                content:
                    'You are a helpful AI assistant. Answer clearly and concisely.',
            },
            {
                role: 'user',
                content: userMessage,
            },
        ],
    });

    console.log('[OPENROUTER] Sending request:', JSON.stringify({
        model: OPENROUTER_MODEL,
        endpoint: 'https://openrouter.ai/api/v1/chat/completions',
        messageCount: 2,
        userMessage,
    }));

    return new Promise((resolve, reject) => {
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

        const req = https.request(options, (res) => {
            let data = '';
            res.on('data', (chunk) => (data += chunk));
            res.on('end', () => {
                console.log(`[OPENROUTER] Response status: ${res.statusCode}`);
                console.log('[OPENROUTER] Response headers:', JSON.stringify(res.headers));
                console.log('[OPENROUTER] Response body:', data);

                try {
                    const json = JSON.parse(data);

                    if (json.error) {
                        return reject(
                            new Error(
                                `OpenRouter error ${json.error.code}: ${json.error.message}`
                            )
                        );
                    }

                    const text =
                        json.choices &&
                        json.choices[0] &&
                        json.choices[0].message &&
                        json.choices[0].message.content;

                    if (!text) {
                        return reject(
                            new Error('Unexpected OpenRouter response shape: ' + data)
                        );
                    }

                    resolve(text.trim());
                } catch (err) {
                    reject(new Error('Failed to parse OpenRouter response: ' + err.message));
                }
            });
        });

        req.on('error', (err) => reject(new Error('OpenRouter request failed: ' + err.message)));
        req.write(payload);
        req.end();
    });
}

// ── Telegram Bot (webhook mode) ──────────────────────────────────────────────

// Use webhook mode — no polling, so the process doesn't hold an open connection.
const bot = new TelegramBot(TELEGRAM_BOT_TOKEN, { webHook: true });

const app = express();
app.use(express.json());

// Telegram sends POST requests to this path.
const WEBHOOK_PATH = `/bot${TELEGRAM_BOT_TOKEN}`;

app.post(WEBHOOK_PATH, (req, res) => {
    bot.processUpdate(req.body);
    res.sendStatus(200);
});

// Health check — Railway uses this to confirm the service is alive.
app.get('/healthz', (_req, res) => {
    res.status(200).json({ status: 'ok', service: 'telegram-bot' });
});

// ── Message handler ──────────────────────────────────────────────────────────

bot.on('message', async (msg) => {
    try {
        const chatId = msg.chat.id;
        const userText = msg.text;

        // Ignore non-text messages (photos, stickers, etc.)
        if (!userText) {
            return bot.sendMessage(
                chatId,
                "Sorry, I can only handle text messages right now."
            );
        }

        console.log(`[MSG] chat=${chatId} user=${msg.from && msg.from.username} text="${userText}"`);

        // Show a "typing…" indicator while we wait for OpenRouter.
        try {
            await bot.sendChatAction(chatId, 'typing');
        } catch (_) {
            // Non-fatal — continue even if this fails.
        }

        try {
            const reply = await askOpenRouter(userText);
            await bot.sendMessage(chatId, reply);
            console.log(`[REPLY] chat=${chatId} length=${reply.length}`);
        } catch (err) {
            console.error('[ERROR] OpenRouter call failed:', err.message);
            console.error('[ERROR] Full stack:', err.stack);
            await bot.sendMessage(
                chatId,
                "⚠️ Sorry, I couldn't get a response right now. Please try again in a moment."
            );
        }
    } catch (err) {
        console.error('[ERROR] Unhandled exception in message handler:', err.message);
        console.error('[ERROR] Full stack:', err.stack);
    }
});

// Log any bot-level errors so they don't crash the process silently.
bot.on('polling_error', (err) => console.error('[BOT POLLING ERROR]', err.message));
bot.on('webhook_error', (err) => console.error('[BOT WEBHOOK ERROR]', err.message));

// ── Start server & register webhook ─────────────────────────────────────────

const server = http.createServer(app);

server.listen(PORT, async () => {
    console.log(`🤖 Telegram bot server listening on port ${PORT}`);
    console.log(`   Webhook path: ${WEBHOOK_PATH}`);
    console.log(`   Model: ${OPENROUTER_MODEL}`);

    if (WEBHOOK_URL) {
        const fullWebhookUrl = `${WEBHOOK_URL.replace(/\/$/, '')}${WEBHOOK_PATH}`;
        try {
            await bot.setWebHook(fullWebhookUrl);
            console.log(`✅ Webhook registered: ${fullWebhookUrl}`);
        } catch (err) {
            console.error('❌ Failed to register webhook:', err.message);
        }
    } else {
        console.warn(
            '[WARN] WEBHOOK_URL is not set — webhook not registered automatically. ' +
            'Set WEBHOOK_URL to your Railway public domain to enable auto-registration.'
        );
    }
});

// ── Graceful shutdown ────────────────────────────────────────────────────────

async function shutdown(signal) {
    console.log(`\n[${signal}] Shutting down gracefully…`);
    try {
        await bot.deleteWebHook();
        console.log('Webhook removed.');
    } catch (_) {}
    server.close(() => {
        console.log('HTTP server closed.');
        process.exit(0);
    });
}

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
