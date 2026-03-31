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
    if (fs.existsSync(COMMAND_FILE)) {
        return JSON.parse(fs.readFileSync(COMMAND_FILE, 'utf8'));
    }
    return [];
}

function saveCommand(cmd) {
    const commands = getCommands();
    commands.unshift({
        ...cmd,
        id: Date.now(),
        timestamp: new Date().toISOString(),
        status: 'pending'
    });
    fs.writeFileSync(COMMAND_FILE, JSON.stringify(commands, null, 2));
}

// API: Receive command from dashboard
app.post('/api/command', (req, res) => {
    const { command } = req.body;
    if (!command) {
        return res.status(400).json({ error: 'No command provided' });
    }
    
    saveCommand({ command });
    console.log(`[COMMAND] ${command}`);
    
    res.json({ success: true, message: 'Command queued' });
});

// API: Get command history
app.get('/api/commands', (req, res) => {
    res.json(getCommands());
});

// API: Mark command as processed
app.post('/api/commands/:id/processed', (req, res) => {
    const commands = getCommands();
    const cmd = commands.find(c => c.id === parseInt(req.params.id));
    if (cmd) {
        cmd.status = 'processed';
        fs.writeFileSync(COMMAND_FILE, JSON.stringify(commands, null, 2));
    }
    res.json({ success: true });
});

// API: Get leads
app.get('/api/leads', (req, res) => {
    const leadsFile = path.join(__dirname, 'leads.json');
    if (fs.existsSync(leadsFile)) {
        res.json(JSON.parse(fs.readFileSync(leadsFile, 'utf8')));
    } else {
        res.json([]);
    }
});

// API: Save leads
app.post('/api/leads', (req, res) => {
    const leadsFile = path.join(__dirname, 'leads.json');
    fs.writeFileSync(leadsFile, JSON.stringify(req.body, null, 2));
    res.json({ success: true });
});

// API: Get campaigns
app.get('/api/campaigns', (req, res) => {
    const campaignsFile = path.join(__dirname, 'campaigns.json');
    if (fs.existsSync(campaignsFile)) {
        res.json(JSON.parse(fs.readFileSync(campaignsFile, 'utf8')));
    } else {
        // Default campaigns
        const defaults = [
            {
                id: 'pisco-europe',
                name: 'PISCO — Europe Expansion',
                company: 'Placewell International Services',
                status: 'active',
                targets: [],
                stats: { targeted: 0, contacted: 0, replied: 0, booked: 0 }
            },
            {
                id: 'comare-mexico',
                name: 'COMARE — Mexico City',
                company: 'B2B Maintenance Services',
                status: 'draft',
                targets: [],
                stats: { targeted: 0, contacted: 0, replied: 0, booked: 0 }
            }
        ];
        fs.writeFileSync(campaignsFile, JSON.stringify(defaults, null, 2));
        res.json(defaults);
    }
});

// API: Save campaign
app.post('/api/campaigns', (req, res) => {
    const campaignsFile = path.join(__dirname, 'campaigns.json');
    fs.writeFileSync(campaignsFile, JSON.stringify(req.body, null, 2));
    res.json({ success: true });
});

// API: Expose gateway config to the Control UI
// Returns the gateway token so the UI can authenticate its WebSocket connection.
app.get('/api/config', (req, res) => {
    let fileToken = null;
    if (fs.existsSync(OPENCLAW_CONFIG_FILE)) {
        try {
            const config = JSON.parse(fs.readFileSync(OPENCLAW_CONFIG_FILE, 'utf8'));
            fileToken = config.gatewayToken || null;
        } catch (_) {}
    }
    // Prefer the live env var; fall back to whatever is persisted in openclaw.json
    const token = GATEWAY_TOKEN || fileToken;
    if (!token) {
        return res.status(503).json({ error: 'Gateway token not configured' });
    }
    res.json({ gatewayToken: token });
});

app.listen(PORT, () => {
    console.log(`🦞 Claw Dashboard running on port ${PORT}`);
});
