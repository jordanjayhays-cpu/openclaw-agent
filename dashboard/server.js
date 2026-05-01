const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Sync OPENCLAW_GATEWAY_TOKEN to /data/openclaw.json so the gateway and
// Control UI always share the same token, even across restarts.
const OPENCLAW_CONFIG_FILE = '/data/openclaw.json';
const GATEWAY_TOKEN = process.env.OPENCLAW_GATEWAY_TOKEN || null;

function syncGatewayToken() {
    if (!GATEWAY_TOKEN) {
        console.warn('[CONFIG] OPENCLAW_GATEWAY_TOKEN is not set — gateway token sync skipped');
        return;
    }
    try {
        let config = {};
        if (fs.existsSync(OPENCLAW_CONFIG_FILE)) {
            try {
                config = JSON.parse(fs.readFileSync(OPENCLAW_CONFIG_FILE, 'utf8'));
            } catch (_) {
                config = {};
            }
        }
        config.gatewayToken = GATEWAY_TOKEN;
        fs.mkdirSync(path.dirname(OPENCLAW_CONFIG_FILE), { recursive: true });
        fs.writeFileSync(OPENCLAW_CONFIG_FILE, JSON.stringify(config, null, 2));
        console.log('[CONFIG] Gateway token synced to', OPENCLAW_CONFIG_FILE);
    } catch (err) {
        console.error('[CONFIG] Failed to write openclaw.json:', err.message);
    }
}

syncGatewayToken();

app.use(bodyParser.json());
app.use(express.static(path.join(__dirname)));

// Store commands for the agent to process
const COMMAND_FILE = path.join(__dirname, 'commands.json');

function getCommands() {
    try {
        if (fs.existsSync(COMMAND_FILE)) {
            return JSON.parse(fs.readFileSync(COMMAND_FILE, 'utf8'));
        }
    } catch (e) {}
    return [];
}

function saveCommands(commands) {
    fs.writeFileSync(COMMAND_FILE, JSON.stringify(commands, null, 2));
}

// API: Submit a command from the UI
app.post('/api/command', (req, res) => {
    const { command } = req.body;
    if (!command) return res.status(400).json({ error: 'No command provided' });

    const commands = getCommands();
    const entry = {
        id: Date.now(),
        command,
        status: 'pending',
        timestamp: new Date().toISOString()
    };
    commands.push(entry);
    saveCommands(commands);

    console.log('[COMMAND]', command);
    res.json({ success: true, id: entry.id });
});

// API: Get pending commands (agent polls this)
app.get('/api/commands', (req, res) => {
    const commands = getCommands();
    res.json(commands);
});

// API: Update command status
app.post('/api/commands/:id/status', (req, res) => {
    const { id } = req.params;
    const { status, result } = req.body;

    const commands = getCommands();
    const cmd = commands.find(c => c.id === parseInt(id));
    if (!cmd) return res.status(404).json({ error: 'Command not found' });

    cmd.status = status;
    if (result) cmd.result = result;
    saveCommands(commands);

    res.json({ success: true });
});

// API: Get agent status/memory
app.get('/api/status', (req, res) => {
    try {
        const memoryPath = '/home/openclaw/.openclaw/workspace/MEMORY.md';
        const memory = fs.existsSync(memoryPath)
            ? fs.readFileSync(memoryPath, 'utf8').substring(0, 2000)
            : 'Memory file not found';

        res.json({
            status: 'online',
            timestamp: new Date().toISOString(),
            memory_preview: memory
        });
    } catch (e) {
        res.json({ status: 'online', timestamp: new Date().toISOString() });
    }
});

// API: Read a file
app.get('/api/file', (req, res) => {
    const { path: filePath } = req.query;
    if (!filePath) return res.status(400).json({ error: 'No path provided' });

    try {
        const content = fs.readFileSync(filePath, 'utf8');
        res.json({ content });
    } catch (e) {
        res.status(404).json({ error: 'File not found: ' + filePath });
    }
});

// API: Write a file
app.post('/api/file', (req, res) => {
    const { path: filePath, content } = req.body;
    if (!filePath || content === undefined) {
        return res.status(400).json({ error: 'path and content required' });
    }

    try {
        fs.mkdirSync(path.dirname(filePath), { recursive: true });
        fs.writeFileSync(filePath, content);
        res.json({ success: true });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Dashboard running on http://0.0.0.0:${PORT}`);
});
