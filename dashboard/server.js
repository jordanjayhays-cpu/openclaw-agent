const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// Attach version + cache-busting headers to every response
app.use((req, res, next) => {
  res.setHeader('X-Dashboard-Version', '2');
  res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');
  res.setHeader('Pragma', 'no-cache');
  res.setHeader('Expires', '0');
  res.setHeader('Surrogate-Control', 'no-store');
  next();
});

// Health check — returns JSON with a live timestamp so we can confirm
// the request is reaching this process and not a cached/intercepted response
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    version: 2,
    timestamp: new Date().toISOString(),
  });
});

// Root route — explicitly serve index.html with the correct content-type
app.get('/', (req, res) => {
  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Serve static files from the dashboard directory
app.use(express.static(path.join(__dirname)));

// Fallback: serve index.html for any unmatched route
app.get('*', (req, res) => {
  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Dashboard running on port ${PORT}`);
});
