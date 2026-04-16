#!/bin/bash
# build_and_ship.sh — Auto-build HTML/CSS/JS tools from a prompt
# Usage: ./build_and_ship.sh "Build a timer app"
# Output: Working HTML file deployed to /data/workspace/PROJECTS/auto-built/

set -e
REQUEST="$1"
BUILD_DIR="/data/workspace/PROJECTS/auto-built/$(date '+%Y%m%d-%H%M%S')"
mkdir -p "$BUILD_DIR"

if [[ -z "$REQUEST" ]]; then
    echo "Usage: ./build_and_ship.sh \"Build a [type of tool]\""
    echo "Example: ./build_and_ship.sh \"Build a countdown timer\""
    exit 1
fi

echo "🔨 Building: $REQUEST"
echo "📁 Output: $BUILD_DIR"

REQUEST_LOWER=$(echo "$REQUEST" | tr '[:upper:]' '[:lower:]')

if echo "$REQUEST_LOWER" | grep -q "timer\|countdown\|stopwatch"; then
    cat > "$BUILD_DIR/index.html" <<'TIMER'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Countdown Timer</title>
<style>
*{box-sizing:border-box;margin:0;padding:0;font-family:system-ui,sans-serif}
body{min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center;background:#0f0f23;color:#fff}
input{padding:1rem;font-size:1.5rem;border:none;border-radius:12px;text-align:center;width:200px;background:#1a1a3e;color:#fff}
button{padding:.75rem 2rem;font-size:1rem;margin:.5rem;background:#e94560;border:none;border-radius:8px;color:#fff;cursor:pointer}
.timer{font-size:4rem;font-weight:bold;margin:2rem 0}
</style>
</head>
<body>
<h1>Countdown Timer</h1>
<input type="number" id="minutes" placeholder="Minutes" value="5">
<div class="timer" id="display">05:00</div>
<div>
<button onclick="start()">Start</button>
<button onclick="pause()">Pause</button>
<button onclick="reset()">Reset</button>
</div>
<script>
let time=0,interval=null;
const display=document.getElementById('display');
function format(t){return String(Math.floor(t/60)).padStart(2,'0')+':'+String(t%60).padStart(2,'0')}
function update(){display.textContent=format(time)}
function start(){if(interval)return;interval=setInterval(function(){time--;update();if(time<=0){clearInterval(interval);alert('Time up!')}},1000)}
function pause(){clearInterval(interval);interval=null}
function reset(){pause();time=document.getElementById('minutes').value*60||300;update()}
document.getElementById('minutes').onchange=function(){time=document.getElementById('minutes').value*60;update()};
reset();
</script>
</body>
</html>
TIMER
    echo "✅ Timer app built"

elif echo "$REQUEST_LOWER" | grep -q "quiz\|question\|trivia\|test"; then
    cat > "$BUILD_DIR/index.html" <<'QUIZ'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quiz App</title>
<style>
*{box-sizing:border-box;margin:0;padding:0;font-family:system-ui,sans-serif}
body{min-height:100vh;background:#1a1a2e;color:#fff;padding:2rem;display:flex;flex-direction:column;align-items:center}
.card{background:#16213e;padding:2rem;border-radius:16px;max-width:500px;width:100%}
.question{font-size:1.3rem;margin-bottom:1.5rem}
.options{display:flex;flex-direction:column;gap:.75rem}
button{padding:1rem;background:#0f3460;border:none;border-radius:8px;color:#fff;font-size:1rem;cursor:pointer;text-align:left}
button:hover{background:#e94560}
#next{margin-top:1rem;padding:.75rem 2rem;background:#e94560;border:none;border-radius:8px;color:#fff;cursor:pointer;display:none}
</style>
</head>
<body>
<div class="card">
<h1>Quick Quiz</h1>
<div class="question" id="question"></div>
<div class="options" id="options"></div>
<button id="next" onclick="nextQ()">Next</button>
</div>
<script>
var questions=[
{q:"What year did the iPhone launch?",o:["2005","2006","2007","2008"],a:2},
{q:"Who founded SpaceX?",o:["Bezos","Musk","Thiel","Gates"],a:1},
{q:"What does API stand for?",o:["App Programming Interface","Application Protocol Interface","Application Programming Interface","Advanced Program Interface"],a:2}
];
var qi=0,score=0;
function showQ(){
document.getElementById('question').textContent=questions[qi].q;
document.getElementById('options').innerHTML=questions[qi].o.map(function(o,i){
return '<button onclick="check(this,'+i+')">'+o+'</button>'}).join('');
document.getElementById('next').style.display='none';
}
function check(btn,i){
var correct=questions[qi].a;
document.querySelectorAll('button').forEach(function(b,j){b.disabled=true;if(j===correct)b.style.background='#22c55e'});
if(i===correct){score++;btn.style.background='#22c55e'}else{btn.style.background='#ef4444'}
document.getElementById('next').style.display='block';
}
function nextQ(){qi++;if(qi<questions.length){showQ()}else{alert('Score: '+score+'/'+questions.length);qi=0;score=0;showQ()}}
showQ();
</script>
</body>
</html>
QUIZ
    echo "✅ Quiz app built"

elif echo "$REQUEST_LOWER" | grep -q "calculator"; then
    cat > "$BUILD_DIR/index.html" <<'CALC'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Calculator</title>
<style>
*{box-sizing:border-box;margin:0;padding:0;font-family:system-ui,sans-serif}
body{min-height:100vh;display:flex;align-items:center;justify-content:center;background:#0f0f23}
.calc{background:#16213e;padding:1.5rem;border-radius:16px}
.display{background:#0f3460;color:#fff;font-size:2rem;text-align:right;padding:1rem;border-radius:8px;margin-bottom:1rem;min-width:260px;overflow:hidden}
.btns{display:grid;grid-template-columns:repeat(4,1fr);gap:.5rem}
button{padding:1.2rem;font-size:1.3rem;border:none;border-radius:8px;cursor:pointer;background:#1a1a3e;color:#fff}
button:hover{background:#2a2a4e}
button.op{background:#e94560}
button.eq{background:#22c55e}
</style>
</head>
<body>
<div class="calc">
<div class="display" id="display">0</div>
<div class="btns">
<button onclick="c()">C</button><button onclick="del()">Del</button><button onclick="op('%')">%</button><button class="op" onclick="op('/')">/</button>
<button onclick="num(7)">7</button><button onclick="num(8)">8</button><button onclick="num(9)">9</button><button class="op" onclick="op('*')">*</button>
<button onclick="num(4)">4</button><button onclick="num(5)">5</button><button onclick="num(6)">6</button><button class="op" onclick="op('-')">-</button>
<button onclick="num(1)">1</button><button onclick="num(2)">2</button><button onclick="num(3)">3</button><button class="op" onclick="op('+')">+</button>
<button onclick="num(0)" style="grid-column:span 2">0</button><button onclick="dot()">.</button><button class="eq" onclick="eq()">=</button>
</div></div>
<script>
var d='',last='';
var display=document.getElementById('display');
function num(n){d+=n;update()}
function op(o){d+=o;last=o;update()}
function c(){d='';update()}
function del(){d=d.slice(0,-1);update()}
function dot(){if(d.indexOf('.')<0){d+='.';update()}}
function eq(){try{d=String(eval(d));update()}catch(e){d='Error';update()}}
function update(){display.textContent=d||'0'}
</script>
</body>
</html>
CALC
    echo "✅ Calculator app built"

else
    cat > "$BUILD_DIR/index.html" <<'GENERIC'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Axton Mini Tool</title>
<style>
*{box-sizing:border-box;margin:0;padding:0;font-family:system-ui,sans-serif}
body{min-height:100vh;background:linear-gradient(135deg,#1a1a2e,#16213e);color:#fff;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:2rem}
.card{background:#0f3460;padding:3rem;border-radius:16px;text-align:center;max-width:500px}
h1{margin-bottom:1rem}
p{opacity:.7;margin-bottom:2rem}
small{opacity:.4;font-size:.8rem}
</style>
</head>
<body>
<div class="card">
<h1>Axton Mini Tool</h1>
<p>This tool was auto-generated by Axton's Build & Ship system.</p>
<p>Edit index.html to customize.</p>
<small>Built by Axton</small>
</div>
</body>
</html>
GENERIC
    echo "✅ Generic tool built"
fi

# Create README
cat > "$BUILD_DIR/README.md" <<EOF
# Build & Ship — $DATE

**Request:** $REQUEST

## Usage
Open \`index.html\` in any browser. No server needed.

## Deployment
Drop \`index.html\` on any static host.

---
*Auto-built by Axton*
EOF

# Log build
mkdir -p /data/workspace/PROJECTS/auto-built
echo "[$(date)] BUILT: $REQUEST" >> /data/workspace/PROJECTS/auto-built/BUILD_LOG.md

echo ""
echo "✅ Shipped!"
echo "   📁 $BUILD_DIR"
ls -la "$BUILD_DIR"
